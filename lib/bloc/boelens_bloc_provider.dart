//This is the BLoC provider developed by Didier Boelens (1 December 2018)
//It provides some nice utilities to make sure you call dispose()
//and some performance improvements to access the bloc

//
//For more information, see:
//https://www.didierboelens.com/2018/12/reactive-programming---streams---bloc---practical-use-cases/

import 'package:flutter/material.dart';

Type _typeOf<T>() => T;

abstract class BlocBase {
  void dispose();
}

class BoelensBlocProvider<T extends BlocBase> extends StatefulWidget {
  BoelensBlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }): super(key: key);

  final Widget child;
  final T bloc;

  @override
  _BoelensBlocProviderState<T> createState() => _BoelensBlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context){
    final type = _typeOf<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> provider = 
            context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }
}

class _BoelensBlocProviderState<T extends BlocBase> extends State<BoelensBlocProvider<T>>{
  @override
  void dispose(){
    print('[boelens_bloc_provider] about to dispose bloc');
    widget.bloc?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    return new _BlocProviderInherited<T>(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}