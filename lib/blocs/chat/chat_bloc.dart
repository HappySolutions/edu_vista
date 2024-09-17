import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) {
      emit(ChatInitial());
    });

    // Separate handler for fetching users with message history
    on<GetUsersListEvent>(_onGetUsersList);

    // Separate handler for fetching all users (used by the FAB dialog)
    on<GetAllUsersListEvent>(_onGetAllUsersList);
  }
  List<UserModel> usersWithHistory = [];
  // Event handler for fetching users with message history (for the chat page)
  FutureOr<void> _onGetUsersList(
      GetUsersListEvent event, Emitter<ChatState> emit) async {
    emit(
        UsersWithMessageHistoryLoading()); // New state for loading users with message history
    try {
      final usersWithHistory = await getUsersWithMessageHistory();

      if (usersWithHistory.isEmpty) {
        emit(UsersWithMessageHistoryEmpty(
            message: 'No previous chat history found'));
      } else {
        emit(UsersWithMessageHistoryLoaded(usersList: usersWithHistory));
      }
    } catch (e) {
      emit(UsersWithMessageHistoryError(message: e.toString()));
    }
  }

  // Event handler for fetching all users (used by the FAB dialog)
  FutureOr<void> _onGetAllUsersList(
      GetAllUsersListEvent event, Emitter<ChatState> emit) async {
    emit(AllUsersLoading());

    try {
      final allUsers = await getAllUsers();

      if (allUsers.isEmpty) {
        emit(AllUsersEmpty(message: 'No users found.'));
      } else {
        emit(AllUsersLoaded(usersList: allUsers));
      }
    } catch (e) {
      emit(AllUsersError(message: e.toString()));
    }
  }

  // Fetch users with previous message history (existing functionality)
  Future<List<UserModel>> getUsersWithMessageHistory() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot userSnapshots =
          await FirebaseFirestore.instance.collection('users').get();

      for (var userDoc in userSnapshots.docs) {
        UserModel user = UserModel.fromDocument(userDoc);
        QuerySnapshot chatSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('chat')
            .doc(user.id)
            .collection('messages')
            .limit(1)
            .get();

        if (chatSnapshot.docs.isNotEmpty && user.id != currentUserId) {
          usersWithHistory.add(user);
        }
      }

      return usersWithHistory;
    } catch (e) {
      throw Exception('Error fetching users with message history: $e');
    }
  }

  // Fetch all users (new functionality for the FAB dialog)
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot response =
          await FirebaseFirestore.instance.collection('users').get();

      List<UserModel> users = response.docs.map((doc) {
        return UserModel.fromDocument(doc);
      }).toList();

      return users;
    } catch (e) {
      throw Exception('Error fetching all users: $e');
    }
  }
}
