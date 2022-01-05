import 'dart:io';

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
  Future<bool> _checkInternetConnection() async {
    late bool connectStatus;
    try {
      final response = await InternetAddress.lookup('www.kindacode.com');
      if (response.isNotEmpty) {
        connectStatus = true;
      }
    } on SocketException catch (err) {
      connectStatus = false;
    }
    return connectStatus;
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff010a42),
      body: Column(
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
            onPressed: () async {
              final _internetConnection = await _checkInternetConnection();
              if (_internetConnection) {
                await Provider.of<GoogleSigninProvider>(context, listen: false)
                    .googleLogin();
              } else {
                showDialog<void>(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          backgroundColor: const Color(0xff010a42),
                          title: const Text(
                            'Check your internet connection',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontFamily: 'Raleway'),
                          ),
                          content: const Text(
                            'Internet connection required to signup/signin.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                height: 1.5,
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontFamily: 'Raleway'),
                          ),
                          elevation: 30,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ]);
                    });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Signin/Signup with Google',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        wordSpacing: 2,
                        fontSize: 17),
                  ),
                  SizedBox(width: 12),
                  FaIcon(
                    FontAwesomeIcons.google,
                    size: 17,
                    color: Colors.red,
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
