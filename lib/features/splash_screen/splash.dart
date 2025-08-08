
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imagi_go_ai/auth/signin.dart';
import 'package:imagi_go_ai/features/main_screen.dart';
import 'package:imagi_go_ai/provider/user_provider.dart';
import 'package:provider/provider.dart';



class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  
  @override
void initState() {
  super.initState();

  Future.delayed(const Duration(seconds: 3), () {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Signin()),
      );
    }
  });

  
}

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SizedBox(
          width: 280,
          child: DefaultTextStyle(
            style:  GoogleFonts.poppins(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              // adjust as per theme
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color.fromARGB(255, 119, 119, 119)
            ),
            child: AnimatedTextKit(
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
              animatedTexts: [
                TypewriterAnimatedText(
                  '  ImagiGoAI',
                  speed: const Duration(milliseconds: 150),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
