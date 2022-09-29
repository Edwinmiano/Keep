import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class KeepFirebaseUser {
  KeepFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

KeepFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<KeepFirebaseUser> keepFirebaseUserStream() => FirebaseAuth.instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<KeepFirebaseUser>((user) => currentUser = KeepFirebaseUser(user));
