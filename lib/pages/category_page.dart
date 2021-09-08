import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/pages/anotherGroupCreator.dart';
import 'package:my_chat_app/pages/home.dart';
import 'package:my_chat_app/services/database.dart';
import 'dart:ui';

class CategoryPage extends StatelessWidget {
  /// ее вызывать на главнойто есть вместо всех чатов на хоуме будет выбор категории? да понял
  CategoryPage({Key? key}) : super(key: key);
  final data = GetIt.I.get<DataBaseService>();
  final room = GetIt.I.get<RoomCubit>();

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
                  ? ExactAssetImage('assets/dark_back.png')
                  : ExactAssetImage('assets/light_back.jpg')),
        ),
        child: BackdropFilter(
          filter: theme.brightness == Brightness.dark
              ? ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0)
              : ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Select categore'),
            ),
            body: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView(
                  children: data.categories
                      .map((e) => ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.menu,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(e['label']!),
                          onTap: () {
                            room.setCategory(e['option']!); //ok
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => HomePage(),
                              ),
                            );
                          }))
                      .toList()),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                // print(room.state);
                Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            // SliverPage()
                            AnotherGroupCreator(false)
                        // BackDropPage()
                        )
                    // )
                    );
              },
            ),
          ),
        ));
  }

  // Widget categoryTile() {
  // return data.categories.map((e) {
  //     return ListTile();
  //   });
  // }
}
