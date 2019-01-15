import 'package:flutter/material.dart';
import 'model/person.dart';
import 'bloc/lazy_friends_bloc.dart';
import 'bloc/bloc_base.dart';
import 'base_page.dart';

class LazyFriendsPage extends StatelessWidget with BasePage {
  static const String navigationUrl = '/lazyfriends';

  Widget build(BuildContext context) {
    print('build lazy friends');
    return Scaffold(
      appBar: AppBar(title: _titleText(context)),
      body: _buildBody(context),
    );
  }

  Widget _titleText(BuildContext context) {
    final bloc = BlocProvider.of<LazyFriendsBloc>(context);
    return StreamBuilder(
        stream: bloc.friendIds,
        builder: (context, AsyncSnapshot<List<String>> list) {
          if (!list.hasData) return Text('Lazy Friends');
          int friendCnt = list.data.length;
          return Text('$friendCnt Lazy Friends');
        });
  }

  Widget _buildBody(BuildContext context) {
    final bloc = BlocProvider.of<LazyFriendsBloc>(context);
    return StreamBuilder<List<String>>(
      stream: bloc.friendIds,
      builder: (context, personIdsSnapshot) {
        if (!personIdsSnapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, personIdsSnapshot.data);
      },
    );
  }

  Widget _buildList(BuildContext context, List<String> personIds) {
    final bloc = BlocProvider.of<LazyFriendsBloc>(context);
    return ListView.builder(
        itemCount: personIds.length,
        padding: const EdgeInsets.only(top: 20.0),
        itemBuilder: (context, int index) {
          String personId = personIds[index];
          bloc.fetchFriend(personId);
          return StreamBuilder(
              stream: bloc.friends,
              builder: (context,
                  AsyncSnapshot<Map<String, Stream<Person>>> personsMapSnap) {
                if (!personsMapSnap.hasData)
                  return _emptyListItem(context, 'Looking for persons map');
                final map = personsMapSnap.data;
                final Stream<Person> personStream = map[personId];
                return StreamBuilder(
                    stream: personStream,
                    builder: (context, AsyncSnapshot<Person> personSnap) {
                      if (!personSnap.hasData)
                        return _emptyListItem(
                            context, 'Looking for person $personId');
                      final Person person = personSnap.data;
                      return _personListItem(context, person);
                    });
              });
        });
  }

  Widget _emptyListItem(BuildContext context, String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: ListTile(
          title: Text(msg),
        ),
      ),
    );
  }

  Widget _personListItem(BuildContext context, Person p) {
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
