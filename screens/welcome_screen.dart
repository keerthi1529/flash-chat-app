import 'package:flutter/material.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/components/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class WelcomeScreen extends StatefulWidget {
 static String  id= 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController  controller;
  late Animation animation;
  //=AnimationController(duration: Duration(seconds: 1) );
  final _auth=FirebaseAuth.instance;
  String email='';
  String password='';
  @override
  void initState(){
    super.initState();
    controller=AnimationController(
        duration: Duration(seconds: 2),
       vsync: this,
      //upperBound:100,
    );
    animation =ColorTween(begin: Colors.greenAccent,end: Colors.white).animate(controller);
   // animation =CurvedAnimation(parent: controller, curve: Curves.easeIn);
 controller.forward();
 // animation.addStatusListener((status) {
 //   if(status==AnimationStatus.completed){
 //    controller.reverse(from: 1.0) ;
 //   }
 //   else if(status==AnimationStatus.dismissed){
 //     controller.forward();
 //   }
 // });
 controller.addListener(() {
   setState(() {});
   print(animation.value);
 });
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
     // backgroundColor:Colors.white,
      //backgroundColor: Colors.red.withOpacity(controller.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                    Hero(
                      tag:'logo',
                      child: Container(
                        child: Image.asset('images/logo.png'),
                        height: 60.0,
                        //height: animation.value,
                      ),
                    ),
                   TypewriterAnimatedTextKit(text:['Flash Chat'],
                      //'${controller.value.toInt()}%',
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black54,
                      ),
                    ),
               ],),
            SizedBox(
              height: 48.0,
            ),
           RoundedButton(colour:Colors.lightBlueAccent, title: 'Log In',
               onPressed:(){
                 Navigator.pushNamed(context,'/login');
               },),
           RoundedButton(colour: Colors.blue, title: 'Register',
    onPressed:(){
    Navigator.pushNamed(context,'/registration');
    },
   )]
    )
    )
    );
  }
}
// Padding(
// padding: EdgeInsets.symmetric(vertical: 16.0),
// child: Material(
// elevation: 5.0,
// color: Colors.lightBlueAccent,
// borderRadius: BorderRadius.circular(30.0),
// child: MaterialButton(
// onPressed: () {
// Navigator.pushNamed(context,'/login');
// // Navigator.pushNamed(context, LoginScreen.id);
// },
// minWidth: 200.0,
// height: 42.0,
// child: Text(
// 'Log In',
// ),
// ),
// ),
// ),
