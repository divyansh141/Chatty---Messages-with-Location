import 'package:Chatty/inbox.dart';
import 'package:Chatty/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String userName;
  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // var x = auth.currentUser.email;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chatty',
          style: TextStyle(color: Color(0xff37ebea)),
        ),
        leading: Image.asset(
          'assets/images/chatty_trans.png',
          scale: 10,
        ),
        backgroundColor: Color(0xff013a4a),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              try {
                await auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
      backgroundColor: Color(0xff013a4a),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff3790ea),
        onPressed: () => Navigator.pushNamed(context, 'searchPage'),
        child: Icon(Icons.search),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //height: MediaQuery.of(context).size.height * 0.20,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: TextStyle(color: Colors.white, fontSize: 34),
                  ),
                  Text(
                    auth.currentUser.email ?? 'Username',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ],
              ),
            ),
            Text(
              'RECENT MESSAGES',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              leading: CircleAvatar(
                child: Text('g'),
              ),
              title: Text(
                'gautam',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Inbox(userName: 'gautam'),
                ),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Text('P'),
              ),
              title: Text(
                'Pitashree',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Text('M'),
              ),
              title: Text(
                'Matashree',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
