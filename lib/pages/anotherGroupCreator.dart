import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/core/localization/generated/l10n.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/states/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/cubit/states/user_state.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/shared/myScaffold.dart';
// import 'package:my_chat_app/shared/input.dart';

final formKey = GlobalKey<FormState>();
final _editFormKey = GlobalKey<FormState>();
final verySpecialKey = GlobalKey<FormState>();

class AnotherGroupCreator extends StatefulWidget {
  bool? isEditing;
  String? category;
  AnotherGroupCreator(this.isEditing, {this.category});
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
    final trText = GetIt.I.get<I10n>();
    bool _isEditing = widget.isEditing!;
    String? nickNameIsValid;
    List<MyUser>? _selectedUsers = userCubit.state.selectedUsers;
    MyUser? authCurrentUser = authCubit.state.currentUser;
    final ThemeData theme = Theme.of(context);
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

    String? _category = widget.category;

    return MyScaffold(
      _isEditing
          ? Text(trText.grCreditingPageTitle)
          : _category == null
              ? Text(trText.grCrNewDiscussionTitle)
              : Text(trText.grCrNewDiscussionInThisCat(_category)),
      Container(
          height: double.infinity,
          decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              children: [
                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _isEditing == false
                            ? _category != null
                                ? Text(
                                    trText
                                        .grCrNewDiscussionInThisCat(_category),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300))
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 11.0),
                                        child: Text(
                                          trText.grCrSelectCat,
                                          style: theme.textTheme.caption,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      _buildSelectCategory(_category, context),
                                    ],
                                  )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 20,
                        ),
                        buildTopicTheme(
                            _isEditing, _themeEditingController, context),
                        SizedBox(
                          height: 15,
                        ),
                        BlocBuilder<RoomCubit, RoomState>(
                          bloc: roomCubit,
                          builder: (context, state) {
                            return buildTopicContent(
                                _isEditing, _editingTopicContent, context);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(),
                        Text(
                          _isEditing
                              ? trText.grCrAddNewMembers
                              : trText.grCrFutureParticipants,
                          style:
                              theme.textTheme.caption?.copyWith(fontSize: 13),
                          // textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Form(
                          key: _isEditing ? _editFormKey : verySpecialKey,
                          child: TextFormField(
                            // key: ,

                            decoration: InputDecoration().copyWith(
                                suffixIcon: IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () async {
                                      var _user = await userCubit
                                          .searchMember(_searchBy.text.trim());
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
                                          contained = roomCubit
                                              .state.currentRoom!.members!
                                              .any((element) {
                                            return element.uid ==
                                                _addingUser!.uid;
                                          });
                                          alsoContained = userCubit
                                              .state.selectedUsers!
                                              .any((element) {
                                            return element.uid ==
                                                _addingUser!.uid;
                                          });
                                        } else {
                                          isContainedNewRoom = userCubit
                                              .state.selectedUsers!
                                              .any((element) {
                                            return element.uid ==
                                                _addingUser!.uid;
                                          });
                                        }

                                        if (contained != null &&
                                                contained == true ||
                                            alsoContained != null &&
                                                alsoContained == true ||
                                            isContainedNewRoom != null &&
                                                isContainedNewRoom == true) {
                                          // print('THIS IS PRINT: $contained');
                                          nickNameIsValid =
                                              trText.grCrUserAlreadySelected;
                                          // print('THIS IS PRINT: $nickNameIsValid');
                                        } else {
                                          userCubit.selectUser(_addingUser!);
                                        }
                                      }
                                      if (_isEditing
                                          ? _editFormKey.currentState!
                                              .validate()
                                          : verySpecialKey.currentState!
                                              .validate()) {}
                                    },
                                    icon: Icon(Icons.add)),
                                hintText: trText.grCrNickNameHint),
                            controller: _searchBy,
                            validator: (val) {
                              if (val?.contains('@') == false) {
                                return trText.grCrNickNameNoAt;
                              }
                              if (nickNameIsValid.runtimeType == String) {
                                // print('final print: $nickNameIsValid');
                                // return nickNameIsValid.toString();
                                return '$nickNameIsValid';
                              } else
                                return null;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                _buildAddingMembersTiles(),
                // _isEditing
                //     ?
                _buildCreateOrSaveButton(_isEditing, _editingTopicContent,
                    _themeEditingController, context, _category)
              ],
            ),
          )),
    );

    //         )),
    //   ),
    // );
  }

  DropdownButtonFormField<String> _buildSelectCategory(
      String? category, BuildContext context) {
    final trText = GetIt.I.get<I10n>();
    return DropdownButtonFormField(
      value: category,
      items: data.categories().map<DropdownMenuItem<String>>((e) {
        return DropdownMenuItem(
          // onTap: () {},
          value: e['option']!,
          child: Text((e['label']!)),
        );
      }).toList(),
      validator: (value) =>
          value == null ? trText.grCrNoCategorySelected : null,
      onChanged: category == null
          ? (value) async {
              category = value!;
              roomCubit.setCategory(value);
              // print("I see new room cat: ${roomCubit.state.category}");
            }
          : null,
      hint: Text(trText.grCrSelectCatHintText),
    );
  }

  Align _buildCreateOrSaveButton(
      bool _isEditing,
      TextEditingController _editingTopicContent,
      TextEditingController _themeEditingController,
      BuildContext context,
      String? category) {
    final trText = GetIt.I.get<I10n>();
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
                      (states) => Theme.of(context).primaryColor)),
              child: Text(
                _isEditing ? trText.grCrSaveChanges : trText.grCrDiscussButton,
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
                            roomCubit.state.category!,
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

  TextFormField buildTopicContent(bool _isEditing,
      TextEditingController _editingTopicContent, BuildContext context) {
    final trText = GetIt.I.get<I10n>();
    return TextFormField(
        maxLines: 7,
        controller: _isEditing ? _editingTopicContent : _topicContent,
        validator: (val) => val!.isEmpty
            ? trText.grCrContNoContent
            : val.length >= 10
                ? null
                : trText.grCrContContentIsTooShort,
        decoration: _isEditing
            ? InputDecoration().copyWith(labelText: trText.grCrContEditLabel)
            : InputDecoration().copyWith(
                // isCollapsed: true,
                labelText: trText.grCrContLabelOfNewDiscussion,
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                // hintText: 'What do you want to discuss?',
                helperText: trText.grCrContNewDiscussionHelper));
  }

  TextFormField buildTopicTheme(bool _isEditing,
      TextEditingController _themeEditingController, BuildContext context) {
    final trText = GetIt.I.get<I10n>();
    return TextFormField(
        controller: _isEditing ? _themeEditingController : _topicTheme,
        validator: (val) => val!.isEmpty
            ? trText.grCrTopicIsEmpty
            : val.length < 5
                ? trText.grCrTopicIsTooShort
                : null,
        decoration: _isEditing
            ? InputDecoration().copyWith(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: trText.grCrTopicEditLabel,
                suffixIcon: BlocBuilder<RoomCubit, RoomState>(
                  bloc: roomCubit,
                  builder: (context, state) {
                    return IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          _isPrivate = roomCubit.markAsPrivate();
                        },
                        icon: state.currentRoom!.isPrivate
                            ? Icon(Icons.lock)
                            : Icon(Icons.lock_open));
                  },
                ),
              )
            : InputDecoration().copyWith(
                suffixIcon: BlocBuilder<RoomCubit, RoomState>(
                  bloc: roomCubit,
                  builder: (context, state) {
                    return IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          _isPrivate = roomCubit.markAsPrivate();
                        },
                        icon: state.currentRoom!.isPrivate
                            ? Icon(Icons.lock)
                            : Icon(Icons.lock_open));
                  },
                ),
                labelText: trText.grCrTopicNewLabel,
                helperMaxLines: 3,
                helperText: trText.grCrTopicHelperText,
                floatingLabelBehavior: FloatingLabelBehavior.always));
  }
}
