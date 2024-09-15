import 'package:edu_vista/blocs/message/messages_bloc.dart';
import 'package:edu_vista/models/user_model.dart';
import 'package:edu_vista/widgets/chat/chat_messages.dart';
import 'package:edu_vista/widgets/chat/chat_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesPage extends StatefulWidget {
  final UserModel user;

  const MessagesPage({super.key, required this.user});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  void initState() {
    context
        .read<MessagesBloc>()
        .add(GetUserMessagesEvent(receiverId: widget.user.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.user.photo_url.isNotEmpty
                  ? NetworkImage(widget.user.photo_url)
                  : const AssetImage('assets/images/logo.png') as ImageProvider,
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.user.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: widget.user.isOnline ? Colors.green : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ChatMessages(receiverId: widget.user.id),
            ),
            ChatTextField(receiverId: widget.user.id),
          ],
        ),
      ),
    );
  }
}
