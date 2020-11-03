import 'package:Chatty/chatPage.dart';
import 'package:Chatty/regPage.dart';
import 'package:Chatty/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  var auth = FirebaseAuth.instance;
  String email;
  String password;
  bool loading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  var controller;
  var animation;
  var animationValue;
  var revController;
  var reverseAnimation;
  var reverseAnimationValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    controller.forward();
    revController = ReverseAnimation(controller);

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addListener(() {
        setState(() {
          animationValue = animation.value;
        });
      });
    reverseAnimation =
        CurvedAnimation(parent: revController, curve: Curves.bounceIn)
          ..addListener(() {
            setState(() {
              reverseAnimationValue = reverseAnimation.value;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff013a4a),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/chattyicon.png',
                        scale: 15,
                      ),
                      SizedBox(
                        width: 200 * reverseAnimationValue + 10,
                      ),
                      Text(
                        'Chatty',
                        style: TextStyle(
                          color: Color(0xff37ebea),
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 54),
                  ),
                  Text(
                    'Sign in to continue',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    onChanged: (value) => email = value,
                    cursorColor: Color(0xff37ebea),
                    style: TextStyle(color: Color(0xff37ebea)),
                    decoration: textFieldDecor('Email', Icons.mail_outline),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    onChanged: (value) => password = value,
                    obscureText: true,
                    cursorColor: Color(0xff37ebea),
                    style: TextStyle(color: Color(0xff37ebea)),
                    decoration: textFieldDecor('Password', Icons.lock_outline),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                        backgroundColor: Color(0xffffffff),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          try {
                            var login = await auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            //print(login);
                            if (login != null) {
                              setState(() {
                                loading = false;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage()));
                            }
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });

                            final snackBar = SnackBar(
                              content: Text(
                                  'Please check your Email and Password again'),
                              backgroundColor: Colors.red,
                            );

                            _scaffoldKey.currentState.showSnackBar(snackBar);

                            print(e);
                          }
                        },
                        label: Text('LOG IN',
                            style: TextStyle(
                              color: Color(0xff013a4a),
                            ))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an Account? ',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegPage()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
