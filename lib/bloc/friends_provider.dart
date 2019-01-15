import 'package:flutter/material.dart';
import 'friends_bloc.dart';
export 'friends_bloc.dart';

class FriendsProvider extends InheritedWidget {
  final bloc = FriendsBloc();

  FriendsProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static FriendsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(FriendsProvider) as FriendsProvider).bloc;
  }

}