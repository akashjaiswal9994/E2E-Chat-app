
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // to get all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return fireStoreFirebase
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for getting current user info

  static Future<void> getCurrentUserInfo() async {
    await fireStoreFirebase.collection('users').doc(user.uid).get().then((user) async {
      if(user.exists){
        currentUser=UserChat.fromJson(user.data()!);
      }else{
        await newUser().then((value) => getCurrentUserInfo());
      }
    });
  }

  // in case creating new user
  static Future<void> newUser() async {
    final time = DateTime.now().toString();
    final newChatUser = UserChat(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      lastActive: time,
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

  // to get all the messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return fireStoreFirebase
        .collection('messages')
        .snapshots();
  }

}
