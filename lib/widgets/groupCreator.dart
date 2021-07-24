import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/room_state.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
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
  StepperType stepperType = StepperType.vertical;
  // bool isSelected = true;
  // List<MyUser> selectedUsers = [];
  final _groupNameController = TextEditingController();

  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();
  final roomCubit = GetIt.I.get<RoomCubit>();

  @override
  Widget build(BuildContext context) {
    // bool amIHere = widget.listUsers!.contains(_currentUserId);
    var listUsers = userCubit.state.listUsers;
    var selectedUsers = userCubit.state.selectedUsers;

    return Scaffold(
      appBar: AppBar(
        title: Text('create new room'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: BlocBuilder<RoomCubit, RoomState>(
              bloc: roomCubit,
              builder: (context, state) {
                return Stepper(
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: state.currentStep,
                  onStepTapped: (step) {
                    roomCubit.stepTapped(step);
                    print(state.currentStep);
                  },
                  onStepContinue: roomCubit.stepContinue,
                  onStepCancel: roomCubit.stepCancel,
                  steps: <Step>[
                    Step(
                        // isActive: _currentStep >= 0,
                        // state: _currentStep == 0
                        //     ? StepState.complete
                        //     : StepState.disabled,
                        title: Text('Enter group`s name'),
                        content: TextField(
                          controller: _groupNameController,
                          decoration: InputDecoration(hintText: 'type here'),
                        )),
                    Step(
                      title:
                          Text('Pick members, ${roomCubit.state.currentStep}'),
                      content: SizedBox(
                        child: Column(
                          children: [
                            // Text(widget.listUsers.toString()),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: listUsers?.length,
                                itemBuilder: (context, index) {
                                  // var listData = ;
                                  bool isSelected = true;
                                  // selectedUsers!
                                  //     .contains(listUsers![index].uid);

                                  // if (listUsers[index]
                                  //     .uid!
                                  //     .contains(_currentUserId))
                                  //   return Container();
                                  // else
                                  return ListTile(
                                    // trailing: GestureDetector(
                                    //   child: Icon(Icons.close),
                                    //   onTap: () {
                                    //     selectedUsers.removeAt(index);
                                    //     print('pressed');

                                    //     setState(() {
                                    //       print(selectedUsers);
                                    //     });
                                    //   },
                                    // ),
                                    leading: isSelected
                                        // isSelected
                                        ? Icon(Icons.select_all_rounded)
                                        : Icon(Icons.circle),
                                    title: Text(
                                      'hello',
                                      // myCurrentUser(),
                                      // listUsers![index].name.toString(),
                                      style: TextStyle(
                                          color: isSelected
                                              ? Colors.purple.shade900
                                              : Colors.black),
                                    ),
                                    subtitle: Text('hi',
                                        // listUsers[index].email.toString(),
                                        style: TextStyle(
                                            color: isSelected
                                                ? Colors.purple.shade900
                                                : Colors.black)),
                                    onTap: () {
                                      // availableUsers.add(listUsers[index]);
                                      // // availableUsers.add(_currentUserId);
                                      // selectedUsers =
                                      //     availableUsers.toSet().toList();
                                      // print(selectedUsers);
                                      // setState(() {});
                                    },
                                  );
                                  return SizedBox.shrink();
                                }),
                          ],
                        ),
                      ),
                    ),
                    // Step(
                    //     title: Text('we good with this?'),
                    //     content: Column(
                    //       children: [
                    //         Text('Group name: ${_groupNameController.text}'),
                    //         SizedBox(
                    //           height: 20,
                    //         ),
                    //         Text(getSelectedNames().toString()),
                    //       ],
                    //     ))
                  ],
                );
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
