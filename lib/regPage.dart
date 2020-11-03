import 'package:Chatty/chatPage.dart';
import 'package:Chatty/loginPage.dart';
import 'package:Chatty/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

var fs = FirebaseFirestore.instance;

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  var fs = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;
  bool loading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String email;
  String password;
  String username;
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
                      width: 10,
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
                  'Register',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 54),
                ),
                Text(
                  'Sign up to continue',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  cursorColor: Color(0xff37ebea),
                  style: TextStyle(color: Color(0xff37ebea)),
                  decoration: textFieldDecor('Username', Icons.account_circle),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  cursorColor: Color(0xff37ebea),
                  style: TextStyle(color: Color(0xff37ebea)),
                  decoration: textFieldDecor('Email', Icons.mail_outline),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    cursorColor: Color(0xff37ebea),
                    style: TextStyle(color: Color(0xff37ebea)),
                    decoration: textFieldDecor('Password', Icons.lock_outline)),
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
                          var user = await auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                          if (user.additionalUserInfo.isNewUser == true) {
                            setState(() {
                              loading = false;
                            });
                            await fs.collection('users').add({
                              'username': username,
                              'email': email,
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
                                'The email address is already in use by another account'),
                            backgroundColor: Colors.red,
                          );

                          _scaffoldKey.currentState.showSnackBar(snackBar);
                          print(e);
                        }
                      },
                      label: Text('Sign Up',
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
                      'Already have an Account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          'Log In',
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
    );
  }
}
