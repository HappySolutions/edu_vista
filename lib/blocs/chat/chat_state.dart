part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class UsersWithMessageHistoryLoading extends ChatState {}

class UsersWithMessageHistoryLoaded extends ChatState {
  final List<UserModel> usersList;
  UsersWithMessageHistoryLoaded({required this.usersList});
}

class UsersWithMessageHistoryEmpty extends ChatState {
  final String message;
  UsersWithMessageHistoryEmpty({required this.message});
}

class UsersWithMessageHistoryError extends ChatState {
  final String message;
  UsersWithMessageHistoryError({required this.message});
}

// States for all users (used by the FAB dialog)
class AllUsersLoading extends ChatState {}

class AllUsersLoaded extends ChatState {
  final List<UserModel> usersList;
  AllUsersLoaded({required this.usersList});
}

class AllUsersEmpty extends ChatState {
  final String message;
  AllUsersEmpty({required this.message});
}

class AllUsersError extends ChatState {
  final String message;
  AllUsersError({required this.message});
}
