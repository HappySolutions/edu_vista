import 'package:edu_vista/blocs/chat/chat_bloc.dart';
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
      backgroundColor: Colors.white,
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is UsersListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UsersListEmpty) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is UsersListLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.usersList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => state.usersList[index].id !=
                      FirebaseAuth.instance.currentUser?.uid
                  ? UserItem(user: state.usersList[index])
                  : const SizedBox(),
            );
          } else if (state is UsersListError) {
            return Center(
              child: Text(state.message),
            );
          }

          return const Center(
            child: Text('Users Loading'),
          );
        },
      ),
    );
  }
}
