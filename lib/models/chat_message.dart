import 'package:edu_vista/utils/app_enums.dart';

class ChatMessage {
  final String senderId;
  final String receiverId;
  final String content;
  final ChatMessageType messageType;

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.messageType,
  });
}
