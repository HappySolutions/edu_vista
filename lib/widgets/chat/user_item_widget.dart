// ignore_for_file: avoid_print

import 'package:edu_vista/blocs/message/messages_bloc.dart';
import 'package:flutter/material.dart';
import 'package:edu_vista/models/user_model.dart';
import 'package:edu_vista/pages/chat/messages_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user});

  final UserModel user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<MessagesBloc>(context),
              child: MessagesPage(user: widget.user),
            ),
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: widget.user.photo_url.isNotEmpty
                    ? NetworkImage(widget.user.photo_url)
                    : null,
                onBackgroundImageError: widget.user.photo_url.isNotEmpty
                    ? (error, stackTrace) {
                        print('Image failed to load: $error');
                        setState(() {});
                      }
                    : null,
                child: widget.user.photo_url.isEmpty
                    ? const Icon(Icons.person, size: 30)
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundColor:
                      widget.user.isOnline ? Colors.green : Colors.grey,
                  radius: 5,
                ),
              ),
            ],
          ),
          title: Text(
            widget.user.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget.user.email,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 15,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
}
