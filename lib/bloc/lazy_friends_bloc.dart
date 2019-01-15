import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/person.dart';
import 'bloc_base.dart';

class LazyFriendsBloc implements BlocBase {

  final _personIdsSubject = BehaviorSubject<List<String>>();
  Observable<List<String>> get friendIds => _personIdsSubject.stream;

  final _personsSubject = BehaviorSubject<Map<String, Stream<Person>>>();
  Observable<Map<String, Stream<Person>>> get friends => _personsSubject.stream;
  final _personFetcher = PublishSubject<String>();
  Function(String) get fetchFriend => _personFetcher.sink.add;

  LazyFriendsBloc(String personId) {
    _fetchFriendIds(personId);
    _personFetcher.stream.transform(_friendsTransformer()).pipe(_personsSubject);
  }

  dispose() {
    _personsSubject.close();
    _personFetcher.close();
    _personIdsSubject.close();
  }

  _fetchFriendIds(String personId) {
    Firestore.instance.collection('persons/$personId/friends').snapshots().listen( (QuerySnapshot qs) {
      print('[lazy_persons_bloc] got ${qs.documents.length} lazy friends');
      _personIdsSubject.sink.add(qs.documents.map( (DocumentSnapshot ds) => ds.documentID).toList());
    });
  }

  _friendsTransformer() {
    return ScanStreamTransformer(
          (Map<String, Stream<Person>> cache, String personId, noOfTimesScanStreamTransformerInvoked) {
            print('[lazy_persons_bloc] lazy friends sst run ${noOfTimesScanStreamTransformerInvoked+1}x times');
            cache[personId] = _fetchFriendFromFirestore(personId);
            return cache;
      },
      <String, Stream<Person>>{},
    );
  }

  Stream<Person> _fetchFriendFromFirestore(String personId) {
    print('[lazy_persons_bloc] Fetch lazy friend $personId');
    Stream<Person> stream = Firestore.instance.document("persons/$personId").snapshots().map( (DocumentSnapshot doc) {
      return Person.fromSnapshot(doc);
    });
    return stream;
  }

}