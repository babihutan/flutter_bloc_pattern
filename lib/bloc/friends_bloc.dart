
import '../model/person.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bloc_base.dart';

class FriendsBloc implements BlocBase {

  final _personsSubject = BehaviorSubject<List<Person>>();
  Observable<List<Person>> get friends => _personsSubject.stream;

  FriendsBloc() {
    print('friends bloc ctor');
    _fetchPersons();
  }

  dispose() {
    _personsSubject.close();
  }

  _fetchPersons() {
     Firestore.instance.collection('persons').snapshots().listen( (QuerySnapshot qs) {
       List<Person> list = [];
       for(DocumentSnapshot ds in qs.documents) {
         list.add(Person.fromSnapshot(ds));
       }
       list.sort();
       _personsSubject.sink.add(list);
     });
  }

}