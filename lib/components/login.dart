import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../globals.dart';
import '../user_model.dart';
import '../components/auth.dart';
import '../components/topic.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Login';

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(appTitle),
            elevation:
            Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new LoginComponent(),
      );
  }
}

class LoginComponent extends StatefulWidget {
  @override
  createState() => new LoginState();
}

class LoginState extends State<LoginComponent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FirebaseUser user;

  Future<FirebaseUser> _handleSignIn({email: String, password: String}) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((FirebaseUser user) => this.setState(() => this.user = user))
        .catchError((e) => print(e));
//      user = await _auth.createUserWithEmailAndPassword(
//        email: email, password: password)
//        .catchError((err) => print(err));
//    print("signed in " + this.user.email);
    print(this.user);
    return user;
  }

  void loginHandler(email) {
    this._handleSignIn(email: email, password: 'office5113');
  }

  void login() {
    // Validate will return true if the form is valid, or false if
    // the form is invalid.
    if (_formKey.currentState.validate()) {
      // If the form is valid, we want to show a Snackbar
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text('Sending your credentials')));
      this._handleSignIn(email: usernameController.text, password:passwordController.text);
//          .then((u) => print(u))
////          .catchError((error) =>Scaffold.of(context).showSnackBar(
////          new SnackBar(content: new Text(error.toString()))));
//    .catchError((e) => print(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          children: [
            new TextFormField(
              controller: usernameController,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              validator: (email) {
                if (email.isEmpty) {
                  return "Required";
                }
                if (!email.endsWith("@mail.utoronto.ca")) {
                  return "Please type in a UT email address";
                }
              },
              decoration: new InputDecoration(
                hintText: 'Username',
              ),
            ),
            new TextFormField(
              obscureText: true,
              controller: passwordController,
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                hintText: 'Password',
              ),
            ),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: new ButtonBar(
                children: <Widget>[
                  FlatButton(
                    splashColor: Colors.green,
                    highlightColor: Colors.green,
                    onPressed: login,
                    child: new Text('Login'),
                  ),
                ],

              ),
            ),
          ],
        ),
      ),
    );
  }
}
