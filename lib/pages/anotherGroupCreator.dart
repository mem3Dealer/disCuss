import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/states/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/cubit/states/user_state.dart';
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
          title: _isEditing ? Text('Editing page') : Text('New discussion'),
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
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        buildTopicTheme(_isEditing, _themeEditingController),
                        SizedBox(
                          height: 15,
                        ),
                        BlocBuilder<RoomCubit, RoomState>(
                          bloc: roomCubit,
                          builder: (context, state) {
                            return buildTopicContent(
                                _isEditing, _editingTopicContent);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Form(
                          key: _isEditing ? _editFormKey : verySpecialKey,
                          child: TextFormField(
                            // key: ,
                            decoration: InputDecoration().copyWith(
                                helperText: _isEditing
                                    ? 'Add new members'
                                    : 'Select members',
                                hintText: 'Enter nickname and hit add'),
                            controller: _searchBy,
                            validator: (val) {
                              if (val?.contains('@') == false) {
                                return 'please enter nickname starting with @';
                              }
                              if (nickNameIsValid.runtimeType == String) {
                                print('final print: $nickNameIsValid');
                                // return nickNameIsValid.toString();
                                return '$nickNameIsValid';
                              } else
                                return null;
                            },
                            // decoration: ,
                            // decoration: textInputDecoration.copyWith(
                            //     // hintText: 'fuck'
                            //     // widget.isEdit,ing!
                            //     //     ? 'Add new member to this discussion'
                            //     //     :
                            //     // 'Add members',
                            //     hintText: 'Enter nametag of a person and hit add')
                            //  InputDecoration(
                            //     contentPadding: EdgeInsets.only(left: 8),
                            // hintText:
                            //     'Enter nametag of a person and hit add'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      var _user = await userCubit.searchMember(_searchBy.text);
                      bool? contained;
                      bool? alsoContained;
                      bool? isContainedNewRoom;
                      if (_user.runtimeType == String) {
                        nickNameIsValid = _user.toString();
                        // print('PRINT OUT: $nickNameIsValid');
                      } else {
                        MyUser? _addingUser = _user;
                        // print(_addingUser);
                        if (_isEditing) {
                          contained = roomCubit.state.currentRoom!.members!
                              .any((element) {
                            return element.uid == _addingUser!.uid;
                          });
                          alsoContained =
                              userCubit.state.selectedUsers!.any((element) {
                            return element.uid == _addingUser!.uid;
                          });
                        } else {
                          isContainedNewRoom =
                              userCubit.state.selectedUsers!.any((element) {
                            return element.uid == _addingUser!.uid;
                          });
                        }

                        if (contained != null && contained == true ||
                            alsoContained != null && alsoContained == true ||
                            isContainedNewRoom != null &&
                                isContainedNewRoom == true) {
                          // print('THIS IS PRINT: $contained');
                          nickNameIsValid = 'This user is already selected';
                          // print('THIS IS PRINT: $nickNameIsValid');
                        } else {
                          userCubit.selectUser(_addingUser!);
                        }
                      }
                      if (_isEditing
                          ? _editFormKey.currentState!.validate()
                          : verySpecialKey.currentState!.validate()) {}
                    },
                    child: Text('Add')),
                _buildAddingMembersTiles(),
              ]),
              // _isEditing
              //     ?
              _buildCreateOrSaveButton(_isEditing, _editingTopicContent,
                  _themeEditingController, context)
            ],
          ),
        ))));
  }

  Align _buildCreateOrSaveButton(
      bool _isEditing,
      TextEditingController _editingTopicContent,
      TextEditingController _themeEditingController,
      BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: BlocBuilder<RoomCubit, RoomState>(
          bloc: roomCubit,
          builder: (context, state) {
            return ElevatedButton(
              style: ButtonStyle().copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Theme.of(context).accentColor)),
              child: Text(
                _isEditing ? "Save changes" : 'Discuss',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                // List<MyUser> selected = [];
                // selected.addAll()
                // print(_themeEditingController.text);

                if (formKey.currentState!.validate()) {
                  if (_isEditing) {
                    if (_editingTopicContent.text.isNotEmpty ||
                        _themeEditingController.text.isNotEmpty ||
                        userCubit.state.selectedUsers!.isNotEmpty)
                      roomCubit
                          .updateRoomData(
                              isPrivate: _isPrivate,
                              topicContent: _editingTopicContent.text,
                              topicTheme: _themeEditingController.text,
                              selectedUsers: userCubit.state.selectedUsers)
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
                  }
                } else {
                  print('did not validated');
                }
              },
            );
          },
        ),
      ),
    );
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

  // Form _addMember(String? nickNameIsValid, bool _isEditing) {
  //   // print(nickNameIsValid);.

  //   return Form(
  //     key: _isEditing ? _editFormKey : verySpecialKey,
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: TextFormField(
  //           // key: ,
  //           controller: _searchBy,
  //           validator: (val) {
  //             if (val?.contains('@') == false) {
  //               return 'please enter nickname starting with @';
  //             }
  //             if (nickNameIsValid.runtimeType == String) {
  //               print('final print: $nickNameIsValid');
  //               // return nickNameIsValid.toString();
  //               return '$nickNameIsValid';
  //             } else
  //               return null;
  //           },
  //           decoration: textInputDecoration.copyWith(
  //               // hintText: 'fuck'
  //               // widget.isEdit,ing!
  //               //     ? 'Add new member to this discussion'
  //               //     :
  //               // 'Add members',
  //               hintText: 'Enter nametag of a person and hit add')
  //           //  InputDecoration(
  //           //     contentPadding: EdgeInsets.only(left: 8),
  //           // hintText:
  //           //     'Enter nametag of a person and hit add'),
  //           ),
  //     ),
  //   );
  // }

  TextFormField buildTopicContent(
      bool _isEditing, TextEditingController _editingTopicContent) {
    return TextFormField(
        maxLines: 7,
        controller: _isEditing ? _editingTopicContent : _topicContent,
        validator: (val) => val!.isEmpty
            ? "Please enter dicsussion content"
            : val.length >= 10
                ? null
                : 'Please, expand your topic',
        decoration: _isEditing
            ? InputDecoration().copyWith(labelText: 'Edit content')
            : InputDecoration().copyWith(
                // isCollapsed: true,

                hintText: roomCubit.state.currentRoom?.isPrivate == true
                    ? 'Exand discussion topic. What has happened?'
                    : 'Exand discussion topic. What has happened?\n\nIf you want make this discussion private - hit lock button above',
                helperText: 'Should be at least couple of words')
        // .copyWith(
        //     labelText: 'Edit discussion content',
        //     hintText: "${roomCubit.state.currentRoom?.topicContent}")
        );
  }

  TextFormField buildTopicTheme(
      bool _isEditing, TextEditingController _themeEditingController) {
    return TextFormField(
        controller: _isEditing ? _themeEditingController : _topicTheme,
        validator: (val) => val!.isEmpty
            ? "Please enter discussion topic!"
            : val.length < 5
                ? 'Please be more specific'
                : null,
        decoration: _isEditing
            ? InputDecoration().copyWith(labelText: 'Edit theme')
            : InputDecoration().copyWith(hintText: 'Topic of discussion'));
  }
}
