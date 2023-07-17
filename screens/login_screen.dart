import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/components/roundbutton.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class LoginScreen extends StatefulWidget {
  static String  id='login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  String email='';
  String password='';
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
       inAsyncCall: showSpinner,
     child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag:'logo',
               child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                email=value;
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your mail'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password=value;
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(colour: Colors.blue, title: 'Log In',
                onPressed: () async{
              setState(() {
                showSpinner=true;
              });
              try {
                final user = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (user != null) {
                  Navigator.pushNamed(context, '/chat');
                }
              }
              catch(e){
                print(e);
              }
                }),
          ],
        ),
    ),
      ),
    );
  }
}
