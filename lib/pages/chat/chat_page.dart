import 'package:edu_vista/blocs/chat/chat_bloc.dart';
import 'package:edu_vista/blocs/message/messages_bloc.dart';
import 'package:edu_vista/models/user_model.dart';
import 'package:edu_vista/pages/chat/messages_page.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/chat/user_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chat';

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    context.read<ChatBloc>().add(GetUsersListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is UsersWithMessageHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersWithMessageHistoryLoaded) {
            final usersWithHistory = state.usersList;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: usersWithHistory.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final user = usersWithHistory[index];
                if (user.id != FirebaseAuth.instance.currentUser?.uid) {
                  return UserItem(user: user);
                }
                return const SizedBox();
              },
            );
          } else if (state is UsersWithMessageHistoryEmpty) {
            return Center(child: Text(state.message));
          } else if (state is UsersWithMessageHistoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(
            child: Text('No previous chat history found'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUsersDialog(context);
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  void _showUsersDialog(BuildContext context) {
    context.read<ChatBloc>().add(GetAllUsersListEvent());
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is AllUsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AllUsersLoaded) {
              final sortedUsers = state.usersList
                  .where((user) =>
                      user.id != FirebaseAuth.instance.currentUser?.uid)
                  .toList()
                ..sort((a, b) => a.name.compareTo(b.name));

              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Select a User to Chat',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: sortedUsers.length,
                          itemBuilder: (context, index) {
                            final user = sortedUsers[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: ColorUtility.deepYellow,
                                  child: Text(
                                    user.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    color: Colors.black45),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _startChatWithUser(user);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is AllUsersEmpty) {
              return Center(child: Text(state.message));
            } else if (state is AllUsersError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text('Loading Users...'));
          },
        );
      },
    );
  }

  void _startChatWithUser(UserModel user) {
    Navigator.pushNamed(
      context,
      MessagesPage.id,
      arguments: user,
    );
    context.read<MessagesBloc>().add(GetUserMessagesEvent(receiverId: user.id));
  }
}
