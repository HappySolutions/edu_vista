part of 'messages_bloc.dart';

@immutable
abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class UserMessagesLoading extends MessagesState {}

class UserMessagesLoaded extends MessagesState {
  final List<MessageModel> userMessages;

  UserMessagesLoaded({required this.userMessages});
}

class UserMessagesEmpty extends MessagesState {
  final String message;

  UserMessagesEmpty({required this.message});
}

class UserMessagesError extends MessagesState {
  final String message;

  UserMessagesError({required this.message});
}
