import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/states/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/anotherGroupCreator.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RoomMembersPage extends StatefulWidget {
  RoomMembersPage(this.groupID, {Key? key}) : super(key: key);
  final String groupID;

  @override
  _RoomMembersPageState createState() => _RoomMembersPageState();
}

class _RoomMembersPageState extends State<RoomMembersPage> {
  final roomCubit = GetIt.I.get<RoomCubit>();
  // final _searchBy = TextEditingController();
  final userCubit = GetIt.I.get<UserCubit>();

  final authCubit = GetIt.I.get<AuthCubit>();

  @override
  void initState() {
    roomCubit.backUpUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // final MyUser currentUser = authCubit.state.currentUser!;
    // Room? copyOfThisRoom = state.currentRoom?.copyWith();
    List<MyUser>? _users = roomCubit.state.currentRoom?.members;

    MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
    // Room? defaultRoomState = state.currentRoom;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            scale: 0.3,
            repeat: ImageRepeat.repeat,
            // fit: BoxFit.cover,
            image: theme.brightness == Brightness.dark
                ? ExactAssetImage('assets/dark_back.png')
                : ExactAssetImage('assets/light_back.jpg')),
      ),
      child: BackdropFilter(
        filter: theme.brightness == Brightness.dark
            ? ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0)
            : ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar:
                // MyAppBar(currentMemberofThisRoom, roomCubit, widget.groupID)),
                AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Chat members'),
              actions: [
                Row(
                  children: [
                    if (currentMemberofThisRoom?.isAdmin == true)
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    AnotherGroupCreator(true)));
                          },
                          icon: Icon(Icons.edit)),
                    _buildLeaveOrDeleteButton(currentMemberofThisRoom, context)
                  ],
                )
              ],
            ),
            body: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Center(
                    child: Column(
                      children: [
                        // Text( authCubit.state.currentUser.t)
                        Container(
                          child: Expanded(
                            child: SingleChildScrollView(
                              child: BlocBuilder<RoomCubit, RoomState>(
                                bloc: roomCubit,
                                builder: (context, state) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Label('Creator:'),
                                      ListTile(
                                        title: Text(_users!
                                            .firstWhere(
                                                (element) => element.isOwner!)
                                            .name!),
                                        subtitle: Text(_users
                                            .firstWhere(
                                                (element) => element.isOwner!)
                                            .nickName!),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      if (_users.any((element) {
                                        return element.isAdmin == true &&
                                            element.isOwner != true;
                                      }))
                                        Label('Admins:'),
                                      _buildAdminTiles(state, _users),
                                      SizedBox(
                                        height: 15,
                                      ),

                                      if (_users.any((element) {
                                        return element.isAdmin == false &&
                                            element.isOwner != true &&
                                            element.isApporved == true &&
                                            element.canWrite == true;
                                      }))
                                        Label('Members:'),

                                      _buildMemberTiles(state, _users),
                                      SizedBox(
                                        height: 15,
                                      ),

                                      if (currentMemberofThisRoom?.isAdmin ==
                                          true)
                                        if (_users.any((element) {
                                          return element.canWrite == false &&
                                              element.isApporved == true;
                                        }))
                                          Label('Join Requests:'),
                                      _buildJoinRequests(state, _users),

                                      if (currentMemberofThisRoom?.isOwner ==
                                          true)
                                        if (_users.any((element) {
                                          return element.isAdmin == false &&
                                              element.canWrite == false &&
                                              element.isApporved == false;
                                        }))
                                          Label('Banned users:'),
                                      _buildBannedDudes(state, _users)
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
                          child: currentMemberofThisRoom?.isAdmin == true ||
                                  currentMemberofThisRoom?.isOwner == true
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          roomCubit.discardChanges();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(fontSize: 18),
                                        )),
                                    ElevatedButton(
                                        onPressed: () {
                                          roomCubit.saveRoomChanges();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Save',
                                          style: TextStyle(fontSize: 18),
                                        ))
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    ),
                  )),
            )),
      ),
    );
  }

  _buildBannedDudes(RoomState state, List<MyUser> _users) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.currentRoom?.members?.length,
        itemBuilder: (context, index) {
          if (_users[index].isAdmin == false &&
              _users[index].isOwner != true &&
              _users[index].isApporved == false &&
              _users[index].canWrite == false)
            return BannedUsersTile(_users[index], roomCubit);
          else
            return SizedBox.shrink();
        });
  }

  ListView _buildJoinRequests(RoomState state, List<MyUser> _users) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.currentRoom?.members?.length,
        itemBuilder: (context, index) {
          if (_users[index].isAdmin == false &&
              _users[index].isOwner != true &&
              _users[index].isApporved == true &&
              _users[index].canWrite == false)
            return RequestedTile(_users[index], roomCubit);
          else
            return SizedBox.shrink();
        });
  }

  ListView _buildMemberTiles(RoomState state, List<MyUser> _users) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.currentRoom?.members?.length,
        itemBuilder: (context, index) {
          if (_users[index].isAdmin == false &&
              _users[index].isOwner != true &&
              _users[index].isApporved == true &&
              _users[index].canWrite == true)
            return MemberTile(_users[index], roomCubit);
          else
            return SizedBox.shrink();
        });
  }

  ListView _buildAdminTiles(RoomState state, List<MyUser> _users) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.currentRoom?.members?.length,
        itemBuilder: (context, index) {
          if (_users[index].isAdmin == true && _users[index].isOwner != true)
            return AdminTile(_users[index], roomCubit);
          else
            return SizedBox.shrink();
        });
  }

  IconButton _buildLeaveOrDeleteButton(
      MyUser? currentMemberofThisRoom, BuildContext context) {
    return IconButton(
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
                              roomCubit.dissolveRoom(widget.groupID);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home_page',
                                  (Route<dynamic> route) => false);
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
                              roomCubit.leaveRoom(
                                  widget.groupID, currentMemberofThisRoom!);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home_page',
                                  (Route<dynamic> route) => false);
                              // Navigator.of(context)
                              //     .push(MaterialPageRoute<void>(
                              //   builder: (BuildContext context) => HomePage(),
                              // ));
                            },
                            child: Text('Leave'))
                      ],
                    );
                  });
        },
        icon: currentMemberofThisRoom?.isOwner == true
            ? Icon(Icons.delete_forever)
            : Icon(Icons.exit_to_app));
  }
}

class Label extends StatelessWidget {
  String _data;
  Label(
    this._data, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, left: 10.0),
      child: Text(
        _data,

        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 17, color: Color(0xFF9E9E9E)),
        // textAlign: TextAlign.end,
      ),
    );
  }
}

class AdminTile extends StatelessWidget {
  MyUser? user;
  var roomCubit = GetIt.I.get<RoomCubit>();
  AdminTile(this.user, this.roomCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MyUser? user;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: [
        if (roomCubit.getoLocalUser()?.isOwner == true)
          IconSlideAction(
              caption: 'Kick user',
              color: Colors.orange.shade700,
              icon: Icons.delete_sweep,
              onTap: () => roomCubit.kickUser(
                  roomCubit.state.currentRoom!.groupID!, user!)),
        if (roomCubit.getoLocalUser()?.isOwner == true)
          IconSlideAction(
              caption: 'Ban',
              color: Colors.red.shade900,
              icon: Icons.block_sharp,
              onTap: () => roomCubit.changeUserPrivileges(user,
                  canWrite: !user!.canWrite!,
                  isApporved: !user!.isApporved!,
                  isAdmin: !user!.isAdmin!))
      ],
      secondaryActions: [
        if (roomCubit.getoLocalUser()?.isOwner == true)
          IconSlideAction(
              caption: 'Demote',
              color: Colors.indigo,
              icon: Icons.arrow_downward_sharp,
              onTap: () => roomCubit.changeUserPrivileges(user,
                  isAdmin: !user!.isAdmin!)),
      ],
      child: ListTile(
          title: Text(user!.name.toString()),
          subtitle: Text(user!.nickName.toString())),
    );
  }
}

class MemberTile extends StatelessWidget {
  MyUser? user;
  var roomCubit = GetIt.I.get<RoomCubit>();
  MemberTile(this.user, this.roomCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MyUser? user;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: [
        if (roomCubit.getoLocalUser()?.isOwner == true)
          IconSlideAction(
            caption: 'Promote',
            color: Colors.greenAccent.shade700,
            icon: Icons.arrow_upward_sharp,
            onTap: () =>
                roomCubit.changeUserPrivileges(user, isAdmin: !user!.isAdmin!),
          )
      ],
      actions: [
        if (roomCubit.getoLocalUser()?.isOwner == true)
          IconSlideAction(
              caption: 'Ban',
              color: Colors.red.shade900,
              icon: Icons.block_sharp,
              onTap: () => roomCubit.changeUserPrivileges(user,
                  canWrite: false, isApporved: false, isAdmin: false)),
        if (roomCubit.getoLocalUser()?.isAdmin == true)
          IconSlideAction(
              caption: 'Kick user',
              color: Colors.orange.shade700,
              icon: Icons.delete_sweep,
              onTap: () => roomCubit.kickUser(
                  roomCubit.state.currentRoom!.groupID!, user!)),
        if (roomCubit.getoLocalUser()?.isAdmin == true)
          IconSlideAction(
              caption: 'Can`t write',
              color: Colors.indigo,
              icon: Icons.arrow_downward_sharp,
              onTap: () => roomCubit.changeUserPrivileges(user,
                  canWrite: !user!.canWrite!)),
      ],
      child: ListTile(
          title: Text(user!.name.toString()),
          subtitle: Text(user!.nickName.toString())),
    );
  }
}

class RequestedTile extends StatelessWidget {
  MyUser? user;
  var roomCubit = GetIt.I.get<RoomCubit>();
  RequestedTile(this.user, this.roomCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MyUser? user;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Accept',
          color: Colors.greenAccent.shade700,
          icon: Icons.check,
          onTap: () =>
              roomCubit.changeUserPrivileges(user, canWrite: !user!.canWrite!),
        )
      ],
      actions: <Widget>[
        IconSlideAction(
            caption: 'Decline',
            color: Colors.red.shade800,
            icon: Icons.cancel,
            onTap: () =>
                roomCubit.kickUser(roomCubit.state.currentRoom!.groupID!, user!)
            // roomCubit.changeUserPrivileges(user,
            //     isApporved: !user!.isApporved!),
            )
      ],
      child: ListTile(
          title: Text(user!.name.toString()),
          subtitle: Text(user!.nickName.toString())),
    );
  }
}

class BannedUsersTile extends StatelessWidget {
  MyUser? user;
  var roomCubit = GetIt.I.get<RoomCubit>();
  BannedUsersTile(this.user, this.roomCubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MyUser? user;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Unban',
          color: Colors.greenAccent.shade700,
          icon: Icons.check,
          onTap: () => roomCubit.changeUserPrivileges(user,
              canWrite: true, isApporved: true),
        )
      ],
      // actions: <Widget>[
      //   IconSlideAction(
      //       caption: 'Decline',
      //       color: Colors.red.shade800,
      //       icon: Icons.cancel,
      //       onTap: () =>
      //           roomCubit.kickUser(roomCubit.state.currentRoom!.groupID!, user!)
      //       // roomCubit.changeUserPrivileges(user,
      //       //     isApporved: !user!.isApporved!),
      //       )
      // ],
      child: ListTile(
          // trailing: Row(
          //   mainAxisSize: MainAxisSize.min,
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     IconButton(
          //         onPressed: () {
          //           roomCubit.changeUserPrivileges(user,
          //               canWrite: !user!.canWrite!);
          //         },
          //         icon: Icon(Icons.check)),

          //     IconButton(
          //         onPressed: () {
          //           roomCubit.changeUserPrivileges(user,
          //               isApporved: !user!.isApporved!);
          //         },
          //         icon: Icon(Icons.block_sharp))
          //   ],
          // ),
          title: Text(user!.name.toString()),
          subtitle: Text(user!.nickName.toString())),
    );
  }
}
