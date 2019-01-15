import 'package:cloud_firestore/cloud_firestore.dart';

class Person implements Comparable<Person> {
 final String name;
 final String id;

  int compareTo(Person p) {
    return this.name.compareTo(p.name);
  }

 Person.fromMap(Map<String, dynamic> map, DocumentReference reference)
     : assert(map['name'] != null),
       name = map['name'], 
       id = reference.documentID;

 Person.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, snapshot.reference);

 @override
 String toString() => "Person<$id:$name>";

}