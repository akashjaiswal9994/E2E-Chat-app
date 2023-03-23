import 'package:flutter/material.dart';
import 'package:major_project/model/user_chat.dart';

import '../chat_screen.dart';

class UserChatCard extends StatefulWidget {
  final UserChat user;

  const UserChatCard({Key? key, required this.user}) : super(key: key);

  @override
  State<UserChatCard> createState() => _UserChatCardState();
}

class _UserChatCardState extends State<UserChatCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      elevation: 4,
      color: Colors.blue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        // navigate to user chat screen
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) =>  ChatScreen(userChat: widget.user )));
        },
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person_2_rounded),
          ),
          title: Text(widget.user.name as String),
          subtitle: const Text(
            'unread message',
            maxLines: 1,
          ),
          trailing: Text(widget.user.lastActive as String),
        ),
      ),
    );
  }
}
