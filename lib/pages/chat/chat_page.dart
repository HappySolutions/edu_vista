import 'package:edu_vista/pages/chat/messages_page.dart';
import 'package:edu_vista/widgets/chat/contact_card_widget.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  static const String id = 'chat';

  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: demoContactsImage.length,
        itemBuilder: (context, index) => ContactCard(
          name: "Happy Ahmed",
          status: "Hello there",
          image: demoContactsImage[index],
          isActive: index.isEven,
          press: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MessagesPage()));
          },
        ),
      ),
    );
  }
}

final List<String> demoContactsImage = [
  'https://i.postimg.cc/g25VYN7X/user-1.png',
  'https://i.postimg.cc/cCsYDjvj/user-2.png',
  'https://i.postimg.cc/sXC5W1s3/user-3.png',
  'https://i.postimg.cc/4dvVQZxV/user-4.png',
  'https://i.postimg.cc/FzDSwZcK/user-5.png',
];
