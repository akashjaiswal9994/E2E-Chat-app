import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:major_project/model/messages.dart';
import 'package:major_project/model/user_chat.dart';

class APIS {
  //this is use for authenticating
  static FirebaseAuth auth = FirebaseAuth.instance;
  // this is use for cloud storage
  static FirebaseFirestore fireStoreFirebase = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  static late UserChat currentUser;

  //to generate pubic key
  static String randomUnique() {
    List<int> numbers =
        List.generate(10, (i) => i); // create a list of numbers from 0 to 9
    numbers.shuffle(); // shuffle the list

    String result = numbers.sublist(0, 6).join();
    return result;
  }

  // this is use for checking if user exist or not
  static Future<bool> userExist() async {
    return (await fireStoreFirebase
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // this is use for adding new user to our collection
  static Future<bool> addChatUser(String email) async {
    final data = await fireStoreFirebase
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      fireStoreFirebase
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }



  // to get my  users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUserId() {
    return fireStoreFirebase
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  // to get all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser(
      List<String> userIds) {
    return fireStoreFirebase
        .collection('users')
        .where('id', whereIn: userIds.isEmpty?['']:userIds)
        .snapshots();
  }

  // for getting current user info

  static Future<void> getCurrentUserInfo() async {
    await fireStoreFirebase
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        currentUser = UserChat.fromJson(user.data()!);
      } else {
        await newUser().then((value) => getCurrentUserInfo());
      }
    });
  }

  // in case creating new user
  static Future<void> newUser() async {
    final lastActiveTime = DateTime.now().millisecondsSinceEpoch.toString();
    final newChatUser = UserChat(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      lastActive: lastActiveTime,
      isOnline: false,
      image: user.photoURL.toString(),
      pushToken: '',
      publicKey: randomUnique(),
    );
    return (await fireStoreFirebase
        .collection('users')
        .doc(user.uid)
        .set(newChatUser.toJson()));
  }

  ///---------------- Chat screen related APIs ----------------

  //get conversation id
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // to get all the messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserChat userChat) {
    return fireStoreFirebase
        .collection(
            'chats/${getConversationId(userChat.id.toString())}/messages')
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessages(UserChat userChat, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Messages messages = Messages(
        toId: userChat.id,
        msg: msg,
        read: '',
        type: Type.text.toString(),
        fromID: user.uid,
        send: time);
    final ref = fireStoreFirebase.collection(
        'chats/${getConversationId(userChat.id.toString())}/messages');
    await ref.doc(time).set(messages.toJson());
  }

  // update read status of message
  static Future<void> updateMessageReadStatus(Messages messages) async {
    fireStoreFirebase
        .collection(
            'chats/${getConversationId(messages.fromID.toString())}/messages')
        .doc(messages.send)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
}
