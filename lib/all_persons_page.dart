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
      appBar: AppBar(title: Text('All Persons')),
      drawer: NavigationDrawer(),
      body: _bodyStreaming(context, bloc),
      floatingActionButton: _floatingActionButton(context, bloc),
    );
  }

  Widget _bodyFixed(BuildContext context) {
    final fixedFriends = Person.hardCodedPersons;
    return ListView.builder(
      itemCount: fixedFriends.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItem(context, fixedFriends[index], bloc);
      },
    );
  }

  Widget _bodyStreaming(BuildContext context, AllPersonsBloc bloc) {
    return StreamBuilder(
      stream: bloc.allPersons,
      builder: (context, AsyncSnapshot<List<Person>> list) {
        if( !list.hasData) return LinearProgressIndicator();
        return ListView.builder(
          itemCount: list.data.length,
          itemBuilder: (BuildContext context, int index) {
          return _buildListItem(context, list.data[index], bloc);
          }
        );
      }
    );
  }

  Widget _buildListItem(BuildContext context, Person p, AllPersonsBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: ListTile(
            title: Text(p.name, style:TextStyle(fontSize:18.0)),
            leading: _avatar(context, p, bloc),
            trailing: Text(p.points.toString(), style:TextStyle(fontSize:24.0, fontWeight:FontWeight.w500)),
            onTap: () {
              print('[all_persons_page] tap ${p.name}');
              bloc.personCommandSink.add(SetCurrentPerson(person:p));
            }),
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
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.40),
      height: 80.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _changePersonPointsText(context, bloc),
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

  Widget _changePersonPointsText(BuildContext context, AllPersonsBloc bloc) {
    final style = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 21.0);
    return StreamBuilder(
      stream: bloc.selectedPerson,
      builder: (context, AsyncSnapshot<Person> p) {
        if( !p.hasData) return Text('No Person Selected', style:style);
        return Text('Change ${p.data.name} pts:', style:style);
      }
    );
  }
}
