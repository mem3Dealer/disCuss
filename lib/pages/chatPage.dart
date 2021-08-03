// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core_web/firebase_core_web_interop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
// import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/database.dart';

class ChatPage extends StatefulWidget {
  String groupID;

  ChatPage(this.groupID);
  // ChatPage({Key? key, required this.groupID}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Stream<QuerySnapshot>? _chat;
  // TextEditingController messageEditingController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  // DataBaseService data = DataBaseService();
  // ScrollController _scrollController = new ScrollController();
  String? senderId = FirebaseAuth.instance.currentUser?.uid;
  // bool needsToScroll = false;
  // Message message = Message();

  // var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  List<MyUser>? listUsers;
  List<Room>? listRooms;
  final data = GetIt.I.get<DataBaseService>();
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();

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

  @override
  Widget build(BuildContext context) {
    print("ROOMS ARE: $listRooms");
    roomCubit.setRoomAsCurrent(
        listRooms?.firstWhere((element) => element.groupID == widget.groupID));
    // print("CURRENT IS: ${widget.groupID}");
    // final AuthService _auth = AuthService();
    // return BlocBuilder<RoomCubit, RoomState>(
    //   bloc: roomCubit,
    //   builder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            // authCubit.state.currentUser?.name
            listRooms
                    ?.firstWhere((element) => element.groupID == widget.groupID)
                    .groupName ??
                'Loading'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return roomCubit.addUserToThisRoom(widget.groupID);
                          });
                    },
                    icon: Icon(Icons.add)),
                IconButton(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute<void>(
                      //       builder: (BuildContext context) =>
                      //           RoomMembersPage(widget.groupID),
                      //       fullscreenDialog: true),
                      // );
                      // print("State room is: ${state.room?.admin}");
                    },
                    icon: Icon(Icons.people))
              ],
            ),
          ),
        ],
      ),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: data.testStream(widget.groupID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messageDataList =
                      roomCubit.makeMessagesDataList(snapshot);
                  return Column(children: [
                    Expanded(
                        child: roomCubit.showChat(
                            messageDataList, listUsers, widget.groupID)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          width: MediaQuery.of(context).size.width,
                          child: roomCubit
                              .messageInputAndSendButton(widget.groupID)),
                    ),
                  ]);
                } else {
                  // ? SingleChildScrollView(
                  //     child: Text(listChat.toString()))
                  return Container(child: Center(child: Text('loading...')));
                }
              })),
    );
    ;
  }

  // makeMessagesDataList(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {}
}

// class RoomMembersPage extends StatelessWidget {
//   final roomCubit = GetIt.I.get<RoomCubit>();
//   RoomMembersPage(this.groupID, {Key? key}) : super(key: key);
//   final String groupID;
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RoomCubit, RoomState>(
//       bloc: roomCubit,
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(title: Text('Chat members')),
//           body: Container(
//             child: Column(
//               children: [
//                 Container(
//                   height: 300,
//                   width: 300,
//                   child: SingleChildScrollView(
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: state.room?.members?.length,
//                         itemBuilder: (context, index) {
//                           List<MyUser>? _members = state.room?.members;
//                           return ListTile(
//                             trailing: state.room?.admin != _members?[index]
//                                 ? IconButton(
//                                     icon: Icon(Icons.delete),
//                                     onPressed: () {
//                                       roomCubit.kickUser(
//                                           groupID, _members![index]);
//                                       // print([_members?[index]]
//                                       //     .runtimeType);
//                                     },
//                                   )
//                                 : SizedBox.shrink(),
//                             title: Text(_members![index].name!),
//                             subtitle: Text(_members[index].email!),
//                           );
//                         }),
//                   ),
//                 ),
//               ],
//             ),
//             // actions: [
//             //   TextButton(
//             //       onPressed: () {}, child: Text('shmyak'))
//             // ],
//           ),
//         );
//       },
//     );
//   }
// }
