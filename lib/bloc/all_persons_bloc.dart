import 'package:rxdart/rxdart.dart';
import '../model/person.dart';
import '../model/person_command.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllPersonsBloc {

 //a Behavior Subject allows a subcriber to get the latest value
 //when they subscribe; it is also a broadcccast stream
 final _allPersonsSubject = BehaviorSubject<List<Person>>();
 Observable<List<Person>> get allPersons => _allPersonsSubject.stream;

 //the selected person subject keeps track of who is the currently selected person
 final _selectedPersonSubject = BehaviorSubject<Person>();
 Observable<Person> get selectedPerson => _selectedPersonSubject.stream;

 //this is how we will communicate state changes to the bloc
 //[1a] state change commands (PersonCommand) are posted to this sink
 Sink<PersonCommand> get personCommandSink => _personCommandController.sink;
 //[2] state change commands (PersonCommand) are then streamed through this controller
 final _personCommandController = StreamController<PersonCommand>();
 //[1b] technically, this is not a sink as stipulated by the BLoC 'rules', 
 // but some prefer it to exposing a sink
 // both [1a] and [1b] work, just a style choice
 Function(PersonCommand) get addPersonCommand => _personCommandController.sink.add;

 AllPersonsBloc() {
   print('[all_persons_bloc] ctor');
   _fetchAllPersons();
   //[3a] listen to commands coming from the controller
   _personCommandController.stream.listen(_handle);

   //[3b-alternative]
   _personCommandController.stream.listen( (PersonCommand cmd) {
     //we just got a person command
     //we're not going to  handle it here because we are doing so below
   });
 }

 //we should dispose of resources so that we don't have memory leaks
 //but we should be sure that we actually get the dispose() method
 //alled at some point
 dispose() {
   print('[all_persons_bloc] dispose');
   _allPersonsSubject.close();
   _selectedPersonSubject.close();
   _personCommandController.close();
 }

 //process the person command
 _handle(PersonCommand cmd) {
   print('[all_persons_bloc] got person command');
   if( cmd is SetCurrentPerson) {
     _selectedPersonSubject.sink.add(cmd.person);
   }

   //all of the commands below require that a person be
   //selected beforehand
   if( _selectedPersonSubject.value == null) {
     print('[all_persons_bloc] no person selected, nothing to do');
     return;
   }

   final Person person = _selectedPersonSubject.value;

   if( cmd is IncrementPersonPointsByOne) {
     //runs a transaction to increment points by 1
     person.changePoints(1);

   } else if ( cmd is DecrementPersonPointsByOne) {
     //runs a transaction to decrement points by 1
     person.changePoints(-1);

   } else if (cmd is ChangePersonPoints) {
     //runs a transaction to change the points by some specified value
     //however, the UI at this point does not implement this functionality
     //so this is not really possible at this point
     person.changePoints(cmd.pointChange);

   } else if ( cmd is TogglePersonColor) {
     //runs a transaction to toggle the person's avatar color
     person.toggleColor();

   } else {
     print('[all_persons_bloc] unhandled PersonCommand');
   }

 }

 _fetchAllPersons() {
   print('[all_persons_bloc] fetch all persons');
   Firestore.instance.collection('persons').snapshots().listen( (QuerySnapshot qs) {
     List<Person> list = [];
     for(DocumentSnapshot ds in qs.documents) {
       final Person p = Person.fromSnapshot(ds);
       list.add(p);
     }
     print('[all_persons_page] fetched ${qs.documents.length} persons');
     list.sort();
     _allPersonsSubject.sink.add(list);
   });
 }

}





/*
import 'package:rxdart/rxdart.dart';
import '../model/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllPersonsBloc {

  //a Behavior Subject allows a subcriber to get the latest value
  //when they subscribe; it is also a broadcccast stream
  final _allPersonsSubject = BehaviorSubject<List<Person>>();
  Observable<List<Person>> get allPersons => _allPersonsSubject.stream;

  //the selected person subject keeps track of who is the currently selected person
  final _selectedPersonSubject = BehaviorSubject<Person>();
  Observable<Person> get selectedPerson => _selectedPersonSubject.stream;

   AllPersonsBloc() {
    print('[all_persons_bloc] ctor');
    _fetchAllPersons();
  }

  //we should dispose of resources so that we don't have memory leaks
  //but we should be sure that we actually get the dispose() method
  //alled at some point
  dispose() {
    print('[all_persons_bloc] dispose');
    _allPersonsSubject.close();
    _selectedPersonSubject.close();
  }

  _fetchAllPersons() {
    print('[all_persons_bloc] fetch all persons');
    Firestore.instance.collection('persons').snapshots().listen( (QuerySnapshot qs) {
      List<Person> list = [];
      for(DocumentSnapshot ds in qs.documents) {
        final Person p = Person.fromSnapshot(ds);
        list.add(p);
      }
      print('[all_persons_page] fetched ${qs.documents.length} persons');
      list.sort();
      _allPersonsSubject.sink.add(list);
    });
  }

}
*/



/*
import 'package:rxdart/rxdart.dart';
import '../model/person.dart';
import '../model/person_command.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllPersonsBloc {

  //a Behavior Subject allows a subcriber to get the latest value
  //when they subscribe; it is also a broadcccast stream
  final _allPersonsSubject = BehaviorSubject<List<Person>>();
  Observable<List<Person>> get allPersons => _allPersonsSubject.stream;

  //the selected person subject keeps track of who is the currently selected person
  final _selectedPersonSubject = BehaviorSubject<Person>();
  Observable<Person> get selectedPerson => _selectedPersonSubject.stream;

  //this is how we will communicate state changes to the bloc
  //[1] state change commands (PersonCommand) are posted to this sink
  Sink<PersonCommand> get personCommandSink => _personCommandController.sink;
  //[2] state change commands (PersonCommand) are then streamed through this controller
  final _personCommandController = StreamController<PersonCommand>();

  AllPersonsBloc() {
    print('[all_persons_bloc] ctor');
    _fetchAllPersons();
    //[3a] listen to commands coming from the controller
    _personCommandController.stream.listen(_handlePersonCommand);

    //[3b-alternative] 
    _personCommandController.stream.listen( (PersonCommand cmd) {
      //we just got a person command
      //we're not going to  handle it here because we are doing so below
    });
  }

  //we should dispose of resources so that we don't have memory leaks
  //but we should be sure that we actually get the dispose() method
  //alled at some point
  dispose() {
    print('[all_persons_bloc] dispose');
    _allPersonsSubject.close();
    _selectedPersonSubject.close();
    _personCommandController.close();
  }

  //process the person command
  _handlePersonCommand(PersonCommand cmd) {
    print('[all_persons_bloc] got person command');
    if( cmd is SetCurrentPerson) {
      _selectedPersonSubject.sink.add(cmd.person);
    }

    //all of the commands below require that a person be
    //selected beforehand 
    if( _selectedPersonSubject.value == null) {
      print('[all_persons_bloc] no person selected, nothing to do');
      return;
    }

    final Person person = _selectedPersonSubject.value;

    if( cmd is IncrementPersonPointsByOne) {
      //runs a transaction to increment points by 1
      person.changePoints(1);

    } else if ( cmd is DecrementPersonPointsByOne) {
      //runs a transaction to decrement points by 1
      person.changePoints(-1);

    } else if (cmd is ChangePersonPoints) {
      //runs a transaction to change the points by some specified value
      //however, the UI at this point does not implement this functionality
      //so this is not really possible at this point
      person.changePoints(cmd.pointChange);

    } else if ( cmd is TogglePersonColor) {
      //runs a transaction to toggle the person's avatar color
      person.toggleColor();

    } else {
      print('[all_persons_bloc] unhandled PersonCommand');
    }

  }

  _fetchAllPersons() {
    print('[all_persons_bloc] fetch all persons');
    Firestore.instance.collection('persons').snapshots().listen( (QuerySnapshot qs) {
      List<Person> list = [];
      for(DocumentSnapshot ds in qs.documents) {
        final Person p = Person.fromSnapshot(ds);
        list.add(p);
      }
      print('[all_persons_page] fetched ${qs.documents.length} persons');
      list.sort();
      _allPersonsSubject.sink.add(list);
    });
  }

}
*/