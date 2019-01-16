import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/person.dart';
import '../model/person_command.dart';
import 'dart:async';

class AllPersonsBloc {

  final _allPersonsSubject = BehaviorSubject<List<Person>>();
  Observable<List<Person>> get allPersons => _allPersonsSubject.stream;

  final _selectedPersonSubject = BehaviorSubject<Person>();
  Observable<Person> get selectedPerson => _selectedPersonSubject.stream;

  final _personCommandController = StreamController<PersonCommand>();
  Sink<PersonCommand> get personCommandSink => _personCommandController.sink;

  AllPersonsBloc() {
    print('[all_persons_bloc] ctor');
    _fetchAllPersons();
    _personCommandController.stream.listen(_handlePersonCommand);
  }

  _handlePersonCommand(PersonCommand cmd) {
    print('[all_persons_bloc] got PersonCommand');
    if( cmd is TogglePersonColor) {
      if( _selectedPersonSubject.value != null ) {
        print('[all_persons_bloc] toggle person color');
        _selectedPersonSubject.value.toggleColor();
      } else {
        print('[all_persons_bloc] no person selected');
      }
    } else if ( cmd is SetCurrentPerson ) {
      _selectedPersonSubject.sink.add(cmd.person);
      print('[all_persons_bloc] set person to ${cmd.person.name}');
    } else if ( cmd is IncrementPersonPointsByOne ) {
      if( _selectedPersonSubject.value != null ) {
        _selectedPersonSubject.value.changePoints(1);
      } else {
        print('[all_persons_bloc] cannot increment points; no one selected');
      }
    } else if ( cmd is DecrementPersonPointsByOne ) {
      if( _selectedPersonSubject.value != null ) {
        _selectedPersonSubject.value.changePoints(-1);
      } 
    }
  }

  _fetchAllPersons() {
    Firestore.instance.collection('persons').snapshots().listen( (QuerySnapshot qs) {
      print('[persons_bloc] fetched ${qs.documents.length} persons');
      List<Person> list = [];
      for(DocumentSnapshot ds in qs.documents) {
        final Person p = Person.fromSnapshot(ds);
        list.add(p);
      }
      list.sort();
      _allPersonsSubject.sink.add(list);
    });
  }

  dispose() {
    _allPersonsSubject.close();
    _selectedPersonSubject.close();
    _personCommandController.close();
  }

}


/*
import '../model/person.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'boelens_bloc_provider.dart';
import '../model/person_command.dart';

class AllPersonsBloc implements BlocBase {

  final _personsSubject = BehaviorSubject<List<Person>>();
  Observable<List<Person>> get persons => _personsSubject.stream;

  final _selectedPersonSubject = BehaviorSubject<Person>();
  Observable<Person> get selectedPerson => _selectedPersonSubject.stream;

  final _personCommandController = StreamController<PersonCommand>();
  Sink<PersonCommand> get personCommandSink => _personCommandController.sink;

  AllPersonsBloc() {
    print('[persons_bloc] ctor');
    _fetchPersons();
    _personCommandController.stream.listen(_handlePersonCommand);
  }

  dispose() {
    print('[persons_bloc] dispose');
    _personsSubject.close();
    _personCommandController.close();
    _selectedPersonSubject.close();
  }

  void _handlePersonCommand(PersonCommand cmd) {
    if( cmd is TogglePersonColor ) {
      if( _selectedPersonSubject.value != null ) {
        _selectedPersonSubject.value.toggleColor();
      }
    } else if ( cmd is IncrementPersonPointsByOne ) {
      if( _selectedPersonSubject.value != null ) {
        _selectedPersonSubject.value.changePoints(1);
      }
    } else if ( cmd is IncrementPersonPointsByOne ) {
      if( _selectedPersonSubject.value != null ) {
        _selectedPersonSubject.value.changePoints(-1);
      }
    } else if ( cmd is SetCurrentPerson) {
      _selectedPersonSubject.sink.add(cmd.person);
    } else if ( cmd is ChangePersonPoints ) {
      if( _selectedPersonSubject.value != null ) {
        _selectedPersonSubject.value.changePoints(cmd.pointChange);
      }
    }
  }

  _fetchPersons() {
     Firestore.instance.collection('persons').snapshots().listen( (QuerySnapshot qs) {
       print('[persons_bloc] fetched ${qs.documents.length} persons');
       List<Person> list = [];
       for(DocumentSnapshot ds in qs.documents) {
         list.add(Person.fromSnapshot(ds));
       }
       list.sort();
       _personsSubject.sink.add(list);
     });
  }

}

*/