part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class UsersListLoading extends ChatState {}

class UsersListLoaded extends ChatState {
  final List<UserModel> usersList;
  UsersListLoaded({required this.usersList});
}

class UsersListEmpty extends ChatState {
  final String message;
  UsersListEmpty({required this.message});
}

class UsersListError extends ChatState {
  final String message;
  UsersListError({required this.message});
}
