import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testing_app/Screens/Email%20Auth/login_screen.dart';
import 'package:testing_app/Screens/home_screen.dart';
import 'package:testing_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ///// for all collection data
  // QuerySnapshot snapshot =
  //     await FirebaseFirestore.instance.collection("users").get();
  // for (var doc in snapshot.docs) {
  //   print(doc.data().toString());
  // }

  // DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //     .collection("users")
  //     .doc("Yw1th07oKjeMsO8EdOQg")
  //     .get();
  // print(snapshot.data());

  Map<String, dynamic> newUser = {
    "name": "Faizan",
    "email": "Faizan@gmail.com",
  };
  // await firestore.collection("users").add(newUser);

  // await firestore.collection("users").doc("id-newUser").set(newUser);

  // await firestore
  //     .collection("users")
  //     .doc("id-newUser")
  //     .update({"email": "Faizannew@gmail.com"});

  await firestore.collection("users").doc("id-newUser").delete();

  print("New user update");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Test App',
            builder: EasyLoading.init(),
            home: (FirebaseAuth.instance.currentUser != null)
                ? const HomeScreen()
                : const HomeScreen(),
          );
        });
  }
}
