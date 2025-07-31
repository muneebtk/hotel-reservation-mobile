import 'package:flutter/material.dart';

class Drawerwidget extends StatelessWidget {
  const Drawerwidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.6,
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: Text("Z"),
              ),
              accountName: Text('1929 Way'),
              accountEmail: Text("zan@gmail.com"))
        ],
      ),
    );
  }
}
