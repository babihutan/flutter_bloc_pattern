import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/person.dart';
import 'boelens_bloc_provider.dart';

//BlocBase is part of BoelensBlocProvider..makes sure you call dispose()
class LazyFriendsBloc implements BlocBase {

  final _personIdsSubject = BehaviorSubject<List<String>>();
  Observable<List<String>> get friendIds => _personIdsSubject.stream;

  final _personsSubject = BehaviorSubject<Map<String, Stream<Person>>>();
  Observable<Map<String, Stream<Person>>> get friends => _personsSubject.stream;
  final _personFetcher = PublishSubject<String>();
  Function(String) get fetchFriend => _personFetcher.sink.add;

  LazyFriendsBloc(String personId) {
    print('[lazy_friends_bloc] ctor, personId=$personId');
    _fetchFriendIds(personId);
    _personFetcher.stream.transform(_friendsTransformer()).pipe(_personsSubject);
  }

  dispose() async {
    //sometimes, calling dispose() will cause errors
    //so we await and drain each subject before closing
    //to prvent these exceptions
    print('[lazy_friends_bloc] dispose');
    await _personsSubject.drain();
    await _personIdsSubject.drain();
    await _personFetcher.drain();
    _personsSubject.close();
    _personFetcher.close();
    _personIdsSubject.close();
  }

  _fetchFriendIds(String personId) {
    Firestore.instance.collection('persons/$personId/friends').snapshots().listen( (QuerySnapshot qs) {
      print('[lazy_persons_bloc] fetched ${qs.documents.length} lazy friend ids');
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
    Stream<Person> stream = Firestore.instance.document("persons/$personId").snapshots().map( (DocumentSnapshot doc) {
       print('[lazy_persons_bloc] Fetched lazy friend $personId');
      return Person.fromSnapshot(doc);
    });
    return stream;
  }

}