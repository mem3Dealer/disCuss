import 'package:flutter/material.dart';
import 'package:my_chat_app/models/user.dart';

class MessageTile extends StatelessWidget {
  // const MessageTile({ Key? key }) : super(key: key);

  final String? message;
  final String? author;
  final bool sentByMe;
  final bool firstMessageOfAuthor;
  final bool lastMessageOfAuthor;
  final String? time;
  // final bool amIlast;
  // final bool penult;
  final List<MyUser>? listUsers;

  MessageTile(
      {required this.time,
      required this.message,
      required this.author,
      required this.sentByMe,
      required this.firstMessageOfAuthor,
      required this.lastMessageOfAuthor,
      // required this.amIlast,
      // required this.penult
      this.listUsers});

  // HomePage home = HomePage();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: firstMessageOfAuthor ? 4 : 1,
        bottom: lastMessageOfAuthor ? 4 : 1,
        left: sentByMe ? 0 : 7,
        right: sentByMe ? 7 : 0,
      ),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(right: 20, left: 20, top: 12, bottom: 12),
        decoration: BoxDecoration(
            borderRadius: sentByMe
                ? firstMessageOfAuthor
                    ? BorderRadius.only(
                        topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomLeft: Radius.circular(18))
                    : lastMessageOfAuthor
                        ? BorderRadius.only(
                            topLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18)) // последне
                        : BorderRadius.all(Radius.circular(18)) // середина

                /// not by me
                : firstMessageOfAuthor
                    ? BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                        bottomRight: Radius.circular(18)) //FIRST
                    : lastMessageOfAuthor
                        ? BorderRadius.only(
                            topRight: Radius.circular(18),
                            // topRight: Radius.circular(23),
                            bottomRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18))
                        //LAST
                        : BorderRadius.all(Radius.circular(18)),
            color: sentByMe ? Colors.lightBlueAccent.shade400 : Colors.grey.shade700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (author!.isNotEmpty) messageAuthor(author),
            messageContent(message!),
            SizedBox(
              height: 3,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(time!,
                    // textAlign: sentByMe ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      fontSize: 11,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget messageAuthor(String? author) {
    return Column(
      children: [
        Text(author!.toUpperCase(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5)),
        SizedBox(height: 7.0),
      ],
    );
  }

  Widget messageContent(String message) {
    return Text(message, textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Colors.white));
  }
}
