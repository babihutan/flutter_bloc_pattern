import 'package:flutter/material.dart';
import 'model/person.dart';
import 'bloc/all_persons_bloc.dart';
import 'base_page.dart';
import 'model/person_command.dart';
import 'navigation_drawer.dart';

class AllPersonsPage extends StatelessWidget with BasePage {
  static const String navigationUrl = '/allpersons';

  @override
  Widget build(BuildContext context) {
    final bloc = AllPersonsBloc();
    return Scaffold(
      appBar: AppBar(title: _titleText(context, bloc)),
      drawer: NavigationDrawer(),
      body: _bodyStreaming(context, bloc),
      floatingActionButton: _floatingActionButton(context, bloc),
    );
  }

/*
  Widget _bodyFixed(BuildContext context) {
    final fixedFriends = Person.hardCodedPersons;
    return ListView.builder(
      itemCount: fixedFriends.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItem(context, fixedFriends[index], null);
      },
    );
  }
  */

  Widget _bodyStreaming(BuildContext context, AllPersonsBloc bloc) {
    return StreamBuilder(
      stream: bloc.allPersons,
      builder: (context, AsyncSnapshot<List<Person>> personsSnapshot) {
        if( !personsSnapshot.hasData) return LinearProgressIndicator();
        final persons = personsSnapshot.data;
        return ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children: persons.map((Person p) => _buildListItem(context, p, bloc)).toList(),
        );
      }
    );
  }

  Widget _titleText(BuildContext context, AllPersonsBloc bloc) {
    return StreamBuilder(
      stream: bloc.allPersons,
      builder: (context, AsyncSnapshot<List<Person>> listSnapshot) {
        if( !listSnapshot.hasData) return Text('All Persons');
        return Text('${listSnapshot.data.length} Persons');
      }
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

  Widget _buildListItem(BuildContext context, Person p, AllPersonsBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: ListTile(
          title: Text(p.name),
          leading: _avatar(context, p, bloc),
          trailing: Text(p.points.toString()),
          onTap: () {
            bloc.personCommandSink.add(SetCurrentPerson(person:p));
          }
        ),
      ),
    );
  }

  Widget _avatar(BuildContext context, Person p, AllPersonsBloc bloc) {
    return GestureDetector(
      onTap: () {
        print('[all_persons_page] toggle ${p.name} avatar color');
        bloc.personCommandSink.add(TogglePersonColor());
      },
      child: CircleAvatar(backgroundColor: p.avatarColor),
    );
  }

  Widget _floatingActionButton(BuildContext context, AllPersonsBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _changePersonPointsText(context, bloc),
        SizedBox(width: 20.0),
        FloatingActionButton(
          onPressed: () {
            print('increment person points');
            bloc.personCommandSink.add(IncrementPersonPointsByOne());
          },
          child: Text("+"),
        ),
        SizedBox(width: 12.0),
        FloatingActionButton(
          onPressed: () {
            print('decrement person points');
            bloc.personCommandSink.add(DecrementPersonPointsByOne());
          },
          child: Text('-'),
        )
      ],
    );
  }

  Widget _changePersonPointsText(BuildContext context, AllPersonsBloc bloc) {
    return StreamBuilder(
      stream: bloc.selectedPerson,
      builder: (context, AsyncSnapshot<Person> selectedPersonSnap) {
        if( !selectedPersonSnap.hasData) return Text('No Person Selected!');
        return Text('Change ${selectedPersonSnap.data.name} Points:');
      }
    );
  }
}
