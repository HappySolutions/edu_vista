part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class GetUsersListEvent extends ChatEvent {}

class GetAllUsersListEvent extends ChatEvent {} // New event to fetch all users
