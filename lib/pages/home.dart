import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/backdrop_test.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/states/auth_state.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';

import 'package:my_chat_app/cubit/states/room_state.dart';

import 'package:my_chat_app/cubit/cubit/user_cubit.dart';

import 'package:my_chat_app/models/room.dart';
import 'package:my_chat_app/pages/chatPage.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/services/wrapper.dart';
import 'package:my_chat_app/pages/anotherGroupCreator.dart';

import '../sliver_test.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<MyUser>? listUsers;
  List<Room>? listRooms;
  final data = GetIt.I.get<DataBaseService>();

  // String? groupName;
  // List avavailfableChats = [];
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();

  // final _auth = GetIt.I.get<FirebaseAuth>();
  // final dialog = GetIt.I.get<AnotherGroupCreator>();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      // if (userCubit.state.listUsers == null) {
      //   await userCubit.getUsersList();
      // }
      roomCubit.loadRooms(); //тут он хочет фючу как и было у меня
      scrollController.addListener(() {
        if (scrollController.position.atEdge) {
          if (scrollController.position.pixels == 0) {
            print('we are on top');
          } else {
            print('we are at bottom');
            roomCubit.getNextRooms();
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(authCubit.state.currentUser);

    // roomCubit.fetchDocs(
    //     data.roomsStream()); // я просто тестил что он работает хотя бы так
    final ThemeData theme = Theme.of(context);
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, state) {
        // print('this users code: ${state.currentUser?.colorCode}');
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
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                      // style: ButtonStyle(
                      //     backgroundColor: MaterialStateProperty.all<Color>(
                      //         Colors.amber.shade700)),
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () async {
                        await authCubit.logOut();
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (BuildContext context) => Wrapper(),
                        ));
                        // Navigator.pushAndRemoveUntil<void>(
                        //   context,
                        //   MaterialPageRoute<void>(
                        //       builder: (BuildContext context) => Wrapper()),
                        //   ModalRoute.withName('/wrapper'),
                        // );
                        // // print(
                        //     'THIS IS LOG OUT PRINT. first param: ${authCubit.fbAuth}, second: ${authCubit.state.isLoggedIn}');
                        // await _auth.signOut();
                      },
                      // label: Text('Log out'),
                      /// где загрузка на этой странце]\
                    ),
                  )
                ],
                title: Text("${roomCubit.state.category} rooms")),
            body: Center(
                child: BlocBuilder<RoomCubit, RoomState>(
                    bloc: roomCubit,
                    builder: (context, state) {
                      if (state.listRooms == null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0)),
                          child: Center(
                            child: Text('There is a problem, no cap'),
                          ),
                        );
                      } else if (state.listRooms!.length > 0) {
                        return ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0)),
                            child: _buildRooms(state, theme, scrollController));
                      }
                      return CircularProgressIndicator();
                    })),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                // List cats = [];
                // data.categories.forEach((element) {
                //   cats.add(element['option']);
                // });
                // // print(cats);
                // for (var i = 0; i < 200; i++) {
                //   String _cat = cats[Random().nextInt(cats.length)];
                //   data.createGroup([
                //     authCubit.state.currentUser!.copyWith(
                //       isAdmin: true,
                //       canWrite: true,
                //       isOwner: true,
                //       isApporved: true,
                //     )
                //   ],
                //       authCubit.state.currentUser!,
                //       '$_cat room number $i',
                //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                //       false,
                //       _cat);
                // }

                // print(authCubit.state.currentUser);
                // roomCubit.loadRooms();
                // Navigator.of(context).push(MaterialPageRoute<void>(
                //         builder: (BuildContext context) =>
                //             // SliverPage()
                //             AnotherGroupCreator(false,
                //                 category: roomCubit.state.category)
                //         // BackDropPage()
                //         )
                //     // )
                //     );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildRooms(
      RoomState state, ThemeData theme, ScrollController scrollController) {
    return
        // Stack(
        //   children: [
        //     ColorFiltered(
        //       colorFilter:
        //           ColorFilter.mode(Colors.amber.shade100, BlendMode.screen),
        //       child: Container(
        //           height: double.infinity,
        //           width: double.infinity,
        //           decoration: BoxDecoration(
        //             // color: Theme.of(context).scaffoldBackgroundColor),
        //             image: DecorationImage(
        //                 scale: 0.3,
        //                 repeat: ImageRepeat.repeat,
        //                 // fit: BoxFit.cover,
        //                 image: theme.brightness == Brightness.dark
        //                     ? AssetImage(
        //                         'assets/dark_back.png',
        //                       )
        //                     : AssetImage('assets/light_back.jpg')),
        //           ),
        //           child: BackdropFilter(
        //               filter: theme.brightness == Brightness.dark
        //                   ? ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0)
        //                   : ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        //               child: Container()

        //               // Text(roomCubit.displayRooms().toString())
        //               // Text("${currentUser?.uid.toString()} \n\n $senderId")
        //               // roomCubit.displayRooms(),
        //               )),
        //     ),
        Container(
      decoration:
          BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: ListView.builder(
          controller: scrollController,
          itemCount: state.listRooms?.length,
          itemBuilder: (context, index) {
            List<Room>? _list = state.listRooms;
            // print(_list?.length);
            // MyUser? currentUser = authCubit.state.currentUser;
            return Column(
              children: [
                ListTile(
                  trailing: Text("$index"),
                  //  _list![index].isPrivate
                  //     ? Icon(Icons.lock_outline)
                  //     : SizedBox.shrink(),
                  title: Text(
                    "${_list![index].topicTheme}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: _list[index].isPrivate
                      ? _list[index].members?.contains(roomCubit.getoLocalUser(
                                  thatRoom: _list[index])) ==
                              true
                          ? Text(
                              "${_list[index].lastMessage?.sender?.name}: ${_list[index].lastMessage?.content}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null
                      : Text(
                          "${_list[index].lastMessage?.sender?.name}: ${_list[index].lastMessage?.content}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  onTap: () async {
                    // roomCubit.setRoomAsCurrent(_list[index].groupID!);
                    await roomCubit.loadChat(_list[index].groupID!).then(
                        (value) =>
                            Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ChatPage(_list[index].groupID!),
                            ))
                        // print(
                        //     'THIS IS THAT: ${state.currentRoom?.chatMessages}')
                        );
                  },
                ),
                Divider()
              ],
            );
          }),
    );
    //   ],
    // );
  }
}
