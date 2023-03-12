import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_app/Screens/Email%20Auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? profilepic;

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => LoginScreen()));
  }

  void saveUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String ageString = ageController.text.trim();

    int age = int.parse(ageString);
    nameController.clear();
    emailController.clear();
    ageController.clear();

    if (name != "" && email != "") {
      // UploadTask uploadTask = FirebaseStorage.instance.ref().child("profilepictures").child(Uuid().v1()).putFile(profilepic!);

      // StreamSubscription taskSubscription = uploadTask.snapshotEvents.listen((snapshot) {
      //   double percentage = snapshot.bytesTransferred/snapshot.totalBytes * 100;
      //   log(percentage.toString());
      // });

      // TaskSnapshot taskSnapshot = await uploadTask;
      // String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // taskSubscription.cancel();

      Map<String, dynamic> userData = {
        "name": name,
        "email": email,
        "age": age,
        // "profilepic": downloadUrl,
        // "samplearray": [name, email, age]
      };
      FirebaseFirestore.instance.collection("users").add(userData);
      log("User created!");
    } else {
      log("Please fill all the fields!");
    }

    // setState(() {
    //   profilepic = null;
    // });
  }

  // void getInitialMessage() async {
  //   RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

  //   if(message != null) {
  //     if(message.data["page"] == "email") {
  //       Navigator.push(context, CupertinoPageRoute(
  //         builder: (context) => SignUpScreen()
  //       ));
  //     }
  //     else if(message.data["page"] == "phone") {
  //       Navigator.push(context, CupertinoPageRoute(
  //         builder: (context) => SignInWithPhone()
  //       ));
  //     }
  //     else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text("Invalid Page!"),
  //         duration: Duration(seconds: 5),
  //         backgroundColor: Colors.red,
  //       ));
  //     }
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   getInitialMessage();

  //   FirebaseMessaging.onMessage.listen((message) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(message.data["myname"].toString()),
  //       duration: Duration(seconds: 10),
  //       backgroundColor: Colors.green,
  //     ));
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("App was opened by a notification"),
  //       duration: Duration(seconds: 10),
  //       backgroundColor: Colors.green,
  //     ));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CupertinoButton(
                onPressed: () async {
                  XFile? selectedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (selectedImage != null) {
                    File convertedFile = File(selectedImage.path);
                    setState(() {
                      profilepic = convertedFile;
                    });
                    log("Image selected!");
                  } else {
                    log("No image selected!");
                  }
                },
                padding: EdgeInsets.zero,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      (profilepic != null) ? FileImage(profilepic!) : null,
                  backgroundColor: Colors.grey,
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Name"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Email Address"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(hintText: "Age"),
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                onPressed: () {
                  saveUser();
                },
                child: const Text("Save"),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map userMap =
                                  snapshot.data!.docs[index].data() as Map;
                              return ListTile(
                                title: Text(userMap["name"]),
                                subtitle: Text(userMap["email"]),
                                trailing: GestureDetector(
                                    onTap: () {}, child: Icon(Icons.delete)),
                              );
                            }),
                      );
                    } else {
                      return Text("No data");
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },

                // stream: FirebaseFirestore.instance
                //     .collection("users")
                //     .where("age", isGreaterThanOrEqualTo: 19)
                //     .orderBy("age", descending: true)
                //     .snapshots(),
                // builder: (context, snapshot) {
                //   if (snapshot.connectionState == ConnectionState.active) {
                //     if (snapshot.hasData && snapshot.data != null) {
                //       return Expanded(
                //         child: ListView.builder(
                //           itemCount: snapshot.data!.docs.length,
                //           itemBuilder: (context, index) {
                //             Map<String, dynamic> userMap =
                //                 snapshot.data!.docs[index].data()
                //                     as Map<String, dynamic>;

                //             return ListTile(
                //               leading: CircleAvatar(
                //                 backgroundImage:
                //                     NetworkImage(userMap["profilepic"]),
                //               ),
                //               title: Text(
                //                   userMap["name"] + " (${userMap["age"]})"),
                //               subtitle: Text(userMap["email"]),
                //               trailing: IconButton(
                //                 onPressed: () {
                //                   // Delete
                //                 },
                //                 icon: Icon(Icons.delete),
                //               ),
                //             );
                //           },
                //         ),
                //       );
                //     } else {
                //       return Text("No data!");
                //     }
                //   } else {
                //     return Center(
                //       child: CircularProgressIndicator(),
                //     );
                //   }
                // },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
