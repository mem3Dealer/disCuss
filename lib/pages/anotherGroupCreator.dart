import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_state.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/shared/input.dart';

final formKey = GlobalKey<FormState>();
final _editFormKey = GlobalKey<FormState>();
final verySpecialKey = GlobalKey<FormState>();

class AnotherGroupCreator extends StatefulWidget {
  bool? isEditing;
  AnotherGroupCreator(this.isEditing);
  @override
  _AnotherGroupCreatorState createState() => _AnotherGroupCreatorState();
}

class _AnotherGroupCreatorState extends State<AnotherGroupCreator> {
  final _topicTheme = TextEditingController();
  final _topicContent = TextEditingController();

  final _searchBy = TextEditingController();
  // final _anotherSearchBy = TextEditingController();
  final scrollController = ScrollController();
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();
  final data = GetIt.I.get<DataBaseService>();
  bool _isPrivate = false;
  // String? _error = '';

  @override
  Widget build(BuildContext context) {
    bool _isEditing = widget.isEditing!;
    String? nickNameIsValid;
    List<MyUser>? _selectedUsers = userCubit.state.selectedUsers;
    MyUser? authCurrentUser = authCubit.state.currentUser;
    // print(roomCubit.state.currentRoom!.isPrivate);
    if (_isEditing == false) {
      if (!_selectedUsers!.contains(authCurrentUser?.uid))
        _selectedUsers.add(authCurrentUser!.copyWith(
            isOwner: true, canWrite: true, isAdmin: true, isApporved: true));
    }
    final _editingTopicContent =
        TextEditingController(text: roomCubit.state.currentRoom?.topicContent);
    final _themeEditingController =
        TextEditingController(text: roomCubit.state.currentRoom?.topicTheme);
    // print("PRINT FROM BUILD: ${userCubit.state.selectedUsers}");
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: _isEditing
              ? Text('Editing page')
              : Text('What do you want to discuss?'),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: BlocBuilder<RoomCubit, RoomState>(
                  bloc: roomCubit,
                  builder: (context, state) {
                    return IconButton(
                        onPressed: () {
                          _isPrivate = roomCubit.markAsPrivate();
                        },
                        icon: state.currentRoom!.isPrivate
                            ? Icon(Icons.lock)
                            : Icon(Icons.lock_open));
                  },
                ))
          ],
        ),
        body: Center(
            child: Container(
                child: SingleChildScrollView(
          child: Column(
            children: [
              Column(children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      buildTopicTheme(_isEditing, _themeEditingController),
                      buildTopicContent(_isEditing, _editingTopicContent),
                    ],
                  ),
                ),
                // _isEditing
                //     ?
                _addMember(nickNameIsValid, _isEditing)
                // : Form(
                //     key: verySpecialKey,
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: TextFormField(
                //           // key: ,
                //           controller: _searchBy,
                //           validator: (val) {
                //             if (val?.contains('@') == false) {
                //               return 'please enter nickname starting with @';
                //             }
                //             // print('print $nickNameIsValid');
                //             // print(val);
                //             if (nickNameIsValid.runtimeType == String) {
                //               // return nickNameIsValid.toString();
                //               return '$nickNameIsValid';
                //             } else
                //               return null;
                //           },
                //           decoration: textInputDecoration.copyWith(
                //               hintText:
                //                   'Enter nametag of a person and hit add')),
                //     ),
                //   ),
                ,
                SizedBox(
                  height: 5,
                ),
                _isEditing
                    ? ElevatedButton(
                        onPressed: () async {
                          var _user =
                              await userCubit.searchMember(_searchBy.text);

                          if (_user.runtimeType == String) {
                            nickNameIsValid = _user.toString();
                          } else {
                            MyUser? _addingUser = _user;
                            // print(_addingUser);
                            bool contained = roomCubit
                                .state.currentRoom!.members!
                                .any((element) {
                              return element.uid == _addingUser!.uid;
                            });
                            bool alsoContained =
                                userCubit.state.selectedUsers!.any((element) {
                              return element.uid == _addingUser!.uid;
                            });

                            if (contained || alsoContained) {
                              nickNameIsValid = 'This user already selected';
                            } else {
                              userCubit.selectUser(_addingUser!);
                            }
                          }
                          if (_editFormKey.currentState!.validate()) {}
                        },
                        child: Text('Add'))
                    : ElevatedButton(
                        onPressed: () async {
                          var _user =
                              await userCubit.searchMember(_searchBy.text);

                          if (_user.runtimeType == String) {
                            nickNameIsValid = _user.toString();
                          } else {
                            MyUser? _addingUser = _user;
                            // print(_addingUser);
                            bool contained =
                                userCubit.state.selectedUsers!.any((element) {
                              return element.uid == _addingUser!.uid;
                            });
                            if (contained) {
                              nickNameIsValid = 'This user already selected';
                            } else {
                              userCubit.selectUser(_addingUser!);
                            }
                          }
                          if (verySpecialKey.currentState!.validate()) {}
                        },
                        child: Text('Add')),
                _buildAddingMembersTiles(),
              ]),
              _isEditing
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: ElevatedButton(
                          child: Text(
                            "Save changes",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            // List<MyUser> selected = [];
                            // selected.addAll()
                            print(_themeEditingController.text);
                            if (formKey.currentState!.validate()) {
                              if (_editingTopicContent.text.isNotEmpty ||
                                  _themeEditingController.text.isNotEmpty ||
                                  userCubit.state.selectedUsers!.isNotEmpty)
                                roomCubit
                                    .updateRoomData(
                                        isPrivate: _isPrivate,
                                        topicContent: _editingTopicContent.text,
                                        topicTheme:
                                            _themeEditingController.text,
                                        selectedUsers:
                                            userCubit.state.selectedUsers)
                                    .then((value) {
                                  userCubit.dismissSelected();
                                  _searchBy.clear();
                                  // print(
                                  //     'THIS IS THAT PRINT:${userCubit.state.selectedUsers}');
                                  _editingTopicContent.clear();
                                  _themeEditingController.clear();
                                  Navigator.of(context).pop();
                                });
                            } else {
                              print('did not validated');
                            }
                          },
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: ElevatedButton(
                          child: Text(
                            "Create",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            // List<MyUser> selected = [];
                            // selected.addAll()
                            if (formKey.currentState!.validate()) {
                              roomCubit
                                  .createRoom(
                                      userCubit.state.selectedUsers!,
                                      // authCubit.state.currentUser!,
                                      userCubit.state.selectedUsers?.first,
                                      context,
                                      _topicTheme.text,
                                      _topicContent.text,
                                      _isPrivate)
                                  .then((value) {
                                userCubit.state.selectedUsers!.clear();
                                _topicContent.clear();
                                _topicTheme.clear();
                              });
                            } else {
                              print('did not validated');
                            }
                          },
                        ),
                      ),
                    ),
            ],
          ),
        )

                // _isEditing
                //     ? buildBodyForEditing()
                //     // buildBodyForReducting(userExists)
                //     : buildBodyForNewGroup()),
                )));
  }

  BlocBuilder<UserCubit, UserListState> _buildAddingMembersTiles() {
    return BlocBuilder<UserCubit, UserListState>(
      bloc: userCubit,
      builder: (context, state) {
        // print(state.selectedUsers?.toSet().toList());
        return
            // Container(child: Text('oops')
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.selectedUsers?.length,
                itemBuilder: (context, index) {
                  // List<MyUser>? selected = state.selectedUsers;
                  List<MyUser>? listUsers = state.selectedUsers;

                  if (listUsers?[index].uid ==
                          authCubit.state.currentUser?.uid ||
                      listUsers?[index].uid == null)
                    return SizedBox.shrink();
                  else
                    return ListTile(
                      // onTap: () {
                      //   // listUsers!
                      //   //     .remove(listUsers[index]);
                      // },
                      trailing: IconButton(
                          onPressed: () {
                            userCubit.deleteFromSelected(listUsers![index]);
                          },
                          icon: Icon(Icons.cancel)),
                      title: Text(
                        listUsers![index].name.toString(),
                      ),
                      subtitle: Text(listUsers[index].nickName.toString()),
                    );
                });
      },
    );
  }

  Form _addMember(String? nickNameIsValid, bool _isEditing) {
    return Form(
      key: _isEditing ? _editFormKey : verySpecialKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            // key: ,
            controller: _searchBy,
            validator: (val) {
              if (val?.contains('@') == false) {
                return 'please enter nickname starting with @';
              }
              if (nickNameIsValid.runtimeType == String) {
                // return nickNameIsValid.toString();
                return '$nickNameIsValid';
              } else
                return null;
            },
            decoration: textInputDecoration.copyWith(
                // hintText: 'fuck'
                // widget.isEdit,ing!
                //     ? 'Add new member to this discussion'
                //     :
                // 'Add members',
                hintText: 'Enter nametag of a person and hit add')
            //  InputDecoration(
            //     contentPadding: EdgeInsets.only(left: 8),
            // hintText:
            //     'Enter nametag of a person and hit add'),
            ),
      ),
    );
  }

  Padding buildTopicContent(
      bool _isEditing, TextEditingController _editingTopicContent) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _isEditing
          ? TextFormField(
              maxLines: 5,
              controller: _editingTopicContent,
              decoration: textInputDecoration.copyWith(
                  labelText: 'Edit discussion content',
                  hintText: "${roomCubit.state.currentRoom?.topicContent}"))
          : TextFormField(
              maxLines: 5,
              controller: _topicContent,
              validator: (val) =>
                  val!.isEmpty ? "Please enter discussion topic!" : null,
              decoration: textInputDecoration.copyWith(
                  // labelText: 'Enter topic content',
                  hintText:
                      'What happened? Expand the topic. \n\nPress lock icon above, if you want this room to be private.')
              //  InputDecoration(
              //     contentPadding: EdgeInsets.only(left: 8.0),
              //     hintText:
              //         'What happened? Expand the topic. \n\nPress lock icon above, if you want this room to be private.'),
              ),
    );
  }

  Padding buildTopicTheme(
      bool _isEditing, TextEditingController _themeEditingController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _isEditing
          ? TextFormField(
              controller: _themeEditingController,
              decoration: textInputDecoration.copyWith(
                  labelText: 'Edit discussion theme',
                  hintText:
                      'theme is: ${roomCubit.state.currentRoom?.topicTheme.toString()}'))
          : TextFormField(
              controller: _topicTheme,
              validator: (val) =>
                  val!.isEmpty ? "Please enter discussion topic!" : null,
              decoration: textInputDecoration.copyWith(
                  hintText: 'What`s the topic? Be laconic.')
              // InputDecoration(
              //     contentPadding: EdgeInsets.only(left: 8.0),
              //     hintText: 'What`s the topic? Be laconic.'),
              ),
    );
  }

  // buildBodyForEditing() {
  //   String? nickNameIsValid;
  //   return Column(
  //     children: [
  //       Expanded(
  //           child: SingleChildScrollView(
  //         child: Column(children: [
  //           Form(
  //             key: formKey,
  //             child: Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: TextFormField(
  //                     controller: _topicTheme,
  //                     // validator: (val) => val!.isEmpty
  //                     //     ? "Please enter discussion topic!"
  //                     //     : null,
  //                     decoration: InputDecoration(
  //                         contentPadding: EdgeInsets.only(left: 8.0),
  //                         hintText:
  //                             '${roomCubit.state.currentRoom?.topicTheme}'),
  //                   ),
  //                 ),
  //                 Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: TextFormField(
  //                       maxLines: 5,
  //                       controller: _topicContent,
  //                       // validator: (val) => val!.isEmpty
  //                       //     ? "Please enter discussion topic!"
  //                       //     : null,
  //                       decoration: InputDecoration(
  //                         contentPadding: EdgeInsets.only(left: 8.0),
  //                         hintText:
  //                             ("${roomCubit.state.currentRoom?.topicContent}"),
  //                       ),
  //                     )),
  //               ],
  //             ),
  //           ),
  //           Form(
  //             key: _editFormKey,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: TextFormField(
  //                 // key: ,
  //                 controller: _searchBy,
  //                 validator: (val) {
  //                   if (val?.contains('@') == false) {
  //                     return 'please enter nickname starting with @';
  //                   }
  //                   if (nickNameIsValid.runtimeType == String) {
  //                     // return nickNameIsValid.toString();
  //                     return '$nickNameIsValid';
  //                   } else
  //                     return null;
  //                 },
  //                 decoration: InputDecoration(
  //                     contentPadding: EdgeInsets.only(left: 8),
  //                     hintText: 'Enter nametag of a person and hit add'),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           ElevatedButton(
  //               onPressed: () async {
  //                 var _user = await userCubit.searchMember(_searchBy.text);

  //                 if (_user.runtimeType == String) {
  //                   nickNameIsValid = _user.toString();
  //                 } else {
  //                   MyUser? _addingUser = _user;
  //                   // print(_addingUser);
  //                   bool contained =
  //                       roomCubit.state.currentRoom!.members!.any((element) {
  //                     return element.uid == _addingUser!.uid;
  //                   });
  //                   bool alsoContained =
  //                       userCubit.state.selectedUsers!.any((element) {
  //                     return element.uid == _addingUser!.uid;
  //                   });

  //                   if (contained || alsoContained) {
  //                     nickNameIsValid = 'This user already selected';
  //                   } else {
  //                     userCubit.selectUser(_addingUser!);
  //                   }
  //                 }
  //                 if (_editFormKey.currentState!.validate()) {}
  //               },
  //               child: Text('Add')),
  //           BlocBuilder<UserCubit, UserListState>(
  //             bloc: userCubit,
  //             builder: (context, state) {
  //               // print(state.selectedUsers?.toSet().toList());
  //               return
  //                   // Container(child: Text('oops')
  //                   ListView.builder(
  //                       physics: NeverScrollableScrollPhysics(),
  //                       shrinkWrap: true,
  //                       itemCount: state.selectedUsers?.length,
  //                       itemBuilder: (context, index) {
  //                         // List<MyUser>? selected = state.selectedUsers;
  //                         List<MyUser>? listUsers = state.selectedUsers;

  //                         if (listUsers?[index].uid ==
  //                                 authCubit.state.currentUser?.uid ||
  //                             listUsers?[index].uid == null)
  //                           return SizedBox.shrink();
  //                         else
  //                           return ListTile(
  //                             trailing: IconButton(
  //                                 onPressed: () {
  //                                   userCubit
  //                                       .deleteFromSelected(listUsers![index]);
  //                                 },
  //                                 icon: Icon(Icons.cancel)),
  //                             title: Text(
  //                               listUsers![index].name.toString(),
  //                             ),
  //                             subtitle:
  //                                 Text(listUsers[index].nickName.toString()),
  //                           );
  //                       });
  //             },
  //           ),
  //         ]),
  //       )),
  //       Align(
  //         alignment: Alignment.bottomCenter,
  //         child: Padding(
  //           padding: EdgeInsets.only(bottom: 8.0),
  //           child: ElevatedButton(
  //             child: Text(
  //               "Save changes",
  //               style: TextStyle(fontSize: 20),
  //             ),
  //             onPressed: () {
  //               // List<MyUser> selected = [];
  //               // selected.addAll()
  //               print(
  //                   'THIS IS THAT PRINT: ${roomCubit.state.currentRoom?.topicContent}, ${roomCubit.state.currentRoom?.topicTheme}');
  //               if (formKey.currentState!.validate()) {
  //                 if (_topicContent.text.isNotEmpty ||
  //                     _topicTheme.text.isNotEmpty ||
  //                     userCubit.state.selectedUsers!.isNotEmpty)
  //                   roomCubit
  //                       .updateRoomData(
  //                           topicContent: _topicContent.text,
  //                           topicTheme: _topicTheme.text,
  //                           selectedUsers: userCubit.state.selectedUsers)
  //                       .then((value) {
  //                     userCubit.state.selectedUsers!.clear();
  //                     _topicContent.clear();
  //                     _topicTheme.clear();
  //                   });

  //                 // roomCubit
  //                 //     .createRoom(
  //                 //         userCubit.state.selectedUsers!,
  //                 //         // authCubit.state.currentUser!,
  //                 //         userCubit.state.selectedUsers?.first,
  //                 //         context,
  //                 //         _topicTheme.text,
  //                 //         _topicContent.text,
  //                 //         _isPrivate)
  //                 //     .then((value) {
  //                 //   userCubit.state.selectedUsers!.clear();
  //                 //   _topicContent.clear();
  //                 //   _topicTheme.clear();
  //                 // });
  //               } else {
  //                 print('did not validated');
  //               }
  //             },
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // // buildBodyForNewGroup() {
  //   String? nickNameIsValid;
  //   return
  // }
}
