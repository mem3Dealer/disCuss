import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/anotherGroupCreator.dart';
import 'package:my_chat_app/pages/home.dart';

class RoomMembersPage extends StatefulWidget {
  RoomMembersPage(this.groupID, {Key? key}) : super(key: key);
  final String groupID;

  @override
  _RoomMembersPageState createState() => _RoomMembersPageState();
}

class _RoomMembersPageState extends State<RoomMembersPage> {
  final roomCubit = GetIt.I.get<RoomCubit>();
  final _searchBy = TextEditingController();
  final userCubit = GetIt.I.get<UserCubit>();

  final authCubit = GetIt.I.get<AuthCubit>();

  @override
  void initState() {
    roomCubit.backUpUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final MyUser currentUser = authCubit.state.currentUser!;
    // Room? copyOfThisRoom = state.currentRoom?.copyWith();
    List<MyUser>? _users = roomCubit.state.currentRoom?.members;
    MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
    // Room? defaultRoomState = state.currentRoom;
    return Scaffold(
        appBar:
            // MyAppBar(currentMemberofThisRoom, roomCubit, widget.groupID)),
            AppBar(
          title: Text('Chat members'),
          actions: [
            Row(
              children: [
                if (currentMemberofThisRoom?.isAdmin == true)
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                AnotherGroupCreator(true)));
                      },
                      child: Icon(Icons.edit)),
                ElevatedButton(
                    onPressed: () {
                      currentMemberofThisRoom?.isOwner == true
                          ? showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Delete this room?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          roomCubit
                                              .dissolveRoom(widget.groupID);
                                          //TODO implement navigtor to home page
                                        },
                                        child: Text('Delete'))
                                  ],
                                );
                              })
                          : showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Leave this room?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          roomCubit.leaveRoom(widget.groupID,
                                              currentMemberofThisRoom!);
                                          Navigator.of(context)
                                              .push(MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                HomePage(),
                                          ));
                                        },
                                        child: Text('Leave'))
                                  ],
                                );
                              });
                    },
                    child: currentMemberofThisRoom?.isOwner == true
                        ? Icon(Icons.delete_forever)
                        : Icon(Icons.exit_to_app))
              ],
            )
          ],
        ),
        body: Container(
            child: Center(
          child: Column(
            children: [
              // Text( authCubit.state.currentUser.t)
              Container(
                // height: 300,
                // width: 300,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: BlocBuilder<RoomCubit, RoomState>(
                      bloc: roomCubit,
                      builder: (context, state) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Creator:',
                              style: TextStyle(fontSize: 17),
                              // textAlign: TextAlign.end,
                            ),
                            ListTile(
                              title: Text(_users!
                                  .firstWhere((element) => element.isOwner!)
                                  .name!),
                              subtitle: Text(_users
                                  .firstWhere((element) => element.isOwner!)
                                  .nickName!),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            if (_users.any((element) {
                              return element.isAdmin == true &&
                                  element.isOwner != true;
                            }))
                              Column(
                                children: [
                                  Text(
                                    'Admins:',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          state.currentRoom?.members?.length,
                                      itemBuilder: (context, index) {
                                        if (_users[index].isAdmin == true &&
                                            _users[index].isOwner != true)
                                          return AdminTile(
                                              _users[index], roomCubit);
                                        else
                                          return SizedBox.shrink();
                                      }),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            if (_users.any((element) {
                              return element.isAdmin == false &&
                                  element.isOwner != true &&
                                  element.isApporved == true &&
                                  element.canWrite == true;
                            }))
                              Column(
                                children: [
                                  Text(
                                    'Members:',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          state.currentRoom?.members?.length,
                                      itemBuilder: (context, index) {
                                        if (_users[index].isAdmin == false &&
                                            _users[index].isOwner != true &&
                                            _users[index].isApporved == true &&
                                            _users[index].canWrite == true)
                                          return MemberTile(
                                              _users[index], roomCubit);
                                        else
                                          return SizedBox.shrink();
                                      }),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            if (currentMemberofThisRoom?.isAdmin == true)
                              if (_users.any((element) {
                                return element.canWrite == false &&
                                    element.isApporved == true;
                              }))
                                Column(
                                  children: [
                                    Text(
                                      'Join Requests:',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            state.currentRoom?.members?.length,
                                        itemBuilder: (context, index) {
                                          if (_users[index].isAdmin == false &&
                                              _users[index].isOwner != true &&
                                              _users[index].isApporved ==
                                                  true &&
                                              _users[index].canWrite == false)
                                            return RequestedTile(
                                                _users[index], roomCubit);
                                          else
                                            return SizedBox.shrink();
                                        })
                                  ],
                                ),
                            // Spacer(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          roomCubit.discardChanges();
                          // userCubit.dismissSelected();
                          // print(state.currentRoom?.members.toString());
                          Navigator.of(context).pop();
                        },
                        child: Text('Never mind')),
                    ElevatedButton(
                        onPressed: () {
                          roomCubit.saveRoomChanges();
                          Navigator.of(context).pop();
                        },
                        child: Text('Save'))
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}

// class MyAppBar extends StatefulWidget {
//   String groupID;
//   MyUser? user;
//   var roomCubit = GetIt.I.get<RoomCubit>();

//   MyAppBar(this.user, this.roomCubit, this.groupID, {Key? key})
//       : super(key: key);

//   @override
//   _MyAppBarState createState() => _MyAppBarState();
// }

// class _MyAppBarState extends State<MyAppBar> {
//   TextEditingController _searchQueryController = TextEditingController();

//   bool _isSearching = false;

//   String searchQuery = "Search query";

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//         // leading: _isSearching? buildTextField() : Container()
//         title: _isSearching ? buildTextField() : Text('Chat Members'),
//         actions: _buildActions(widget.user!, context, widget.groupID));
//   }

//   _buildActions(MyUser _user, BuildContext context, String groupID) {
//     return Row(
//       children: [
//         IconButton(
//             onPressed: () {
//               setState(() {
//                 _isSearching = true;
//               });
//             },
//             icon: Icon(Icons.add)),
//         ElevatedButton(
//             onPressed: () {
//               _user.isOwner == true
//                   ? showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text('Delete this room?'),
//                           actions: [
//                             ElevatedButton(
//                                 onPressed: () {
//                                   widget.roomCubit.dissolveRoom(groupID);
//                                   //TODO implement navigtor to home page
//                                 },
//                                 child: Text('Delete'))
//                           ],
//                         );
//                       })
//                   : showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text('Leave this room?'),
//                           actions: [
//                             ElevatedButton(
//                                 onPressed: () {
//                                   widget.roomCubit.leaveRoom(groupID, _user);
//                                   Navigator.of(context)
//                                       .push(MaterialPageRoute<void>(
//                                     builder: (BuildContext context) =>
//                                         HomePage(),
//                                   ));
//                                 },
//                                 child: Text('Leave'))
//                           ],
//                         );
//                       });
//             },
//             child: _user.isOwner == true
//                 ? Icon(Icons.delete_forever)
//                 : Icon(Icons.exit_to_app))
//       ],
//     );
//   }

//   buildTextField() {
//     return TextFormField(
//       controller: _searchQueryController,
//       autofocus: true,
//       decoration: InputDecoration(
//           contentPadding: EdgeInsets.only(left: 8),
//           hintText: 'Enter nametag of a person and hit add'),
//     );
//   }
// }

class AdminTile extends StatelessWidget {
  MyUser? user;
  var roomCubit = GetIt.I.get<RoomCubit>();
  AdminTile(this.user, this.roomCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MyUser? user;
    return ListTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (roomCubit.getoLocalUser()?.isOwner == true)
              IconButton(
                  onPressed: () {
                    roomCubit.changeUserPrivileges(user,
                        isAdmin: !user!.isAdmin!);
                  },
                  icon: Icon(Icons.arrow_downward_sharp)),
            if (roomCubit.getoLocalUser()?.isOwner == true)
              IconButton(
                  onPressed: () {
                    roomCubit.kickUser(
                        roomCubit.state.currentRoom!.groupID!, user!);
                  },
                  icon: Icon(Icons.delete_sweep))
          ],
        ),
        title: Text(user!.name.toString()),
        subtitle: Text(user!.nickName.toString()));
  }
}

class MemberTile extends StatelessWidget {
  MyUser? user;
  var roomCubit = GetIt.I.get<RoomCubit>();
  MemberTile(this.user, this.roomCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MyUser? user;
    return ListTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (roomCubit.getoLocalUser()?.isOwner == true)
              IconButton(
                  onPressed: () {
                    roomCubit.changeUserPrivileges(user,
                        isAdmin: !user!.isAdmin!);
                  },
                  icon: Icon(Icons.arrow_upward_sharp)),
            if (roomCubit.getoLocalUser()?.isAdmin == true)
              IconButton(
                  onPressed: () {
                    roomCubit.changeUserPrivileges(user,
                        canWrite: !user!.canWrite!);
                  },
                  icon: Icon(Icons.arrow_downward_sharp)),
            if (roomCubit.getoLocalUser()?.isAdmin == true)
              IconButton(
                  onPressed: () {
                    roomCubit.kickUser(
                        roomCubit.state.currentRoom!.groupID!, user!);
                  },
                  icon: Icon(Icons.delete_sweep))
          ],
        ),
        title: Text(user!.name.toString()),
        subtitle: Text(user!.nickName.toString()));
  }
}

class RequestedTile extends StatelessWidget {
  MyUser? user;
  var roomCubit = GetIt.I.get<RoomCubit>();
  RequestedTile(this.user, this.roomCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MyUser? user;
    return ListTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  roomCubit.changeUserPrivileges(user,
                      canWrite: !user!.canWrite!);
                },
                icon: Icon(Icons.check)),
            // Checkbox(
            //   onChanged: (val) {
            //     roomCubit.letThemWrite(user, !user!.canWrite!);
            //   },
            //   value: user?.canWrite,
            // ),
            IconButton(
                onPressed: () {
                  roomCubit.changeUserPrivileges(user,
                      isApporved: !user!.isApporved!);
                },
                icon: Icon(Icons.block_sharp))
          ],
        ),
        title: Text(user!.name.toString()),
        subtitle: Text(user!.nickName.toString()));
  }
}
