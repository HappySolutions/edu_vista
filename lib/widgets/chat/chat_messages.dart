import 'package:edu_vista/blocs/message/messages_bloc.dart';
import 'package:edu_vista/models/message_model.dart';
import 'package:edu_vista/widgets/chat/empty_widget.dart';
import 'package:edu_vista/widgets/chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessages extends StatelessWidget {
  final String receiverId;

  const ChatMessages({super.key, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesBloc, MessagesState>(
      builder: (context, state) {
        if (state is UserMessagesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserMessagesLoaded) {
          if (state.userMessages.isEmpty) {
            return const Expanded(
              child: EmptyWidget(
                icon: Icons.waving_hand,
                text: 'Say Hello!',
              ),
            );
          } else {
            return Expanded(
              child: ListView.builder(
                controller: context.read<MessagesBloc>().scrollController,
                itemCount: state.userMessages.length,
                itemBuilder: (context, index) {
                  final message = state.userMessages[index];
                  final isTextMessage = message.messageType == MessageType.text;
                  final isMe = receiverId != message.senderId;

                  return MessageBubble(
                    isMe: isMe,
                    message: message,
                    isImage: !isTextMessage, // Check if message is an image
                  );
                },
              ),
            );
          }
        } else if (state is UserMessagesError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const Center(child: Text('Start a conversation'));
      },
    );
  }
}
