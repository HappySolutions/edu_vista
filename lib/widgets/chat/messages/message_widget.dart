import 'package:edu_vista/models/chat_message.dart';
import 'package:edu_vista/utils/app_enums.dart';
import 'package:edu_vista/widgets/chat/messages/message_status_widget.dart';
import 'package:edu_vista/widgets/chat/messages/text_message_widget.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.audio:
          return TextMessage(message: message);
        case ChatMessageType.video:
          return const TextMessage();
        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            const CircleAvatar(
              radius: 12,
              backgroundImage:
                  NetworkImage("https://i.postimg.cc/cCsYDjvj/user-2.png"),
            ),
            const SizedBox(width: 16.0 / 2),
          ],
          messageContaint(message),
          if (message.isSender) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}
