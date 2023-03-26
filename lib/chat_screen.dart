import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:major_project/model/messages.dart';
import 'package:major_project/model/user_chat.dart';
import 'package:major_project/widget%20dir.dart/message_card.dart';

import 'API/apis.dart';

class ChatScreen extends StatefulWidget {
  final UserChat userChat;
  const ChatScreen({Key? key, required this.userChat}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storing all messages
  List<Messages> list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          backgroundColor: Colors.blueGrey,
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        backgroundColor: Colors.blue.shade50,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIS.getAllMessages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    // if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());

                    //if some or all data is loaded then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      log('data: ${jsonEncode(data![0].data())}');
                      list.clear();
                      list.add(Messages(
                          send: "12:00",
                          toId: "xyz",
                          type: "check",
                          msg: "hi",
                          fromID: APIS.user.uid,
                          read: "no"));
                      list.add(Messages(
                          send: "12:06",
                          toId: APIS.user.uid,
                          type: "check",
                          msg: "hi",
                          fromID: "test1",
                          read: "no"));

                      if (list.isNotEmpty) {
                        return ListView.builder(
                            padding: const EdgeInsets.only(top: 8),
                            itemCount: list.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(
                                messages: list[index],
                              );
                            });
                      } else {
                        return Center(
                            child: Text(
                          'Say Hi to ${widget.userChat.name}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ));
                      }
                  }
                },
              ),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: CachedNetworkImage(
                width: 80,
                height: 50,
                fit: BoxFit.cover,
                imageUrl: widget.userChat.image as String,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userChat.name as String,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                'Last seen ',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w200),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          // input text field
          Expanded(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // emoji button
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),

                  const Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type Something.....',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.blueAccent),
                    ),
                  )),

                  // image button
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),

                  // camera button
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {},
            minWidth: 0,
            padding:
                const EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
            shape: const RoundedRectangleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
