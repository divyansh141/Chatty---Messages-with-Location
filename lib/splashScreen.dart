import 'package:Chatty/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<Splash> with TickerProviderStateMixin {
  var controller;
  var animation;
  var animationValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addListener(() {
        setState(() {
          animationValue = animation.value;
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 4,
        navigateAfterSeconds: new LoginPage(),
        title: new Text(
          'Chatty',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 20 * animationValue,
              color: Color(0xff37ebea)),
        ),
        image: new Image.asset('assets/images/chattyicon.png'),
        backgroundColor: Color(0xff013a4a),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 50 * animationValue,
        onClick: () => Navigator.pushNamed(context, 'loginPage'),
        loaderColor: Color(0xff37ebea));
  }
}
