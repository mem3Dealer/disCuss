import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/pages/anotherGroupCreator.dart';
import 'package:my_chat_app/pages/home.dart';
import 'package:my_chat_app/services/database.dart';

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
            scale: 0.3,
            repeat: ImageRepeat.repeat,
            // fit: BoxFit.cover,
            image: theme.brightness == Brightness.dark
                ? ExactAssetImage('assets/dark_back.png')
                : ExactAssetImage('assets/light_back.jpg')),
      ),
      child: BackdropFilter(
        filter: theme.brightness == Brightness.dark
            ? ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0)
            : ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text('Choose category'),
            backgroundColor: Colors.transparent,
          ),
          body: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: ListView.separated(
                  padding: EdgeInsets.only(left: 15),
                  itemCount: data.categories.length,
                  itemBuilder: (BuildContext context, index) {
                    var e = data.categories[index];
                    return ListTile(
                        leading: Icon(e['icon']),
                        title: Text(
                          "${e['label']}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        onTap: () {
                          room.setCategory(e['option']!); //ok
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => HomePage(),
                            ),
                          );
                        });
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 50.0),
                      child: Divider(
                        height: 2,
                      ),
                    );
                  }),
            ),
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
      ),
    );
  }

  // Widget categoryTile() {
  // return data.categories.map((e) {
  //     return ListTile();
  //   });
  // }
}
