import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/pages/chatPage.dart';
import 'package:my_chat_app/services/database.dart';

class SendFieldAndButton extends StatefulWidget {
  String groupID;
  // const SendFieldAndButton({Key? key}) : super(key: key);
  SendFieldAndButton(this.groupID);
  @override
  _SendFieldAndButtonState createState() => _SendFieldAndButtonState();
}

class _SendFieldAndButtonState extends State<SendFieldAndButton> {
  TextEditingController messageEditingController = TextEditingController();
  DataBaseService data = DataBaseService();
  String? senderId = FirebaseAuth.instance.currentUser?.uid;
  // HomePage home = HomePage();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: TextField(
                  controller: messageEditingController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    // fillColor: Colors.pink,
                    hintText: 'type here',
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                data.sendMessage(messageEditingController, senderId.toString(),
                    widget.groupID);
                // print(snapshot.docs.length);
                setState(() {
                  messageEditingController.text = '';
                  // needsToScroll = true;
                });
                print('pressed');
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(50)),
                child: Center(child: Icon(Icons.send, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
