import 'package:flutter/material.dart';
import 'dart:io';
import 'all_persons_page.dart';
import 'lazy_friends_page.dart';
import 'auth_service.dart' as Auth;

class DrawerItem {
  String title;
  IconData icon;
  String navigationUrl;
  List<DrawerItem> children;
  DrawerItem(this.title, this.icon, this.navigationUrl, this.children);
}

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer();

  @override
  State<StatefulWidget> createState() {
    return NavigationDrawerState();
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {
  List<DrawerItem> drawerItems;

  static final divider = DrawerItem("", Icons.event, null, null);

  final regularDrawerItems = [

    DrawerItem("Friends", Icons.people_outline, AllPersonsPage.navigationUrl, null),
    DrawerItem("Lazy Friends", Icons.people, LazyFriendsPage.navigationUrl, null),

    DrawerItem("Utilities", Icons.build, null, [
      DrawerItem("Kill App", Icons.cancel, '/killapp', null),
    ]),
    
  ];

  _onSelectItem(DrawerItem selectedItem, BuildContext context) {
    if (selectedItem.navigationUrl  == '/killapp') {
      exit(0);
      return;
    } else if (selectedItem.navigationUrl.isNotEmpty) {
      Navigator.pushReplacementNamed(context, selectedItem.navigationUrl);
      return;
    }
  }

  Widget _buildTile(DrawerItem item) {
    if (item.title.isEmpty) return Divider(indent: 5.0);
    if (item.children == null) return _buildListTile(item);
    return ExpansionTile(
      key: PageStorageKey<DrawerItem>(item),
      title: Text(
        item.title,
        style: TextStyle(fontSize: 18.0),
      ),
      children: item.children.map(_buildTile).toList(),
    );
  }

  Widget _buildListTile(DrawerItem item) {
    return ListTile(
      leading: Icon(item.icon),
      dense: true,
      title: Row(children: <Widget>[
        Text(
          item.title,
          style: TextStyle(fontSize: 18.0),
        ),
      ]),
      onTap: () => _onSelectItem(item, context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    drawerItems = regularDrawerItems;
    var drawerOptions = List<Widget>();
    for (var i = 0; i < drawerItems.length; i++) {
      drawerOptions.add(_buildTile(drawerItems[i]));
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _userAccountsDrawerHeader(context, Auth.myName, Auth.myEmail),
            Column(children: drawerOptions)
          ],
        ),
      ),
    );
  }

  Widget _userAccountsDrawerHeader(BuildContext context, String name, String email) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        name,
        style: TextStyle(fontSize: 24.0),
      ),
      accountEmail: Text(
        email,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDrawer(context);
  }
}
