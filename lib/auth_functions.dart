import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:major_project/user_main_page.dart';
import 'API/apis.dart';
import 'Uitlity/progress_bar.dart';
import 'firebase_data_save.dart';

class AuthServices {
  static signupUser(
      String email, String password, String name, BuildContext context) async {
    Dialogs.showProgressBar(context);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await FirestoreServices.saveUser(name, email, userCredential.user!.uid);
      await APIS.newUser().then((value){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (
                context) => const UserMainPage()), (
                route) => false);
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
            height: 20,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: const Text(
              'Registration Successful',
              textAlign: TextAlign.center,
            )),
        behavior: SnackBarBehavior.floating,
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              height: 20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Text(
                'Password Provided is too weak',
                textAlign: TextAlign.center,
              )),
          behavior: SnackBarBehavior.floating,
        ));

      } else if (e.code == 'email-already-in-use') {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              height: 20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Text(
                'Email Provided already Exists',

                textAlign: TextAlign.center,
              )),
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.pop(context);

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(

        content: Container(
            height: 20,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(e.toString())),
        behavior: SnackBarBehavior.floating,
      ));

    }
  }

  static signInUser(String email, String password, BuildContext context) async {
    Dialogs.showProgressBar(context);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              height: 20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Text('You are Logged in'))));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No user Found with this Email'),
          behavior: SnackBarBehavior.floating,
        ));
      } else if (e.code == 'wrong-password') {
         Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password did not match'),

          behavior: SnackBarBehavior.floating,
        ));
      }


    }
  }
}
