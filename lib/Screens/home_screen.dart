import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:testing_app/Screens/Email%20Auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    // replace with first page
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: const Center(
        child: Text("Home Screen"),
      ),
    );
  }
}
