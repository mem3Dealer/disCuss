import 'package:firebase_auth/firebase_auth.dart';
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

class GroupCreator extends StatelessWidget {
//   List<MyUser>? listUsers;
//   // const GroupCreator({Key? key}) : super(key: key);
//   GroupCreator(this.listUsers);

//   @override
//   _GroupCreatorState createState() => _GroupCreatorState();
// }

// class _GroupCreatorState extends State<GroupCreator> {
  DataBaseService data = DataBaseService();
  // List<MyUser> listUsers = [];
  // String _currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();

  // List<MyUser> availableUsers = [];
  // int _currentStep = 0;
  final stepperType = StepperType.vertical;
  // bool isSelected = true;
  // List<MyUser> selectedUsers = [];
  final _groupNameController = TextEditingController();

  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();
  // Future listUsers = GetIt.I.get<UserCubit>().getUsersList();

  @override
  Widget build(BuildContext context) {
    // bool amIHere = widget.listUsers!.contains(_currentUserId);
    List<MyUser>? listUsers = userCubit.state.listUsers;
    // var selectedUsers = userCubit.state.selectedUsers;
    // List<MyUser>? selectedUsers = [];

    return Scaffold(
      appBar: AppBar(
        title: Text('create new room'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: BlocBuilder<RoomCubit, RoomState>(
              bloc: roomCubit,
              builder: (context, state) {
                // if (userCubit.state.listUsers == null) {
                //   return Text('its null, $listUsers');
                // } else
                // Container(
                //   child: Text('hello ${state.version}'),
                // );
                return Stepper(
                    type: stepperType,
                    physics: ScrollPhysics(),
                    currentStep: state.currentStep,
                    onStepTapped: (step) {
                      roomCubit.stepTapped(step);
                      print(state.currentStep);
                    },
                    onStepContinue: roomCubit.stepContinue,
                    //   onStepCancel: roomCubit.stepCancel,
                    steps: <Step>[
                      // Step(
                      //     title: Text(state.currentStep.toString()),
                      //     content: Text('text')),
                      // Step(title: Text('hello2'), content: Text('text2'))
                      Step(
                          isActive: state.currentStep == 0,
                          // state: state.currentStep == 0
                          //     ? StepState.complete
                          //     : StepState.disabled,
                          title: Text('Enter group`s name'),
                          content: TextField(
                            controller: _groupNameController,
                            decoration: InputDecoration(hintText: 'type here'),
                          )),
                      Step(
                          isActive: state.currentStep == 1,
                          title: Text(
                              'Pick members, ${roomCubit.state.currentStep}'),
                          content: SizedBox(
                              child: Column(children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: listUsers!.length,
                                // listUsers?.length,
                                itemBuilder: (context, index) {
                                  //                   // var listData = ;
                                  // bool isSelected = true;
                                  // selectedUsers!
                                  //     .contains(listUsers![index].uid);

                                  // if (listUsers[index]
                                  //     .uid!
                                  //     .contains(_currentUserId))
                                  //   return Container();
                                  // else
                                  return ListTile(
                                    onTap: () {
                                      userCubit.selectUser(listUsers[index]);
                                      // selectedUsers.add(listUsers[index]);
                                      // print(selectedUsers);
                                      // print(userCubit.state.selectedUsers);
                                    },
                                    title:
                                        Text(listUsers[index].name.toString()),
                                    subtitle:
                                        Text(listUsers[index].email.toString()),
                                  );
                                  // return SizedBox.shrink();
                                }),
                          ]))),
                      Step(
                          isActive: state.currentStep == 2,
                          title: Text('we good with this?'),
                          content: BlocBuilder<UserCubit, UserListState>(
                            bloc: userCubit,
                            builder: (context, state) {
                              List _list = [];
                              state.selectedUsers?.forEach((element) {
                                _list.add(element.name);
                              });

                              return Column(
                                children: [
                                  Text(
                                      'Group name: ${_groupNameController.text}'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  state.selectedUsers == null
                                      ? Text('')
                                      : Text(
                                          "Group members are: ${_list.toString()}")
                                ],
                              );
                            },
                          ))
                    ]);
              },
            ))
          ],
        ),
      ),
    );
  }

  // String myCurrentUser() {
  //   String myCurrentUser = '';
  //   widget.listUsers!.firstWhere((e) {

  //   });
  //   // print(widget.listUsers.contains(_currentUserId));
  //   return myCurrentUser;
  // }
  // List<String> getSelectedNames() {
  //   List<String> selectedNames = [];
  //   selectedUsers.forEach((element) {
  //     var name = data.getUserName(element.toString(), selectedUsers);
  //     selectedNames.add(name!);
  //   });
  //   return selectedNames;
  // }

  tapped(int step) {
    // setState(() => _currentStep = step);
  }

  continued() {
    // _currentStep < 1 ? setState(() => _currentStep += 1) : print("hello");
  }

  // createGroup() {
  //   String? currentUserName =
  //       data.getUserName(_currentUserId, widget.listUsers!);

  //   data.createGroup(selectedUsers, currentUserName, _groupNameController.text);

  //   // print('$currentUserName');
  //   // print("${widget.listUsers!}");
  // }

  // continued() {
  //   // String? currentUserName = data.getUserName(_currentUserId, listUsers!);
  //   setState(() {
  //     _currentStep < 1 ? _currentStep += 1 : _currentStep = 0;

  //     // if (_currentStep > 1)
  //     //   data.createGroup(
  //     //       selectedUsers, currentUserName, _groupNameController.text);

  //     Navigator.pop(context
  //         // context, MaterialPageRoute(builder: (context) => ChatPage())
  //         );
  //   });
  // }

  cancel() {
    // setState(() {
    //   _currentStep > 0 ? _currentStep -= 1 : _currentStep = 0;
    // });
  }
}
