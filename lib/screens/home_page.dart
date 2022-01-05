import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/screens/signin_signup_screen.dart';
import '/screens/dashboard_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
            color: Colors.yellow,
          ),
            ),
          ) ;
        }else if (snapShot.hasError) {
          return const Center(child: Text('Something went wrong'),);
        }else if (snapShot.hasData) {
          return const DashboardScreen();
        }else {
          return const SignUpScreen();
        }
      },
    );
  }
}
