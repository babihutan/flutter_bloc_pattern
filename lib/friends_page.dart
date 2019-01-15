import 'package:flutter/material.dart';
import 'model/person.dart';
import 'bloc/friends_bloc.dart';
import 'base_page.dart';
import 'bloc/bloc_base.dart';

class FriendsPage extends StatelessWidget with BasePage {

  static const String navigationUrl = '/friends';

  @override
  Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(title: _titleText(context)),
       body: _buildBody(context),
   );
 }
 
 Widget _titleText(BuildContext context) {
  final FriendsBloc bloc = BlocProvider.of<FriendsBloc>(context);
   return StreamBuilder(
    stream: bloc.friends,
    builder: (context, AsyncSnapshot<List<Person>> list) {
      if( !list.hasData) return Text('Friends');
      int friendCnt = list.data.length;
      return Text('$friendCnt Friends');
    }
   );
 }

Widget _buildBody(BuildContext context) {
 final FriendsBloc bloc = BlocProvider.of<FriendsBloc>(context);
 return StreamBuilder<List<Person>>(
   stream: bloc.friends,
   builder: (context, personsSnapshot) {
     if (!personsSnapshot.hasData) return LinearProgressIndicator();
     return _buildList(context, personsSnapshot.data);
   },
 );
}

 Widget _buildList(BuildContext context, List<Person> persons) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: persons.map((Person p) => _buildListItem(context, p)).toList(),
   );
 }

Widget _buildListItem(BuildContext context, Person p) {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       child: ListTile(
         title: Text(p.name),
         onTap: () => print(p.id),
       ),
     ),
   );
 }
}