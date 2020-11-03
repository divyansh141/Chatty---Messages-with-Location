import 'package:Chatty/databaseHandle.dart';
import 'package:Chatty/inbox.dart';
import 'package:Chatty/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  var auth = FirebaseAuth.instance;
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index].get('username'),
                email: searchSnapshot.docs[index].get('email'),
              );
            },
          )
        : Container();
  }

  String search;
  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Container(
            height: 55,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) => search = value,
                          decoration: InputDecoration(
                            hintText: 'Search by username',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          databaseMethods.searchUser(search).then((val) {
                            setState(() {
                              searchSnapshot = val;
                            });
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          searchList(),
        ],
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  String userName;
  String email;

  SearchTile({this.userName, this.email});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        userName,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(email, style: TextStyle(color: Colors.white)),
      trailing: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        color: Colors.blue,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Inbox(userName: userName),
          ),
        ),
        child: Text(
          'Message',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
