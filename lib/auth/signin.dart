import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:imagi_go_ai/auth/signup.dart';
import 'package:imagi_go_ai/features/home.dart';
import 'package:imagi_go_ai/features/main_screen.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';

class Signin extends StatefulWidget {
  Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final emailTextEditingController = TextEditingController();

  final passwordTextEditingController = TextEditingController();

  bool isSwitched = false;

  void signin() {
    final auth = FirebaseAuth.instance;
    if (emailTextEditingController.text.isEmpty) {
      notify(context, 'Enter your email');
    } else if (passwordTextEditingController.text.isEmpty) {
      notify(context, 'Enter your password');
    } else {
      MyProgressIndicator.show(context);
      auth.signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
      ).then((onValue){
        MyProgressIndicator.hide(context);
        notify(context, "Login Successful");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      }).catchError((e){
        MyProgressIndicator.hide(context);
        notify(context, e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 20),
        
              Align(
                alignment: Alignment.topLeft,
                child: MyText(
                  text: "Login Your\nAccount",
                  fontSize: 44,
                  bold: true,
                ),
              ),
              SizedBox(height: 20),
        
              MyTextField(
                icon: Icon(Icons.email_outlined, color: Color(0xFF6C63FF)),
                hintText: "abc@gmail.com",
                controller: emailTextEditingController,
                label: "Enter your username or email",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 8),
        
              MyTextField(
                icon: Icon(Icons.lock_outline, color: Color(0xFF6C63FF)),
                hintText: "",
                controller: passwordTextEditingController,
                label: "Password",
                isPassword: true,
              ),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        activeColor: Color(0xFF6C63FF), // ON color
                        inactiveThumbColor: Colors.grey,
        
                        // OFF color
                      ),
                      MyText(text: "Save Me", fontSize: 16),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: MyText(text: "Forget Password?"),
                  ),
                ],
              ),
        
              SizedBox(height: 25),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: signin,
                  child: MyText(text: "Login", bold: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                  ),
                ),
              ),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(text: "Create New Account"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: MyText(text: "Sign up"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey, // Line color
                thickness: 1, // Line thickness
                indent: 16, // Start padding
                endIndent: 16, // End padding
              ),
              SizedBox(height: 20),
              MyText(text: "Continue With Accounts"),
              SizedBox(height: 20),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: (Theme.of(context).brightness == Brightness.dark)
                          ? const Color.fromARGB(255, 30, 28, 60)
                          : const Color.fromARGB(255, 195, 191, 242),
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // 👈 Rounded corners here
                    ),
                    height: 100,
                    width: 150,
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.google,
                        size: 45,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: (Theme.of(context).brightness == Brightness.dark)
                          ? const Color.fromARGB(255, 30, 28, 60)
                          : const Color.fromARGB(255, 195, 191, 242),
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // 👈 Rounded corners here
                    ),
                    height: 100,
                    width: 150,
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.facebook,
                        size: 50,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
