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
  // CollectionReference userCollection =
  //     FirebaseFirestore.instance.collection('users');
  // CollectionReference roomsCollection =
  //     FirebaseFirestore.instance.collection('dummyCollection');
  DataBaseService data = DataBaseService();
  // TextEditingController _textFieldController = TextEditingController();
  String? groupName;
  String _currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
  List avavailableChats = [];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (listUsers == null) {
        final usersData = await data.getUsers();
        listUsers = usersData?.toList();

        // final roomsData = await data.getRooms();
        // listRooms = roomsData?.toList();

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

    // String? currentUserName = data.getUserName(_currentUserId, listUsers!);
    bool isClicked;
    final AuthService _auth = AuthService();

    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.amber.shade700)),
            child: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
            },
            // label: Text('Log out'),
          ),
        )
      ], title: Text('oyoyo')
          // Text('$currentUserName`s chats, ${listUsers?.length.toString()}'),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GroupCreator(listUsers)));
          // _showDialog();
          // GroupCreator(listUsers);
          setState(() {
            // isClicked = !isClicked;
          });
          print('pressed');
        },
      ),
    );
  }

  Widget showRooms() {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
      stream: data.roomsStream(),
      builder: (context, snapshot) {
        var roomData = snapshot.data!.docs;
        if (snapshot.hasData)
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              // if (roomData[index]['members'].contains(_currentUserId))
              return Column(
                children: [
                  // if (listRooms![index].members.contains(_currentUserId))
                  ListTile(
                    title: Text(
                        "${roomData[index]['groupName']} + ${roomData[index]['groupID']}"),
                    subtitle: Text("Created by: ${listRooms![index].admin}"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(roomData[index]['groupID'])));
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
        else
          return CircularProgressIndicator();
      },
    ));
  }

  // void _showDialog() {
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       String? currentUserName = data.getUserName(_currentUserId, listUsers!);
  //       return AlertDialog(
  //         title: Text("Create new room"),
  //         content: TextField(
  //           decoration: InputDecoration(hintText: 'Enter group`s name...'),
  //           controller: _textFieldController,
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text("Create"),
  //             onPressed: () {
  //               data.createGroup(currentUserName!, _textFieldController.text,
  //                   _currentUserId);
  //               // data.updateRoomData(_textFieldController.text);
  //               Navigator.of(context).pop();
  //               // print(_textFieldController.text);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   ).then((value) => setState(() {
  //         // groupName = _textFieldController.text;
  //       }));
  // }
}

class GroupCreator extends StatefulWidget {
  List<MyUser>? listUsers;
  // const GroupCreator({Key? key}) : super(key: key);
  GroupCreator(this.listUsers);

  @override
  _GroupCreatorState createState() => _GroupCreatorState();
}

class _GroupCreatorState extends State<GroupCreator> {
  DataBaseService data = DataBaseService();
  // List<MyUser> listUsers = [];
  String _currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();

  List<MyUser> availableUsers = [];
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  // bool isSelected = true;
  List<MyUser> selectedUsers = [];
  final _groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // bool amIHere = widget.listUsers!.contains(_currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Text('create new room'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Stepper(
              type: stepperType,
              physics: ScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: continued,
              onStepCancel: cancel,
              steps: <Step>[
                Step(
                    // isActive: _currentStep >= 0,
                    // state: _currentStep == 0
                    //     ? StepState.complete
                    //     : StepState.disabled,
                    title: Text('Enter group`s name'),
                    content: TextField(
                      controller: _groupNameController,
                      decoration: InputDecoration(hintText: 'type here'),
                    )),
                Step(
                  title: Text('Pick members, $_currentStep'),
                  content: SizedBox(
                    child: Column(
                      children: [
                        // Text(widget.listUsers.toString()),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.listUsers?.length,
                            itemBuilder: (context, index) {
                              // var listData = ;
                              bool isSelected = selectedUsers
                                  .contains(widget.listUsers![index].uid);

                              if (widget.listUsers![index].uid!
                                  .contains(_currentUserId))
                                Container();
                              else
                                return ListTile(
                                  // trailing: GestureDetector(
                                  //   child: Icon(Icons.close),
                                  //   onTap: () {
                                  //     selectedUsers.removeAt(index);
                                  //     print('pressed');

                                  //     setState(() {
                                  //       print(selectedUsers);
                                  //     });
                                  //   },
                                  // ),
                                  leading: isSelected
                                      // isSelected
                                      ? Icon(Icons.select_all_rounded)
                                      : Icon(Icons.circle),
                                  title: Text(
                                    // myCurrentUser(),
                                    widget.listUsers![index].name.toString(),
                                    style: TextStyle(
                                        color: isSelected
                                            ? Colors.purple.shade900
                                            : Colors.black),
                                  ),
                                  subtitle: Text(
                                      widget.listUsers![index].email.toString(),
                                      style: TextStyle(
                                          color: isSelected
                                              ? Colors.purple.shade900
                                              : Colors.black)),
                                  onTap: () {
                                    availableUsers
                                        .add(widget.listUsers![index]);
                                    // availableUsers.add(_currentUserId);
                                    selectedUsers =
                                        availableUsers.toSet().toList();
                                    print(selectedUsers);
                                    setState(() {});
                                  },
                                );
                              return SizedBox.shrink();
                            }),
                      ],
                    ),
                  ),
                ),
                // Step(
                //     title: Text('we good with this?'),
                //     content: Column(
                //       children: [
                //         Text('Group name: ${_groupNameController.text}'),
                //         SizedBox(
                //           height: 20,
                //         ),
                //         Text(getSelectedNames().toString()),
                //       ],
                //     ))
              ],
            ))
          ],
        ),
      ),
    );
  }

  // String myCurrentUser() {
  //   String myCurrentUser = '';
  //   widget.listUsers!.firstWhere((e) {

  //   });
  //   // print(widget.listUsers.contains(_currentUserId));
  //   return myCurrentUser;
  // }
  // List<String> getSelectedNames() {
  //   List<String> selectedNames = [];
  //   selectedUsers.forEach((element) {
  //     var name = data.getUserName(element.toString(), selectedUsers);
  //     selectedNames.add(name!);
  //   });
  //   return selectedNames;
  // }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 1 ? setState(() => _currentStep += 1) : print("hello");
  }

  // createGroup() {
  //   String? currentUserName =
  //       data.getUserName(_currentUserId, widget.listUsers!);

  //   data.createGroup(selectedUsers, currentUserName, _groupNameController.text);

  //   // print('$currentUserName');
  //   // print("${widget.listUsers!}");
  // }

  // continued() {
  //   // String? currentUserName = data.getUserName(_currentUserId, listUsers!);
  //   setState(() {
  //     _currentStep < 1 ? _currentStep += 1 : _currentStep = 0;

  //     // if (_currentStep > 1)
  //     //   data.createGroup(
  //     //       selectedUsers, currentUserName, _groupNameController.text);

  //     Navigator.pop(context
  //         // context, MaterialPageRoute(builder: (context) => ChatPage())
  //         );
  //   });
  // }

  cancel() {
    setState(() {
      _currentStep > 0 ? _currentStep -= 1 : _currentStep = 0;
    });
  }
}
