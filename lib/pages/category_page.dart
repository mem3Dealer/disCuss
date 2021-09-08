import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/pages/anotherGroupCreator.dart';
import 'package:my_chat_app/pages/home.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/shared/myScaffold.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({Key? key}) : super(key: key);
  final data = GetIt.I.get<DataBaseService>();
  final room = GetIt.I.get<RoomCubit>();

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    return MyScaffold(
      Text(
        'Select category',
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView.separated(
            itemBuilder: (BuildContext context, index) {
              var e = data.categories[index];
              return ListTile(
                leading: Icon(e['icon']),
                title: Text(e['label']),
                onTap: () {
                  room.setCategory(e['option']!); //ok
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => HomePage(),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 55),
                child: Divider(
                  height: 1,
                ),
              );
            },
            itemCount: data.categories.length),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) => AnotherGroupCreator(false)));
        },
      ),
    );
  }
}
