import 'dart:typed_data';
import 'package:edu_vista/blocs/chat/chat_bloc.dart';
import 'package:edu_vista/widgets/chat/custom_chat_textformfield.dart';
import 'package:edu_vista/blocs/message/messages_bloc.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.receiverId});

  final String receiverId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();
  Uint8List? file;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: CustomChatTextFormField(
              controller: controller,
              hintText: 'Add Message...',
              labelText: '',
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: ColorUtility.deepYellow,
            radius: 20,
            child: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_right_outlined,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.64),
              ),
              onPressed: () => _sendText(context),
            ),
          ),
        ],
      );

  Future<void> _sendText(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      context.read<MessagesBloc>().add(
            SendTextMessageEvent(
              content: controller.text,
              receiverId: widget.receiverId,
            ),
          );
      context.read<ChatBloc>().add(GetUsersListEvent());

      controller.clear();
      FocusScope.of(context).unfocus();
    }
  }
}
