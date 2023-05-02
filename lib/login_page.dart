import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:major_project/Uitlity/progress_bar.dart';
import 'package:major_project/app_colors.dart';
import 'package:major_project/app_style.dart';
import 'package:major_project/auth_functions.dart';
import 'package:major_project/responsive_app.dart';
import 'package:major_project/sign_up_page.dart';
import 'package:major_project/user_main_page.dart';
import 'package:xen_popup_card/xen_card.dart';
//import 'package:major_project/user_main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   FirebaseAuth auth = FirebaseAuth.instance;
   bool loading =false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  final emailController = TextEditingController();
  String password = " ";
  bool isPasswordVisible = false;

  @override
  void initstate() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });
  }

  Widget buildEmail() => TextFormField(
        controller: emailController,
        key: ValueKey(email),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
         // hintText: 'akash@example.com',
          labelText: 'Email',
          prefixIcon: const Icon(Icons.mail),
          suffixIcon: emailController.text.isEmpty
              ? Container(
                  width: 0,
                )
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    emailController.clear();
                  },
                ),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter email';
          } else if (!value.contains('@')) {
            return 'Please enter correct email';
          }
          return null;
        },
        onSaved: (value) {
          setState(() {
            email = value!;
          });
        },
      );
  Widget buildPassword() => TextFormField(
        key: ValueKey(password),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: '**************',
          labelText: 'Password',
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: isPasswordVisible
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: () {
              setState(() => isPasswordVisible = !isPasswordVisible);
            },
          ),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter password';
          }
          return null;
        },
        onSaved: (value) {
          setState(() {
            password = value!;
          });
        },
        obscureText: isPasswordVisible,
      );
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.backColor,
        body: SizedBox(
          height: height,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ResponsiveWidget.isSmallScreen(context)
                  ? const SizedBox()
                  : Expanded(
                      child: Container(
                      height: height,
                      color: AppColor.mainBlueColor,
                      child: Center(
                        child: Text(
                          'EnDi Message',
                          style: ralewayStyle.copyWith(
                            fontSize: 48.0,
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )),
              SizedBox(
                width: width * 0.1,
              ),

              // login area UI

              Expanded(
                  child: Container(
                height: height,
                margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveWidget.isSmallScreen(context)
                        ? height * 0.032
                        : height * 0.12),
                color: AppColor.backColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.145,
                        ),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Let`s',
                                style: ralewayStyle.copyWith(
                                  fontSize: 25.0,
                                  color: AppColor.blueDarkColor,
                                  fontWeight: FontWeight.normal,
                                )),
                            TextSpan(
                              text: ' Log In',
                              style: ralewayStyle.copyWith(
                                fontSize: 25.0,
                                color: AppColor.blueDarkColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Hey! Enter your details to login in \nto your account.',
                            style: ralewayStyle.copyWith(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: AppColor.textColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.034,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildEmail(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildPassword(),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: ()  {
                              showDialog(
                                context: context,
                                builder: (builder) => Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: XenPopupCard(
                                    appBar: const XenCardAppBar(child: Text('Forgot Password'),

                                    ),
                                    body: ListView(
                                      children: [
                                       buildEmail(),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        ElevatedButton(onPressed: (){
                                         auth.sendPasswordResetEmail(email: emailController.text.toString());
                                         Navigator.of(context).pop();
                                        }, child: const Text("Submit"))

                                      ],
                                    ),
                                  ),
                                ),
                              );

                            },
                            child: Text(
                              'Forgot Password ?',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                color: AppColor.mainBlueColor,
                              ),
                            ),
                          ),
                        ),
                         Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: (){


                                if(_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Container(
                                          height: 20,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: const Text('Processing Data',textAlign: TextAlign.center)),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  _formKey.currentState!.save();

                                  AuthServices.signInUser(email, password, context);


                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.

                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserMainPage()));*/
                                }
                              },
                              child: const Text('Log In'),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Not a member ?  '),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpPage()),(route) => false);
                                },
                                child: const Text('Sign Up'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
