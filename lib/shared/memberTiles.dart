import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/states/room_state.dart';
import 'package:my_chat_app/models/user.dart';

class TilesMethods {
  String? groupID;
  final roomCubit = GetIt.I.get<RoomCubit>();

  Widget buildBannedDudes(RoomState state, List<MyUser> _users) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.currentRoom?.members?.length,
        itemBuilder: (context, index) {
          MyUser? user = _users[index];
          if (user.isAdmin == false &&
              user.isOwner != true &&
              user.isApporved == false &&
              user.canWrite == false)
            return BannedUsersTile(user, roomCubit);
          // UsersTile(
          //   _users[index],
          //   TileType.banned,
          //   captionPromote: 'Unban',
          //   icon: Icons.check,
          //   callbackIn: () => roomCubit.changeUserPrivileges(_users[index],
          //       canWrite: true, isApporved: true),
          // );
          else
            return SizedBox.shrink();
        });
  } //я понял принцип, но в некоторых больше одного действия. Справедливо. Хорошо остальные доделаю также.Посмотришь подгрузку мою? Ок

  ListView buildJoinRequests(RoomState state, List<MyUser> _users) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.currentRoom?.members?.length,
        itemBuilder: (context, index) {
          MyUser? user = _users[index];
          if (user.isAdmin == false &&
              user.isOwner != true &&
              user.isApporved == true &&
              user.canWrite == false)
            return RequestedTile(user, roomCubit);
          // UsersTile(
          //   _users[index],
          //   TileType.requested,
          //   captionPromote: 'Accept',
          //   captionDemote: 'Decline',
          //   callbackIn: () => roomCubit.changeUserPrivileges(_users[index],
          //       canWrite: !_users[index].canWrite!),
          //   callbackOut: () => roomCubit.kickUser(
          //       roomCubit.state.currentRoom!.groupID!, _users[index]),
          // );
          else
            return SizedBox.shrink();
        });
  }

  ListView buildMemberTiles(RoomState state, List<MyUser> _users) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.currentRoom?.members?.length,
        itemBuilder: (context, index) {
          MyUser? user = _users[index];
          if (user.isAdmin == false &&
              user.isOwner != true &&
              user.isApporved == true &&
              user.canWrite == true)
            return MemberTile(user, roomCubit);
          // UsersTile(
          //   _users[index],
          //   TileType.member,
          //   captionPromote: 'Promote',
          //   callbackIn: () =>
          //       roomCubit.changeUserPrivileges(user, isAdmin: !user.isAdmin!),
          //   captionDemote: 'Ban',
          //   callbackOut: () => roomCubit.changeUserPrivileges(user,
          //       canWrite: false, isApporved: false, isAdmin: false),
          //   captionDemote1: 'Kick user',
          //   callbackOut1: () => roomCubit.kickUser(
          //       roomCubit.state.currentRoom!.groupID!, user),
          //   captionDemote2: 'Can`t write',
          //   callbackOut2: () => roomCubit.changeUserPrivileges(user,
          //       canWrite: !user.canWrite!),
          // );
          else
            return SizedBox.shrink();
        });
  }

  Widget buildAdminTiles(RoomState state, List<MyUser> _users) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.currentRoom?.members?.length,
        itemBuilder: (context, index) {
          MyUser? user = _users[index];
          if (user.isAdmin == true && user.isOwner != true)
            return AdminTile(user, roomCubit);
          // UsersTile(
          //   user,
          //   TileType.admin,
          //   captionDemote: 'Demote',
          //   callbackOut: () =>
          //       roomCubit.changeUserPrivileges(user, isAdmin: !user.isAdmin!),
          //   captionDemote1: 'Kick user',
          //   callbackOut1: () => roomCubit.kickUser(
          //       roomCubit.state.currentRoom!.groupID!, user),
          //   captionDemote2: 'Ban',
          //   callbackOut2: () => roomCubit.changeUserPrivileges(user,
          //       canWrite: !user.canWrite!,
          //       isApporved: !user.isApporved!,
          //       isAdmin: !user.isAdmin!),
          // );
          else
            return SizedBox.shrink();
        });
  }

  IconButton buildLeaveOrDeleteButton(
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
                              roomCubit.dissolveRoom(groupID!);
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
                                  groupID!, currentMemberofThisRoom!);
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

enum TileType {
  admin,
  member,
  requested,
  banned,
}

// class UsersTile extends StatelessWidget {
//   MyUser? user;
//   TileType? type;
//   VoidCallback? callbackIn;
//   VoidCallback? callbackOut;
//   VoidCallback? callbackOut1;
//   VoidCallback? callbackOut2;
//   String? captionPromote;
//   String? captionDemote;
//   String? captionDemote1;
//   String? captionDemote2;
//   IconData? icon;
//   UsersTile(
//     this.user,
//     this.type, {
//     this.callbackIn,
//     this.callbackOut,
//     this.callbackOut1,
//     this.callbackOut2,
//     this.captionPromote,
//     this.captionDemote,
//     this.captionDemote1,
//     this.captionDemote2,
//     this.icon,
//     Key? key,
//   }) : super(key: key);
//   final roomCubit = GetIt.I.get<RoomCubit>();
//   @override
//   Widget build(BuildContext context) {
//     return Slidable(
//       actionPane: SlidableDrawerActionPane(),
//       actionExtentRatio: 0.25,
//       secondaryActions: <Widget>[
//         if (type == TileType.banned) // Banned unban
//           IconSlideAction(
//             caption: captionPromote,
//             color: Colors.greenAccent.shade700,
//             icon: icon,
//             onTap: callbackIn,
//           ),
//         if (type == TileType.requested) //accept requested
//           IconSlideAction(
//             caption: captionPromote,
//             color: Colors.greenAccent.shade700,
//             icon: Icons.check,
//             onTap: callbackIn,
//           ),
//         if (type == TileType.member)
//           if (roomCubit.getoLocalUser()?.isOwner == true)
//             IconSlideAction(
//                 caption: captionPromote,
//                 color: Colors.greenAccent.shade700,
//                 icon: Icons.arrow_upward_sharp,
//                 onTap: callbackIn),
//         if (type == TileType.admin)
//           if (roomCubit.getoLocalUser()?.isOwner == true)
//             IconSlideAction(
//                 caption: captionDemote,
//                 color: Colors.indigo,
//                 icon: Icons.arrow_downward_sharp,
//                 onTap: callbackOut //DEMOTE ADMIN
//                 // () => roomCubit.changeUserPrivileges(user,
//                 //     isAdmin: !user!.isAdmin!)
//                 ),
//       ],
//       actions: <Widget>[
//         if (type == TileType.requested) //decline requested
//           IconSlideAction(
//               caption: captionDemote,
//               color: Colors.red.shade800,
//               icon: Icons.cancel,
//               onTap: callbackOut),
//         if (type == TileType.member)
//           if (roomCubit.getoLocalUser()?.isAdmin == true)
//             IconSlideAction(
//                 caption: captionDemote,
//                 color: Colors.red.shade900,
//                 icon: Icons.block_sharp,
//                 onTap: callbackOut), //BAN MEMBER
//         IconSlideAction(
//             caption: captionDemote1,
//             color: Colors.orange.shade700,
//             icon: Icons.delete_sweep,
//             onTap: callbackOut1), //KICK MEMBER
//         // if (roomCubit.getoLocalUser()?.isAdmin == true)
//         IconSlideAction(
//             caption: captionDemote2,
//             color: Colors.indigo,
//             icon: Icons.arrow_downward_sharp,
//             onTap: callbackOut2), //CANT WRITE
//         // if (type == TileType.admin)
//         //   if (roomCubit.getoLocalUser()?.isOwner == true)
//         // //     IconSlideAction(
//         //         caption: captionDemote1,
//         //         color: Colors.orange.shade700,
//         //         icon: Icons.delete_sweep,
//         //         onTap: callbackOut1),
//         // IconSlideAction(
//         //     caption: captionDemote2,
//         //     color: Colors.red.shade900,
//         //     icon: Icons.block_sharp,
//         //     onTap: callbackOut2),
//       ],
//       child: ListTile(
//           title: Text(user!.name.toString()),
//           subtitle: Text(user!.nickName.toString())),
//     );
//   }
// }

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
      child: ListTile(
          title: Text(user!.name.toString()),
          subtitle: Text(user!.nickName.toString())),
    );
  }
}
