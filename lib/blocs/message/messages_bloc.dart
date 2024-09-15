import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final ScrollController scrollController = ScrollController();

  MessagesBloc() : super(MessagesInitial()) {
    on<MessagesEvent>((event, emit) {
      emit(MessagesInitial());
    });

    on<GetUserMessagesEvent>(_getUserMessages);

    on<SendTextMessageEvent>(_sendTextMessage);
  }

  FutureOr<void> _sendTextMessage(SendTextMessageEvent event, emit) async {
    if (event.content.isNotEmpty) {
      emit(UserMessagesLoading());
      try {
        await addTextMessage(
          content: event.content,
          receiverId: event.receiverId,
        );

        // Fetch updated messages and emit state
        final messages = await getMessages(event.receiverId);
        emit(UserMessagesLoaded(userMessages: messages));
        // Scroll to the bottom
        scrollToBottom();
      } catch (error) {
        emit(UserMessagesError(message: "Failed to send text message: $error"));
      }
    }
  }

  FutureOr<void> _getUserMessages(GetUserMessagesEvent event, emit) async {
    emit(UserMessagesLoading());

    try {
      final messages = await getMessages(event.receiverId);

      if (messages.isNotEmpty) {
        emit(UserMessagesLoaded(userMessages: messages));
      } else {
        emit(UserMessagesEmpty(message: "No messages found."));
      }
    } catch (error) {
      emit(UserMessagesError(message: error.toString()));
    }
  }

  // Fetch messages from Firestore
  Future<List<MessageModel>> getMessages(String receiverId) async {
    final List<MessageModel> messages = [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chat')
          .doc(receiverId)
          .collection('messages')
          .orderBy('sentTime', descending: false)
          .get();

      messages.addAll(snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList());
    } catch (e) {
      throw Exception("Failed to load messages: $e");
    }

    return messages;
  }

  // Add a text message to Firestore
  static Future<void> addTextMessage({
    required String content,
    required String receiverId,
  }) async {
    final message = MessageModel(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _addMessageToChat(receiverId, message);
  }

  // Add a message to the chat
  static Future<void> _addMessageToChat(
    String receiverId,
    MessageModel message,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(message.toJson());
  }

  // Scroll to the bottom of the message list
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }
}
