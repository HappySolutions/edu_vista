import 'package:edu_vista/widgets/chat/circle_avata_widget.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.name,
    required this.status,
    required this.image,
    required this.isActive,
    required this.press,
  });

  final String name, status, image;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0 / 2),
      onTap: press,
      leading: CircleAvatarWithActiveIndicator(
        image: image,
        isActive: isActive,
        radius: 28,
      ),
      title: Text(name),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 16.0 / 2),
        child: Text(
          status,
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.64),
          ),
        ),
      ),
    );
  }
}
