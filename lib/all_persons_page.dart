import 'package:bloc_rsvp/bloc/all_persons_bloc.dart';
import 'package:bloc_rsvp/model/person_command.dart';
import 'package:flutter/material.dart';
import 'model/person.dart';
import 'base_page.dart';
import 'navigation_drawer.dart';

class AllPersonsPage extends StatelessWidget with BasePage {
  //BasePage is a Base Class with a single property (navigationUrl)
  //to make our life easier in main.dart's _getRoute method
  static const String navigationUrl = '/allpersons';

  final bloc = AllPersonsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title(context)),
      drawer: NavigationDrawer(),
      body: _streamingBody(context),
      floatingActionButton: _floatingActionButton(context),
    );
  }
 
  Widget _title(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allPersons,
      builder: (context, AsyncSnapshot<List<Person>> list) {
        if( !list.hasData) return Text('All Persons');
        return Text('${list.data.length} Persons');
      }
    );
  }

  // Widget _fixedBody(BuildContext context) {
  //   final friends = Person.hardCodedPersons;
  //   return _listView(context, friends);
  // }

  Widget _streamingBody(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allPersons,
      builder: (context, AsyncSnapshot<List<Person>> list) {
        if( !list.hasData) return LinearProgressIndicator();
        final List<Person> persons = list.data;
        return _listView(context, persons);
      }
    );
  }

  Widget _listView(BuildContext context, List<Person> friends) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItem(context, friends[index]);
      },
    );
  }

  Widget _buildListItem(
    BuildContext context,
    Person p,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: ListTile(
            title: Text(p.name, style: TextStyle(fontSize: 18.0)),
            leading: _avatar(context, p),
            trailing: Text(p.points.toString(),
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500)),
            onTap: () {
              print('[all_persons_page] tap ${p.name}');
              bloc.personCommandSink.add(SetCurrentPerson(person: p));
            }),
      ),
    );
  }

  Widget _avatar(BuildContext context, Person p) {
    return GestureDetector(
      onTap: () {
        print('[all_persons_page] toggle ${p.name} avatar color');
        bloc.personCommandSink.add(TogglePersonColor());
      },
      child: CircleAvatar(backgroundColor: p.avatarColor),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.40),
      height: 80.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _changePersonPointsText(context),
          SizedBox(width: 20.0),
          FloatingActionButton(
            onPressed: () {
              print('increment person points');
              bloc.addPersonCommand(IncrementPersonPointsByOne());
            },
            child: Icon(Icons.add),
          ),
          SizedBox(width: 12.0),
          FloatingActionButton(
            onPressed: () {
              print('decrement person points');
              bloc.personCommandSink.add(DecrementPersonPointsByOne());
            },
            child: Icon(Icons.remove),
          ),
          SizedBox(width: 10.0),
        ],
      ),
    );
  }

  Widget _changePersonPointsText(BuildContext context) {
    final style = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 21.0);
    String txt = 'No person selected:';
    return StreamBuilder(
      stream: bloc.currentPerson,
      builder: (context, AsyncSnapshot<Person> person) {
        if( !person.hasData) return Text(txt,style:style);
        return Text('Change ${person.data.name} pts:', style:style);
      }
    );
    
  }
}
