import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Person implements Comparable<Person> {
 final String name;
 final String id;
 final int points;
 final Color avatarColor;
 final DocumentReference reference;

  int compareTo(Person p) {
    return this.name.compareTo(p.name);
  }

  Person({this.name, this.id, this.avatarColor, this.points, this.reference});

 Person.fromMap(Map<String, dynamic> map, DocumentReference reference)
     : assert(map['name'] != null),
       name = map['name'], 
       points  = map['points'] ?? 0,
       avatarColor = _getColor(map),
       reference = reference,
       id = reference.documentID;

 Person.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, snapshot.reference);

  toggleColor() {
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(this.reference);
      final fresh = Person.fromSnapshot(freshSnapshot);
      if (fresh.avatarColor == Colors.red) {
        await transaction.update(this.reference, {'isRed': false});
      } else {
        await transaction.update(this.reference, {'isRed': true});
      }
    });
  }

  changePoints(int changePointValue) {
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(this.reference);
      final fresh = Person.fromSnapshot(freshSnapshot);
      final newPointValue = fresh.points + changePointValue;
      await transaction.update(this.reference, {'votes': newPointValue});
    });
  }

 @override
 String toString() => "Person<$id:$name>";

static Color _getColor(Map<String, dynamic> map) {
  final isRed = map['isRed'];
  if( isRed == null) return Colors.red;
  return isRed ? Colors.red : Colors.blue;
}

 static List<Person> hardCodedPersons = [
    Person(id:'1',name:'Joe', avatarColor: Colors.red, points: 1),
    Person(id:'2',name:'Mike', avatarColor: Colors.blue, points: 2),
    Person(id:'3',name:'Monica', avatarColor: Colors.red, points: 3),
 ];

}