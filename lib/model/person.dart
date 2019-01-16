import 'package:cloud_firestore/cloud_firestore.dart';

class Person implements Comparable<Person> {
 final String name;
 final String id;

  int compareTo(Person p) {
    return this.name.compareTo(p.name);
  }

  Person({this.name, this.id});

 Person.fromMap(Map<String, dynamic> map, DocumentReference reference)
     : assert(map['name'] != null),
       name = map['name'], 
       id = reference.documentID;

 Person.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, snapshot.reference);

 @override
 String toString() => "Person<$id:$name>";

 static List<Person> hardCodedPersons = [
    Person(id:'1',name:'Joe'),
    Person(id:'2',name:'Mike'),
    Person(id:'3',name:'Monica'),
 ];

}