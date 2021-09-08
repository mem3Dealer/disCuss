import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/states/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/anotherGroupCreator.dart';
import 'package:my_chat_app/shared/memberTiles.dart';
import 'package:my_chat_app/shared/myScaffold.dart';

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
    // final ThemeData theme = Theme.of(context);
    final tiles = TilesMethods();
    List<MyUser>? _users = roomCubit.state.currentRoom?.members;
    MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
    bool areThereAdmins = _users!.any((element) {
      return element.isAdmin == true && element.isOwner != true;
    });
    bool areThereMembers = _users.any((element) {
      return element.isAdmin == false &&
          element.isOwner != true &&
          element.isApporved == true &&
          element.canWrite == true;
    });
    bool areThereReqeusts = _users.any((element) {
      return element.canWrite == false && element.isApporved == true;
    });
    bool areThereBanned = _users.any((element) {
      return element.isAdmin == false &&
          element.canWrite == false &&
          element.isApporved == false;
    });
    // Room? defaultRoomState = state.currentRoom;
    // return Container(
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //         scale: theme.brightness == Brightness.dark ? 7.5 : 0.3,
    //         repeat: ImageRepeat.repeat,
    //         // fit: BoxFit.cover,
    //         image: theme.brightness == Brightness.dark
    //             ? ExactAssetImage('assets/dark_back.png')
    //             : ExactAssetImage('assets/light_back.jpg')),
    //   ),
    //   child: BackdropFilter(
    //     filter: theme.brightness == Brightness.dark
    //         ? ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0)
    //         : ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
    //     child: Scaffold(
    //         backgroundColor: Colors.transparent,
    //         appBar:
    //             // MyAppBar(currentMemberofThisRoom, roomCubit, widget.groupID)),
    //             AppBar(
    //           backgroundColor: Colors.transparent,
    //           elevation: 0,
    //           title: Text('Chat members'),
    //           actions: [
    //             Row(
    //               children: [
    //                 if (currentMemberofThisRoom?.isAdmin == true)
    //                   IconButton(
    //                       onPressed: () {
    //                         Navigator.of(context).push(MaterialPageRoute<void>(
    //                             builder: (BuildContext context) =>
    //                                 AnotherGroupCreator(true)));
    //                       },
    //                       icon: Icon(Icons.edit)),
    //                 // _buildLeaveOrDeleteButton(currentMemberofThisRoom, context)
    //                 tiles.buildLeaveOrDeleteButton(
    //                     currentMemberofThisRoom, context)
    //               ],
    //             )
    //           ],
    //         ),
    //         body: ClipRRect(
    //           borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(25.0),
    //               topRight: Radius.circular(25.0)),
    //           child: Container(
    //               decoration: BoxDecoration(
    //                   color: Theme.of(context).scaffoldBackgroundColor),
    //               child:

    return MyScaffold(
      Text('Chat Members'),
      Center(
        child: Column(
          children: [
            // Text( authCubit.state.currentUser.t)
            _buildListOfMembers(_users, areThereAdmins, tiles, areThereMembers,
                currentMemberofThisRoom!, areThereReqeusts, areThereBanned),
            _buildSaveOrDiscardButtons(currentMemberofThisRoom, context),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            if (currentMemberofThisRoom.isAdmin == true)
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            AnotherGroupCreator(true)));
                  },
                  icon: Icon(Icons.edit)),
            // _buildLeaveOrDeleteButton(currentMemberofThisRoom, context)
            tiles.buildLeaveOrDeleteButton(currentMemberofThisRoom, context)
          ],
        )
      ],
    );
    //               ),
    //         )),
    //   ),
    // );
  }

  Container _buildListOfMembers(
      List<MyUser> _users,
      bool areThereAdmins,
      TilesMethods tiles,
      bool areThereMembers,
      MyUser currentMemberofThisRoom,
      bool areThereReqeusts,
      bool areThereBanned) {
    return Container(
      child: Expanded(
        child: SingleChildScrollView(
          child: BlocBuilder<RoomCubit, RoomState>(
            bloc: roomCubit,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Label('Creator:'),
                  ListTile(
                    title: Text(
                        _users.firstWhere((element) => element.isOwner!).name!),
                    subtitle: Text(_users
                        .firstWhere((element) => element.isOwner!)
                        .nickName!),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (areThereAdmins) Label('Admins:'),
                  // _buildAdminTiles(state, _users),
                  tiles.buildAdminTiles(state, _users),
                  SizedBox(
                    height: 15,
                  ),

                  if (areThereMembers) Label('Members:'),
                  tiles.buildMemberTiles(state, _users),
                  // _buildMemberTiles(state, _users),
                  SizedBox(
                    height: 15,
                  ),

                  if (currentMemberofThisRoom.isAdmin == true)
                    if (areThereReqeusts) Label('Join Requests:'),
                  // _buildJoinRequests(state, _users),
                  tiles.buildJoinRequests(state, _users),
                  if (currentMemberofThisRoom.isOwner == true)
                    if (areThereBanned) Label('Banned users:'),
                  // _buildBannedDudes(state, _users)
                  tiles.buildBannedDudes(state, _users)
                  // Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Padding _buildSaveOrDiscardButtons(
      MyUser currentMemberofThisRoom, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: currentMemberofThisRoom.isAdmin == true ||
              currentMemberofThisRoom.isOwner == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }
}
