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
  final List<MyUser>? listUsers;
  final int userColorCode;

  MessageTile(
      {required this.time,
      required this.message,
      required this.author,
      required this.sentByMe,
      required this.firstMessageOfAuthor,
      required this.lastMessageOfAuthor,
      required this.userColorCode,
      this.listUsers});

  // HomePage home = HomePage();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: firstMessageOfAuthor ? 4 : 1,
        bottom: lastMessageOfAuthor ? 4 : 1,
        left: sentByMe ? 0 : 7,
        right: sentByMe ? 7 : 0,
      ),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(right: 10, left: 15, top: 12, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: sentByMe
              ? lastMessageOfAuthor && firstMessageOfAuthor
                  ? BorderRadius.all(Radius.circular(18))
                  : firstMessageOfAuthor
                      ? BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(18))
                      : lastMessageOfAuthor
                          ? BorderRadius.only(
                              topLeft: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                              bottomLeft: Radius.circular(18))
                          : BorderRadius.only(
                              topLeft: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                            )

              /// not by me
              : lastMessageOfAuthor && firstMessageOfAuthor
                  ? BorderRadius.all(Radius.circular(18))
                  : firstMessageOfAuthor
                      ? BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(18)) //FIRST
                      : lastMessageOfAuthor
                          ? BorderRadius.only(
                              topRight: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                              bottomLeft: Radius.circular(18))
                          //LAST
                          : BorderRadius.only(
                              topRight: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                            ),
          color: sentByMe
              ? theme.brightness == Brightness.dark
                  ? theme.primaryColor
                  : theme.primaryColor
              : Color(userColorCode),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (author!.isNotEmpty) messageAuthor(context, author),
            messageContent(message!, context),
            SizedBox(
              height: 3,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(time!,
                    // textAlign: sentByMe ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      // color: Colors.black,
                      fontSize: 11,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget messageAuthor(BuildContext context, String? author) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 3.0),
          child: Text("${author!.toUpperCase()}",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.caption?.copyWith(
                  fontSize:
                      (Theme.of(context).textTheme.caption!.fontSize! - 3),
                  fontWeight: FontWeight.bold,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Color(0xfffefae0),
                  letterSpacing: -0.5)),
        ),
      ],
    );
  }

  Widget messageContent(String message, BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(message,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: 15.0,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black));
  }
}
