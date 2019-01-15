
import 'package:flutter/material.dart';
import 'lazy_friends_page.dart';
import 'friends_page.dart';
import 'bloc/friends_provider.dart';
import 'bloc/lazy_friends_provider.dart';

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
    case FriendsPage.navigationUrl: {
      w = FriendsProvider(
        child: FriendsPage(),
      );
    }
    break;
    case LazyFriendsPage.navigationUrl: {
      w = LazyFriendsProvider(
        bloc: LazyFriendsBloc('ZdfoHLGunrO49ylJnTnn'),
        child: LazyFriendsPage(),
      );
    }
    break;
    default:  {
      w = LazyFriendsProvider(
        bloc: LazyFriendsBloc('ZdfoHLGunrO49ylJnTnn'),
        child: LazyFriendsPage(),
      );
    }
  }
  return MaterialPageRoute<void>(builder: (BuildContext context) => w);
 }

}
