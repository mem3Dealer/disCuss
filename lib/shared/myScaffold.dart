import 'dart:ui';

import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  Widget title;
  List<Widget>? actions;
  Widget actualBody;
  FloatingActionButton? floatingActionButton;
  MyScaffold(this.title, this.actualBody,
      {this.actions, this.floatingActionButton, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              scale: theme.brightness == Brightness.dark ? 7.5 : 0.3,
              repeat: ImageRepeat.repeat,
              // fit: BoxFit.cover,
              image: theme.brightness == Brightness.dark
                  ? ExactAssetImage('assets/images/dark_back.png')
                  : ExactAssetImage('assets/images/light_back.jpg')),
        ),
        child: BackdropFilter(
            filter: theme.brightness == Brightness.dark
                ? ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0)
                : ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar:
                    // MyAppBar(currentMemberofThisRoom, roomCubit, widget.groupID)),
                    AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: title,
                  actions: actions,
                ),
                floatingActionButton: floatingActionButton,
                body: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor),
                        child: actualBody)))));
  }
}
