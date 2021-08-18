import 'package:flutter/material.dart';

class SliverPage extends StatefulWidget {
  @override
  _SliverPageState createState() => _SliverPageState();
}

class _SliverPageState extends State<SliverPage> {
  var top = 0.0;
  final tbHeight = 35.0;
  final content =
      '''Id pariatur commodo ipsum tempor dolore nulla cillum esse reprehenderit irure. Cupidatat veniam occaecat anim Lorem amet officia dolore do eu officia ea in ad. Dolore nulla qui consectetur eu fugiat nulla. Ut deserunt laborum reprehenderit elit. Et qui in Lorem magna excepteur ullamco pariatur reprehenderit occaecat. Id laboris tempor consectetur duis in.
Reprehenderit nulla incididunt anim fugiat id nisi do enim voluptate qui. 
      ''';
  final title = 'Title is so big and beautiful that in can`t fit into the tabbar so what is no on';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                toolbarHeight: tbHeight,
                expandedHeight: ((title.length / 30) * 36 + (content.length / 60) * 20),
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  // print('constraints=' + constraints.toString());
                  top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: EdgeInsets.all(8.0),
                      title: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(title,
                                maxLines: top <= tbHeight ? 1 : 10,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                )),
                            Text(content,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                ))
                          ],
                        ),
                      ),
                      background: Image.network(
                        "https://images.unsplash.com/photo-1542601098-3adb3baeb1ec?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=5bb9a9747954cdd6eabe54e3688a407e&auto=format&fit=crop&w=500&q=60",
                        fit: BoxFit.cover,
                      ));
                })),
          ];
        },
        body: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1542601098-3adb3baeb1ec?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=5bb9a9747954cdd6eabe54e3688a407e&auto=format&fit=crop&w=500&q=60",
                ),
              ),
              title: Text('My data $index'),
            );
          },
        ),
      ),
    ));
  }
}
