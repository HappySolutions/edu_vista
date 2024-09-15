import 'package:edu_vista/models/message_model.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.isImage,
    required this.message,
  });

  final bool isMe;
  final bool isImage;
  final MessageModel message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: isMe ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? ColorUtility.deepYellow : Colors.grey,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
          ),
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              isImage
                  ? Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(message.content),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Text(message.content,
                      style: const TextStyle(color: Colors.white)),
              // const SizedBox(height: 5),
              // Text(
              //   message.sentTime.toString(),
              //   style: const TextStyle(
              //     color: Colors.white,
              //     fontSize: 10,
              //   ),
              // ),
            ],
          ),
        ),
      );
}
