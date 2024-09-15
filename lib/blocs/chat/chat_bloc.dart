import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/message_model.dart';
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

    on<GetUsersListEvent>(_onGetUsersList);
  }
  List<UserModel> usersList = [];
  List<UserModel> search = [];

  FutureOr<void> _onGetUsersList(
      GetUsersListEvent event, Emitter<ChatState> emit) async {
    emit(UsersListLoading());
    try {
      usersList = await getUsersList();

      if (usersList.isEmpty) {
        emit(UsersListEmpty(message: 'There are no users in the room now'));
      } else {
        emit(UsersListLoaded(usersList: usersList));
      }
    } catch (e) {
      emit(UsersListError(message: e.toString()));
    }
  }
  
Future<List<UserModel>> getUsersList() async {
    try {
      QuerySnapshot response =
          await FirebaseFirestore.instance.collection('users').get();

      List<UserModel> users = response.docs.map((doc) {
        return UserModel.fromDocument(doc); // Pass the doc directly here
      }).toList();

      return users;
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
