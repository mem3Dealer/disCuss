import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/models/user.dart';

class RoomMembersPage extends StatelessWidget {
  final roomCubit = GetIt.I.get<RoomCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  RoomMembersPage(this.groupID, {Key? key}) : super(key: key);
  final String groupID;

  @override
  Widget build(BuildContext context) {
    MyUser? currentMemberofThisRoom = roomCubit.getoLocalUser();
    // final MyUser currentUser = authCubit.state.currentUser!;
    return BlocBuilder<RoomCubit, RoomState>(
      bloc: roomCubit,
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(title: Text('Chat members')),
            body: Container(
                child: Center(
              child: Column(
                children: [
                  // Text( authCubit.state.currentUser.t)
                  Container(
                    // height: 300,
                    // width: 300,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.currentRoom?.members?.length,
                          // state.room?.members?.length,
                          itemBuilder: (context, index) {
                            List<MyUser>? _members = state.currentRoom?.members;
                            // if ()
                            return ListTile(
                                enabled: authCubit.state.currentUser?.uid !=
                                    _members?[index].uid,
                                trailing: authCubit.state.currentUser?.uid !=
                                            _members?[index].uid &&
                                        currentMemberofThisRoom?.isOwner == true
                                    ? IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          roomCubit.kickUser(
                                              groupID, _members![index]);
                                        },
                                      )
                                    : SizedBox.shrink(),
                                title:
                                    // Text(
                                    //     "${currentUser.uid == _members?[index].uid}"),
                                    Text(_members![index].name.toString()),
                                // Text(_members![index].name!),
                                subtitle: Text(_members[index].email.toString())
                                // Text(_members[index].email!),
                                );
                            // else
                            //   return SizedBox.shrink();
                          }),
                    ),
                  ),
                ],
              ),
            )));
      },
    );
  }
}
