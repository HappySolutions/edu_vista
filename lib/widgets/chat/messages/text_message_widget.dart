import 'package:edu_vista/models/chat_message.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    super.key,
    this.message,
  });

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0 * 0.75,
        vertical: 16.0 / 2,
      ),
      decoration: BoxDecoration(
        color: ColorUtility.deepYellow,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        message!.content,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
    );
  }
}
