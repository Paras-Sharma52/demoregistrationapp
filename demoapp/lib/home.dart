import 'package:demoapp/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeScreen extends StatefulWidget {
  final UserCredential userCredential;
  HomeScreen({Key? key, required this.userCredential}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String notificationTitle = "title";
  @override
  void initState() {
    // TODO: implement initState
    terminted();
    super.initState();
  }

  void navigate() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Future listen() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        setState(() {
          notificationTitle = message.notification!.title!;
        });
        notificationTitle = message.notification!.title!;
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future terminted() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          notificationTitle = message.notification!.title!;
        });
        notificationTitle = message.notification!.title!;
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listen();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        leading: SizedBox.shrink(),
      ),
      body: Container(
        height: size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("current notificatio title ${notificationTitle}"),
              Text("current user Email ${widget.userCredential.user!.email}"),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  navigate();
                },
                child: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
