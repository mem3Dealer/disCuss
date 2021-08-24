import 'package:flutter/material.dart';

class SliverPage extends StatefulWidget {
  @override
  _SliverPageState createState() => _SliverPageState();
}

class _SliverPageState extends State<SliverPage> {
  var top = 0.0;
  final content =
      '''Id pariatur commodo ipsum tempor dolore nulla cillum esse reprehenderit irure. Cupidatat veniam occaecat anim Lorem amet officia dolore do eu officia ea in ad. Dolore nulla qui consectetur eu fugiat nulla. Ut deserunt laborum reprehenderit elit. Et qui in Lorem magna excepteur ullamco pariatur reprehenderit occaecat. Id laboris tempor consectetur duis in.
Tempor cillum laboris enim consectetur eu irure proident nostrud do cillum consectetur elit. Esse tempor magna in officia do do ullamco ipsum incididunt exercitation ea duis elit. Tempor fugiat mollit esse est amet voluptate. Proident ea commodo deserunt ex. Qui labore ut aute cillum sint irure nulla officia adipisicing esse laborum minim irure.
Qui ad ea est cillum sunt cupidatat adipisicing. Mollit irure velit mollit aliquip nulla irure. Tempor labore et magna est ipsum culpa dolor officia consectetur aute occaecat Lorem ad aliqua. In amet adipisicing eiusmod duis ut veniam nisi velit excepteur id laborum eu tempor.
Nisi voluptate cillum tempor sunt pariatur culpa et laboris voluptate et in. Commodo Lorem ex cillum minim. Eu minim cillum occaecat laborum sint. Deserunt minim velit sit do dolor culpa veniam Lorem aliquip. Sint exercitation cupidatat eu ullamco deserunt nostrud consequat do incididunt ut ad do. Aute ad ipsum nisi elit nulla aute. Mollit duis consequat eiusmod mollit et sit sunt ut in labore cupidatat.
Reprehenderit nulla incididunt anim fugiat id nisi do enim voluptate qui. 
Proident ut incididunt cillum anim proident ex consectetur labore. Magna minim reprehenderit cillum enim nostrud exercitation Lorem consectetur sint sit officia. Laborum quis ea dolore dolore adipisicing sint ut aliquip ea duis elit aliquip. Officia minim reprehenderit mollit non consequat. Aute exercitation laboris eu irure do labore reprehenderit exercitation sit.
Ut cupidatat culpa in cupidatat pariatur irure aliquip quis aliqua nostrud eiusmod enim. Nulla eiusmod cupidatat pariatur in non Lorem in ex adipisicing tempor commodo. Ipsum et dolor sunt anim anim deserunt magna excepteur do.
Eiusmod veniam dolore culpa aliqua officia nisi excepteur laboris aliquip minim incididunt aute. Quis deserunt est ipsum elit magna. Esse ad aliquip reprehenderit pariatur occaecat excepteur ipsum ea ad dolor dolor consequat in velit. Cupidatat ad velit adipisicing anim ad id cillum non exercitation adipisicing do in excepteur. Ullamco minim cupidatat nulla occaecat nostrud ipsum enim laborum aute. Quis ut aute eu veniam. Ad minim tempor nostrud minim occaecat do adipisicing dolore enim id laborum.
      ''';
  final title =
      'Title is so big and beautiful that in can`t fit into the tabbar so what is no on';
  @override
  Widget build(BuildContext context) {
    final tbHeight = 35.0;
    final txtHeight = ((title.length / 30) * 32 + (content.length / 55) * 16);
    final halfScreen = MediaQuery.of(context).size.height / 4;
    final expHeight = txtHeight < halfScreen ? txtHeight : halfScreen;
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            child: Text('$title'),
          ),
          /*
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                toolbarHeight: tbHeight,
                expandedHeight: txtHeight,
                floating: true,
                pinned: true,
                flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  // print('constraints=' + constraints.toString());
                  top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: EdgeInsets.all(8.0),
                      title: SingleChildScrollView(
                        physics: top >= tbHeight ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(title,
                                maxLines: top <= tbHeight ? 1 : 10,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(content,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.0,
                                ))
                          ],
                        ),
                      ),
                      background: Image.network(
                        'https://a.d-cd.net/9b4abe1s-1920.jpg',
                        // "https://images.unsplash.com/photo-1542601098-3adb3baeb1ec?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=5bb9a9747954cdd6eabe54e3688a407e&auto=format&fit=crop&w=500&q=60",
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
      */
        ));
  }
}
