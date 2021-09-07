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
    return Scaffold(
      body: ListView(
          children: data.categories
              .map((e) => ListTile(
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
    );
  }
}
