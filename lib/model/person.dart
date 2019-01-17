import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Person implements Comparable<Person> {
  final String name; //persons' name, cannot be null
  final String id;   //CloudFirestore document id
  final int points;  
  final Color avatarColor;   //the avatar color can be blue or red
  final DocumentReference reference; //CloudFirestore document reference

  //for sorting the person by name
  int compareTo(Person p) {
    return this.name.compareTo(p.name);
  }

  Person({this.name, this.id, this.avatarColor, this.points, this.reference});

  Person.fromMap(Map<String, dynamic> map, DocumentReference reference)
      : assert(map['name'] != null),  //name cannot be null
        name = map['name'],
        points = map['points'] ?? 0, //if there is no points value in firesstore, set to 0
        avatarColor = _getColor(map), 
        reference = reference,
        id = reference.documentID;

  //the Person.fromSnapshot method is very helpful for constructing the
  //Person object from CloudFirestore data
  Person.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.reference);

  toggleColor() {
    print('[person] toggle color for person $name');

    //Because someone else could have changed a value since our last check,
    //use a Firestore transaction to get the latest value and then update
    //to the correct value
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(this.reference);
      final fresh = Person.fromSnapshot(freshSnapshot);
      if (fresh.avatarColor == Colors.red) {
        await transaction.update(this.reference, {'isRed': false});
        print('[person] set $name avatar color to isRed=false');
      } else {
        await transaction.update(this.reference, {'isRed': true});
        print('[person] set $name avatar color to isRed=true');
      }
    });
  }

  changePoints(int changePointValue) {
    print('[person] change the points value by $changePointValue for person $name');
    
    //Because someone else could have changed a value since our last check,
    //use a Firestore transaction to get the latest value and then update
    //to the correct value
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(this.reference);
      final fresh = Person.fromSnapshot(freshSnapshot);
      final newPointValue = fresh.points + changePointValue;
      print(
          '[person] change points of $name from ${fresh.points} to $newPointValue');
      await transaction.update(this.reference, {'points': newPointValue});
    });
  }

  @override
  String toString() => "Person<$id:$name>";

  //avatar color is stored in the CloudFirestore db as isRed = true or false
  //if the isRed flag is true or null, set to Red
  //if the isRed flag is false, use color blue
  static Color _getColor(Map<String, dynamic> map) {
    final isRed = map['isRed'];
    if (isRed == null) return Colors.red;
    return isRed ? Colors.red : Colors.blue;
  }

  //static list of person names to help us get started before implenting
  //the BLoC pattern
  static List<Person> hardCodedPersons = [
    Person(id: '1', name: 'Joe', avatarColor: Colors.red, points: 1),
    Person(id: '2', name: 'Mike', avatarColor: Colors.blue, points: 2),
    Person(id: '3', name: 'Monica', avatarColor: Colors.red, points: 3),
  ];
}
