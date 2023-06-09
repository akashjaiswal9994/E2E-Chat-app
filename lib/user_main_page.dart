import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:major_project/API/apis.dart';
import 'package:major_project/model/user_chat.dart';
import 'package:major_project/profile_screen.dart';
import 'package:major_project/widget%20dir.dart/user_chat_card.dart';

class UserMainPage extends StatefulWidget {
  const UserMainPage({Key? key}) : super(key: key);

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
//  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<UserChat> list = [];
  final List<UserChat> _searchUser = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIS.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: ('Search....'),
                        fillColor: Colors.white),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    onChanged: (value) {
                      _searchUser.clear();
                      for (var i in list) {
                        if (i.name!
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.publicKey!.contains(value)) {
                          _searchUser.add(i);
                          setState(() {
                            _searchUser;
                          });
                        }
                      }
                    },
                  )
                : const Text('EnDi'),
            centerTitle: true,
            elevation: 1,
            leading: const Icon(CupertinoIcons.home),
            actions: [
              // search user button
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),

              // more information dot button
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(user: APIS.currentUser)));
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                addNewChatUserDialog();
              },
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.add_comment_rounded,
                color: Colors.white,
              ),
            ),
          ),
          body:StreamBuilder(
              stream: APIS.getMyUserId(),
              // to get id of known users only
              builder: (context,snapshot){

                switch (snapshot.connectionState) {
                // if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());

                //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
             return StreamBuilder(
                stream: APIS.getAllUser(snapshot.data?.docs.map((e) => e.id).toList()??[]),
                // get those users whose ids are provided
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
                      list =
                          data?.map((e) => UserChat.fromJson(e.data())).toList() ??
                              [];

                      if (list.isNotEmpty) {
                        return ListView.builder(
                            padding: const EdgeInsets.only(top: 8),
                            itemCount:
                            _isSearching ? _searchUser.length : list.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return UserChatCard(
                                  user: _isSearching
                                      ? _searchUser[index]
                                      : list[index]);
                            });
                      } else {
                        return const Center(
                            child: Text(
                              'No Connection found! Start new chat',
                              style:
                              TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                            ));
                      }
                  }
                },
              );

            }

          }),
        ),
      ),
    );
  }

  void logOutButton() {
    Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            autofocus: true,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text(
              'Logout',
              textAlign: TextAlign.center,
            )),
      ),
    );
  }

  void addNewChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_2_rounded,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add new user')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  hintText: 'email',
                    prefixIcon: Icon(Icons.email,color: Colors.blue,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if(email.isNotEmpty) {
                        await APIS.addChatUser(email).then((value) {
                          if(!value){
                            SnackBar(
                              content: Text('user does not exist'),
                            );
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
