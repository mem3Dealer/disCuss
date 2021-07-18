import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/chatPage.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List dummyChatRooms = [
    ListTile(),
    Divider(),
    ListTile(),
    Divider(),
    ListTile(),
    Divider(),
    ListTile(),
    Divider(),
    ListTile(),
    Divider(),
  ];

  List<MyUser>? listUsers;
  List<Room>? listRooms;
  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  CollectionReference roomsCollection = FirebaseFirestore.instance.collection('dummyCollection');
  DataBaseService data = DataBaseService();
  TextEditingController _textFieldController = TextEditingController();
  String? groupName;
  String _currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
  List avavailableChats = [];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (listUsers == null) {
        final usersData = await data.getUsers();
        listUsers = usersData?.toList();

        final roomsData = await data.getRooms();
        listRooms = roomsData?.toList();

        setState(() {});
      }
    });
    super.initState();
  }

  // Future<List> availableChats() async {
  //   List avavailableChats = [];
  //   // var res =
  //   //     await roomsCollection.where('admin', whereIn: ['someone']).get();
  //   var res = await roomsCollection
  //       .where('members', arrayContains: _currentUserId)
  //       .get();

  //   res.docs.forEach((res) {
  //     avavailableChats.add(res.id);
  //     print(res.id);
  //   });
  //   print(avavailableChats);
  //   return avavailableChats;
  // }

  @override
  Widget build(BuildContext context) {
    // bool showIt = ;

    String? currentUserName = data.getUserName(_currentUserId, listUsers!);
    final AuthService _auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber.shade700)),
              child: Icon(Icons.exit_to_app),
              onPressed: () async {
                await _auth.signOut();
              },
              // label: Text('Log out'),
            ),
          )
        ],
        title: Text('$currentUserName`s chats'),
      ),
      // drawer: Drawer(
      //   child: StreamBuilder<QuerySnapshot>(
      //     stream: data.usersStream(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         return ListView.builder(
      //             itemCount: listUsers?.length,
      //             itemBuilder: (context, index) {
      //               return Column(
      //                 children: [
      //                   ListTile(
      //                     title: Text(listUsers![index].name.toString()),
      //                     leading: CircleAvatar(
      //                       child: Icon(Icons.person),
      //                     ),
      //                     subtitle: Text(listUsers![index].email.toString()),
      //                   ),
      //                   Divider()
      //                 ],
      //               );
      //             });
      //       } else {
      //         return Text('loading...');
      //       }
      //     },
      //   ),
      // ),
      body: showRooms(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showDialog();

          // print('pressed');
        },
      ),
    );
  }

  Widget showRooms() {
    return StreamBuilder<QuerySnapshot>(
        stream: data.roomsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              var roomData = snapshot.data!.docs;
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  // if (roomData[index]['members'].contains(_currentUserId))
                  return Column(
                    children: [
                      // if (listRooms![index].members.contains(_currentUserId))
                      ListTile(
                        title: Text("${roomData[index]['groupName']} + ${roomData[index]['groupID']}"),
                        subtitle: Text("Created by: ${listRooms![index].admin}"),
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ChatPage(roomData[index]['groupID'])));
                        },
                      ),
                      Divider()
                    ],
                  );
                  // else
                  //   return SizedBox
                  //       .shrink(); // он скрывает просто тайлы в которых нет пользователя как участника.
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? currentUserName = data.getUserName(_currentUserId, listUsers!);
        return AlertDialog(
          title: Text("Create new room"),
          content: TextField(
            decoration: InputDecoration(hintText: 'Enter group`s name...'),
            controller: _textFieldController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Create"),
              onPressed: () {
                data.createGroup(currentUserName!, _textFieldController.text, _currentUserId);
                // data.updateRoomData(_textFieldController.text);
                Navigator.of(context).pop();
                // print(_textFieldController.text);
              },
            ),
          ],
        );
      },
    ).then((value) => setState(() {
          // groupName = _textFieldController.text;
        }));
  }
}
