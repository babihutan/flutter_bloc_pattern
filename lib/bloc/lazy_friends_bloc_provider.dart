//This is a simplier alternative to the Boelens Bloc Provider.
//However, this can be used only with the LazyFriendsBloc
//and you must remember to call dispose() or you will be sheared.

import 'package:flutter/material.dart';
import 'lazy_friends_bloc.dart';
export 'lazy_friends_bloc.dart';

class LazyFriendsProvider extends InheritedWidget {
  final LazyFriendsBloc bloc;

  LazyFriendsProvider({Key key, LazyFriendsBloc bloc, Widget child}) : bloc=bloc, super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static LazyFriendsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LazyFriendsProvider) as LazyFriendsProvider).bloc;
  }

}