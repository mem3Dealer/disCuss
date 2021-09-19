import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/core/localization/generated/l10n.dart';
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
    final trText = GetIt.I.get<I10n>();
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

    return MyScaffold(
      Text(trText.memPageTitle),
      Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Text( authCubit.state.currentUser.t)
              _buildListOfMembers(
                  _users,
                  areThereAdmins,
                  tiles,
                  areThereMembers,
                  currentMemberofThisRoom!,
                  areThereReqeusts,
                  areThereBanned),
              _buildSaveOrDiscardButtons(currentMemberofThisRoom, context),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
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
              tiles.buildLeaveOrDeleteButton(
                  currentMemberofThisRoom, context, widget.groupID)
            ],
          ),
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
              final trText = GetIt.I.get<I10n>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Label(trText.memPageLabelCreator),
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
                  if (areThereAdmins) Label(trText.memPageLabelAdmins),
                  // _buildAdminTiles(state, _users),
                  tiles.buildAdminTiles(state, _users),
                  SizedBox(
                    height: 15,
                  ),

                  if (areThereMembers) Label(trText.memPageLabelMembers),
                  tiles.buildMemberTiles(state, _users),
                  // _buildMemberTiles(state, _users),
                  SizedBox(
                    height: 15,
                  ),

                  if (currentMemberofThisRoom.isAdmin == true)
                    if (areThereReqeusts) Label(trText.memPageLabelReqs),
                  // _buildJoinRequests(state, _users),
                  tiles.buildJoinRequests(state, _users),
                  if (currentMemberofThisRoom.isOwner == true)
                    if (areThereBanned) Label(trText.memPageLabelBanned),
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
    final trText = GetIt.I.get<I10n>();
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
                      trText.memPageButtonCancel,
                      style: TextStyle(fontSize: 18),
                    )),
                ElevatedButton(
                    onPressed: () {
                      roomCubit.saveRoomChanges();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      trText.memPageButtonSave,
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            )
          : SizedBox.shrink(),
    );
  }
}
