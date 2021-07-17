import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_app/pages/chatPage.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/widgets/messageTile.dart';
import 'package:my_chat_app/widgets/sendFieldandButton.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  List? listUsers;
  ScrollController _thisController = ScrollController();
  String? senderId;
  dynamic snapshot;
  // final _messages = snapshot.data.docs;
  // bool _isNewAuthor;
  // bool _isAuthorOver;
  // HomePage home = HomePage();
  DataBaseService data = DataBaseService();

  @override
  Widget build(BuildContext context) {
    return chatMessages(listUsers, snapshot, _thisController, senderId);
  }

  Widget chatMessages(
      List? listUsers, snapshot, _thisController, String? senderId) {
    final _messages = snapshot?.data.docs;
    bool _isNewAuthor;
    bool _isAuthorOver;
    // HomePage home = HomePage();
    DataBaseService data = DataBaseService();

    return Container(
      child: listUsers == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              controller: _thisController,
              // reverse: true,
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                int _timeStamp = _messages[index]['time'].seconds;
                var date =
                    DateTime.fromMillisecondsSinceEpoch(_timeStamp * 1000);
                var formattedDate =
                    DateFormat('HH:mm dd.MM.yy', 'ru').format(date);

                final message = _messages[index];
                if (index > 0 && index < _messages.length)
                  _isNewAuthor = _messages[index - 1]['sender'].toString() !=
                      _messages[index]['sender'].toString();
                else
                  _isNewAuthor = true;

                if (index > 0 && index < _messages.length - 1)
                  _isAuthorOver = _messages[index + 1]['sender'].toString() !=
                      _messages[index]['sender'].toString();
                else
                  _isAuthorOver = true;
                // _lastAuthor = message['sender'].toString();

                return MessageTile(
                    time: formattedDate,
                    firstMessageOfAuthor: _isNewAuthor,
                    lastMessageOfAuthor: _isAuthorOver,
                    author: _isNewAuthor
                        ? data.getUserName(
                            message['sender'].toString(), listUsers)
                        : '',
                    // snapshot.data.docs[index]['author'].toString(),
                    message: message['recentMessage'].toString(),
                    sentByMe:
                        senderId == _messages[index]['sender'].toString());
              }),
    );
  }
}
