import 'package:flutter/material.dart';
import 'model/person.dart';
//import 'bloc/all_persons_bloc.dart';
import 'base_page.dart';
//import 'bloc/boelens_bloc_provider.dart';
import 'navigation_drawer.dart';

class AllPersonsPage extends StatelessWidget with BasePage {

  static const String navigationUrl = '/allpersons';

  @override
  Widget build(BuildContext context) {
    final fixedFriends = Person.hardCodedPersons;
    return Scaffold(
       appBar: AppBar(title: Text('All Persons')),
       drawer: NavigationDrawer(),
       body: ListView.builder(
         itemCount: fixedFriends.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildListItem(context, fixedFriends[index]);  
          },
       ),
       floatingActionButton: _floatingActionButton(context),
   );
  }

/*
  @override
  Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(title: _titleText(context)),
       drawer: NavigationDrawer(),
       body: _buildBody(context),
   );
 }

 
 
 Widget _titleText(BuildContext context) {
  final FriendsBloc bloc = BlocProvider.of<FriendsBloc>(context);
   return StreamBuilder(
    stream: bloc.friends,
    builder: (context, AsyncSnapshot<List<Person>> list) {
      if( !list.hasData) return Text('Persons');
      int friendCnt = list.data.length;
      return Text('$friendCnt Persons');
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
 */

Widget _buildListItem(BuildContext context, Person p) {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       child: ListTile(
         title: Text(p.name),
         leading: _avatar(context, p),
         trailing: Text(p.points.toString()),
         onTap: () => print(p.id),
       ),
     ),
   );
 }

 Widget _avatar(BuildContext context, Person p) {
   return GestureDetector(
     onTap: () {
       print('[all_persons_page] toggle ${p.name} avatar color');
     },
     child: CircleAvatar(backgroundColor: p.avatarColor),
   );
 }

 Widget _floatingActionButton(BuildContext context) {
   return Row(
     mainAxisAlignment: MainAxisAlignment.end,
     children: <Widget>[
     Text('Change Person Points:'),
     SizedBox(width:20.0),
     FloatingActionButton(
       onPressed: () {
         print('increment person points');
       },
       child: Text("+"),
     ),
     SizedBox(width:12.0),
     FloatingActionButton(
       onPressed: () {
         print('decrement person points');
       },
       child: Text('-'),
     )
   ],
   );
 }


}