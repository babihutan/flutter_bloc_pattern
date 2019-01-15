
import 'package:flutter/material.dart';
import 'lazy_friends_page.dart';
import 'friends_page.dart';
import 'bloc/friends_bloc.dart';
import 'bloc/lazy_friends_bloc.dart';
import 'bloc/bloc_base.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Friends Bloc',
     onGenerateRoute: _getRoute,
   );
 }

 Route<dynamic> _getRoute(RouteSettings settings) {
  Widget w;
  switch(settings.name) {
    case FriendsPage.navigationUrl: w = _friendsPage(); break;
    case LazyFriendsPage.navigationUrl: w = _lazyFriendsPage(); break;
    default:  w = _lazyFriendsPage();
  }
  return MaterialPageRoute<void>(builder: (BuildContext context) => w);
 }

 Widget _friendsPage() {
  return BlocProvider<FriendsBloc>(
    bloc:FriendsBloc(),
    child: FriendsPage(),
  );
 }

 Widget _lazyFriendsPage() {
  final friendId = 'ZdfoHLGunrO49ylJnTnn';
  return BlocProvider<LazyFriendsBloc>(
    bloc: LazyFriendsBloc(friendId),
    child: LazyFriendsPage(),
  );
 }

}
