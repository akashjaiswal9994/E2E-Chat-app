import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:major_project/model/user_chat.dart';



class ProfileScreen extends StatefulWidget {
  final UserChat user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //app bar
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
            title: Text(
          widget.user.name as String,
          textAlign: TextAlign.end,
        )),
        floatingActionButton: //user about
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Joined On: ',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ],
        ),

        //body
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Card(
              elevation: 6,
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  // for adding some space

                  //user profile picture
                  const SizedBox(height: 10),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: CachedNetworkImage(
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.image as String,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                  ),

                  // for adding some space
                  const SizedBox(height: 10),
                  Text(widget.user.name as String,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16)),
                  const SizedBox(
                    width: 5,
                  ),
                  // user email label
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Public Key:',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(widget.user.publicKey as String,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 16)),
                      ],
                    ),
                  ),

                  // for adding some space
                  const SizedBox(height: 6),

                  //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text('hi ,Im ${widget.user.name as String}',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15)),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                    ),
                  ),

                  // logout button
                  ElevatedButton(
                      onPressed: ()   {
                        FirebaseAuth.instance.signOut();
                       Navigator.pop(context);
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.black87),
                      ),),
                  const SizedBox(height: 10,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

