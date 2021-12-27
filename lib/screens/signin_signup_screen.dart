import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '/providers/login_screen_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var userType = UserType.signup;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff010a42),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: deviceHeight * 0.1,
          ),
          Center(
            child: SizedBox(
              height: deviceHeight * 0.35,
              child: Image.asset(
                'images/loginlogo.png',
                alignment: Alignment.center,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Get your Money',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                wordSpacing: 3,
                letterSpacing: 1,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Under Control',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                wordSpacing: 3,
                letterSpacing: 1,
              ),
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.035,
          ),
          const Center(
            child: Text(
              'Manage your expenses',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 15,
                  color: Colors.white,
                  letterSpacing: 1),
            ),
          ),
          const Center(
            child: Text(
              'Seamlessly',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 15,
                  color: Colors.white,
                  letterSpacing: 1),
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.06,
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<GoogleSigninProvider>(context, listen: false)
                  .googleLogin();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userType == UserType.signup
                        ? 'Signup with Google'
                        : 'Signin with Google',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        wordSpacing: 2,
                        fontSize: 17),
                  ),
                  const SizedBox(width: 12),
                  const FaIcon(
                    FontAwesomeIcons.google,
                    size: 17,
                    color: Colors.red,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Provider.of<GoogleSigninProvider>(context, listen: false)
                  .facebookLogin();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userType == UserType.signup
                        ? 'Signup with Facebook'
                        : 'Signin with Facebook',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        wordSpacing: 2,
                        fontSize: 17),
                  ),
                  const SizedBox(width: 12),
                  const FaIcon(
                    FontAwesomeIcons.facebook,
                    size: 17,
                    color: Colors.blue,
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userType == UserType.signup
                    ? 'Already have an account'
                    : 'Don\'t have an account yet',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 0.2),
              TextButton(
                  onPressed: () {
                    if (userType == UserType.signup) {
                      setState(() {
                        userType = UserType.login;
                      });
                    } else if (userType == UserType.login) {
                      setState(() {
                        userType = UserType.signup;
                      });
                    }
                  },
                  child:
                      Text(userType == UserType.signup ? 'Signin' : 'Signup')),
            ],
          ),
        ],
      ),
    );
  }
}

enum UserType { login, signup }
