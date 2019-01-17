import 'package:flutter/material.dart';
import 'lazy_friends_page.dart';
import 'all_persons_page.dart';
import 'bloc/lazy_friends_bloc.dart';
import 'bloc/boelens_bloc_provider.dart';
import 'auth_service.dart' as Auth;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Fun',
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {

    Widget w;
    switch (settings.name) {
      case AllPersonsPage.navigationUrl:
        w = _allPersonsPage();
        break;
      case LazyFriendsPage.navigationUrl:
        w = _lazyFriendsPage();
        break;
      default:
        w = _allPersonsPage();
    }
    return MaterialPageRoute<void>(builder: (BuildContext context) => w);
  }

  Widget _allPersonsPage() {
    return AllPersonsPage();
  }

  Widget _lazyFriendsPage() {
    //LazyFriendsBloc requires the person id, get it from the
    //AuthService first before constructing the LazyFriendsBloc
    final myId = Auth.myPersonId;
    return BoelensBlocProvider<LazyFriendsBloc>(
      bloc: LazyFriendsBloc(myId),
      child: LazyFriendsPage(),
    );
  }
}
