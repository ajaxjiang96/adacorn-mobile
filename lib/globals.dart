library my_prj.globals;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

final GoogleSignIn googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

GoogleSignInAccount currentUser;


class GlobalState {
  final Map<dynamic, dynamic> _data = {};

  StreamController _streamController = new StreamController.broadcast();
  Stream get onStateChanged => _streamController.stream;

  static GlobalState instance = new GlobalState._();
  GlobalState._();

  set(key, value) {
    _data[key] = value;
    _streamController.add(_data);
  }

  get(key) {
    return _data[key];
  }
}