import 'package:Chatty/databaseHandle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Inbox extends StatefulWidget {
  String userName;
  Inbox({this.userName});
  @override
  _InboxState createState() => _InboxState(userName);
}

class _InboxState extends State<Inbox> {
  String userName;
  String chatRoomID;
  Stream chatStream;
  Position position;
  String place;
  // var coordinates;
  _InboxState(this.userName);
  TextEditingController msgController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  currentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final coordinates = Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      place = "${first.subLocality}, ${first.locality}, ${first.adminArea}";
    });
    print(place);
    return position;
  }

  Widget chatList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .doc('divyansh-gautam')
            .collection('chats')
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return chatTitle(
                        snapshot.data.docs[index].data()['message'],
                        snapshot.data.docs[index].data()['sender'] ==
                            FirebaseAuth.instance.currentUser.email,
                        snapshot.data.docs[index].data()['location']);
                  })
              : Container();
        });
  }

  sendMessage() {
    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": msgController.text,
        "sender": FirebaseAuth.instance.currentUser.email,
        "time": DateTime.now().millisecondsSinceEpoch,
        "location": place,
      };
      databaseMethods.addMessages('divyansh-gautam', messageMap);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPosition();
    databaseMethods.getConversation('divyansh-gautam').then((value) {
      setState(() {
        chatStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.person_outline_outlined,
          size: 32,
        ),
        title: Text(userName),
        backgroundColor: Color(0xff013a4a),
      ),
      backgroundColor: Color(0xff013a4a),
      body: Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.07,
              ),
              child: chatList(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(24),
                  shape: BoxShape.rectangle,
                ),
                child: TextField(
                  controller: msgController,
                  cursorColor: Color(0xff37ebea),
                  style: TextStyle(color: Colors.white),
                  onSubmitted: (value) {
                    sendMessage();
                    msgController.clear();
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.keyboard, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: Color(0xff37ebea)),
                      onPressed: () {
                        sendMessage();
                        msgController.clear();
                      },
                    ),
                    hintText: 'Type a message',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class chatTitle extends StatelessWidget {
  String message;
  bool isSendByMe;
  String location;
  chatTitle(this.message, this.isSendByMe, this.location);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
                color: isSendByMe ? Colors.blue : Colors.blueGrey,
                borderRadius: isSendByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      )),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            location ?? 'unavailable',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
