import 'package:demoapp/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserRegister extends StatefulWidget {
  UserRegister({Key? key}) : super(key: key);

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  bool isLoading = false;

  Future createAccount(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("user signedIn $credential");
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: "The password provided is too weak",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print('The account already exists for that email.');
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something Went Wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e);
    }
  }

  void navigate(UserCredential userCredential) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(userCredential: userCredential)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Email"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Email Address";
                    } else if (!value.contains('@')) {
                      return "Enter a Valid Email";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Password"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Password";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Password"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Password";
                    }
                    if (value != passwordController.text) {
                      return "Password Not Match";
                    }
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      final usercr = await createAccount(
                          emailController.text, passwordController.text);
                      setState(() {
                        isLoading = false;
                      });
                      isLoading && usercr == null ? null : navigate(usercr);
                    }
                  },
                  child:
                      isLoading ? CircularProgressIndicator() : Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
