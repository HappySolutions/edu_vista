part of 'messages_bloc.dart';

@immutable
abstract class MessagesEvent {}

class GetUserMessagesEvent extends MessagesEvent {
  final String receiverId;

  GetUserMessagesEvent({required this.receiverId});
}

class SendTextMessageEvent extends MessagesEvent {
  final String content;
  final String receiverId;

  SendTextMessageEvent({required this.content, required this.receiverId});
}

class AddImageMessageEvent extends MessagesEvent {
  final String receiverId;
  final Uint8List file;

  AddImageMessageEvent({required this.receiverId, required this.file});
}
