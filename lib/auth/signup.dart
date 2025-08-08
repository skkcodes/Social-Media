import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imagi_go_ai/auth/signin.dart';
import 'package:imagi_go_ai/features/home.dart';
import 'package:imagi_go_ai/features/main_screen.dart';
import 'package:imagi_go_ai/widgets/custom_widgets.dart';

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailTextEditingController = TextEditingController();

  final createPasswordTextEditingController = TextEditingController();

  final nameTextEditingController = TextEditingController();
  
  Future<void> signup() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance.collection("users");
    

    if (nameTextEditingController.text.isEmpty) {
      notify(context, "Enter your name ");
    }else if (emailTextEditingController.text.isEmpty) {
      notify(context, "Enter your correct email ");
    }else if (createPasswordTextEditingController.text.isEmpty) {
      notify(context, "Create a password ");
    }else{
      auth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text, 
        password: createPasswordTextEditingController.text
        ).then((userCredential){
          final uid = userCredential.user!.uid;
          firestore.doc(uid).set({
            "uid" : uid,
            "name" : nameTextEditingController.text,
            'email':emailTextEditingController.text,
            'createdAt': Timestamp.now()
          }).then((onValue){
            
          }).catchError((e){
            notify(context, e.toString());
          });
          notify(context, "Register Successful");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));

        }).catchError((e){
          notify(context, e.toString());
        });
    }

    
  }
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
                  text: "Create Your\nAccount",
                  fontSize: 44,
                  bold: true,
                ),
              ),
              SizedBox(height: 20),
        
              MyTextField(
                icon: Icon(Icons.person_2_outlined, color: Color(0xFF6C63FF)),
                hintText: "John doe",
                controller: nameTextEditingController,
                label: "Enter your name",
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 8),
        
              MyTextField(
                icon: Icon(Icons.email_outlined, color: Color(0xFF6C63FF)),
                hintText: "abc@gmail.com",
                controller: emailTextEditingController,
                label: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 8),
        
              MyTextField(
                icon: Icon(Icons.lock_outline, color: Color(0xFF6C63FF)),
                hintText: "",
                controller: createPasswordTextEditingController,
                label: "Password",
                isPassword: true,
              ),
        
              SizedBox(height: 25),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: signup,
                  child: MyText(text: "Register", bold: true),
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
                  MyText(text: "Already Have An Account"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signin()),
                      );
                    },
                    child: MyText(text: "Login"),
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
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.google,
                        size: 45,
                        color: Color(0xFF6C63FF)
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
