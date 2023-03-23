import 'package:flutter/material.dart';
import 'package:major_project/API/apis.dart';
import 'package:major_project/app_colors.dart';
import 'package:major_project/app_style.dart';
import 'package:major_project/auth_functions.dart';
import 'package:major_project/login_page.dart';
import 'package:major_project/responsive_app.dart';
import 'package:major_project/user_main_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();
  String password = "";
  String email = "";
  String name = "";
  bool isPasswordVisible = false;

  Widget buildName() => TextFormField(
        key: ValueKey(name),
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          hintText: 'akash',
          labelText: 'Full Name',
          prefixIcon: Icon(Icons.person_2_rounded),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter full  name';
          }
          return null;
        },
        onSaved: (value) {
          setState(() {
            name = value!;
          });
        },
      );
  Widget buildEmail() => TextFormField(
        controller: emailController,
        key: ValueKey(email),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: 'akash@example.com',
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
          if (value!.length < 6) {
            return 'Please Enter Password of min length 6';
          } else {
            return null;
          }
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
                    key: _signUpFormKey,
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
                              text: ' Set Up Your Account ',
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
                            'Hey! Enter your details to Set up in \nto your account.',
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
                          child: buildName(),
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
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: () async {
                                if (_signUpFormKey.currentState!.validate()) {
                                  _signUpFormKey.currentState!.save();
                                  AuthServices.signupUser(email, password, name, context);
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                        content: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: const Text('Processing Data')),
                                      behavior: SnackBarBehavior.floating,),
                                  );


                                }
                              },
                              child: const Text('Sign Up'),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already a member ?  '),
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
                                              const LoginPage()),(route) => false);
                                },
                                child: const Text('LogIn'),
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
