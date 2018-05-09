import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import './globals.dart';
import './user_model.dart';
import './components/auth.dart';
import './components/topic.dart';
import './components/login.dart';
import 'components/feed.item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';

class AppState extends InheritedWidget {
  final int counter;

  AppState({Key key, @required this.counter, @required Widget child})
      : super(key: key, child: child);

  static AppState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppState);
  }

  @override
  bool updateShouldNotify(AppState old) => counter != old.counter;
}

class Home extends StatefulWidget {
  @override
  createState() => new HomeState();
}

class HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  final usernameController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    usernameController.dispose();
    super.dispose();
  }

  Widget getAuthStatus(context, condition) {
    if (condition) {
      User user = new User(name: "redditor");
      AuthState.instance.setUser(user);
    } else {
      AuthState.instance.setUser(null);
    }
    var style = Theme.of(context).textTheme.title;
    User user = AuthState.currentUser;
    return user == null
        ? new Text("User is not logged", style: style)
        : new Text("User is logged [$user]", style: style);
  }

  Future<FirebaseUser> _handleSignIn({email: String, password: String}) async {
    var u = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) =>
//      user = await _auth.createUserWithEmailAndPassword(
//        email: email, password: password)
//        .catchError((err) => print(err));
            print(error));
    this.setState(() => this.user = u);
    print("signed in " + user.email);
    return user;
  }

  bool validEmail({email: String}) {
    return (new RegExp("@mail.utoronto.ca", caseSensitive: false))
        .hasMatch(email);
  }

  void submitHandler(username) {
    this._handleSignIn(email: username, password: 'office5113');
  }

  @override
  Widget build(BuildContext context) {
//    AppState appState = AppState.of(context);
    // TODO: implement build
    return new Scaffold(
//        appBar: Theme.of(context).platform == TargetPlatform.iOS
//            ? new CupertinoNavigationBar(
////                automaticallyImplyLeading: true,
////                leading: new Text("Huh"),
////                trailing:new Text("Hah"),
//                middle:
//                    new Image(
//                      image: new AssetImage("assets/logo.png"),
//                      width: 24.0,
//                    ),
////                    new Text("  ADACORN")
//
//              )
//            : new AppBar(
//                title: new Row(
//                  children: <Widget>[
//                    new Image(
//                      image: new AssetImage("assets/logo.png"),
//                      width: 24.0,
//                    ),
////                    new Text("  ADACORN")
//                  ],
//                ),
//                elevation: Theme.of(context).platform == TargetPlatform.iOS
//                    ? 0.0
//                    : 4.0,
//              ),
////        appBar:
        body: new StreamBuilder(
            stream: Firestore.instance.collection('topics').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              return new ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents.length + 1,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return new Row(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 36.0, 16.0, 16.0),
                              child: new Image(
                                image: new AssetImage("assets/logo.png"),
//                          width: 36.0,
                                height: 36.0,

                              ),
                            ),
                          ],
                        );
//                      case 0:
//                        return new CarouselSlider(
//                            viewportFraction: 1.0,
//                            items: snapshot.data.documents.map<Widget>((doc) {
//                              return new Builder(
//                                builder: (BuildContext context) {
//                                  return new Container(
//                                      width: MediaQuery.of(context).size.width,
////                                      margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
//                                      decoration: new BoxDecoration(
////                                          color: Colors.amber
////                                      boxShadow: [
////                                        new BoxShadow(
////                                            blurRadius: 10.0, color: Colors.black26)                                      ]
//                                          ),
//                                      child: new FadeInImage.memoryNetwork(
//                                        placeholder: kTransparentImage,
//                                        fit: BoxFit.cover,
//                                        image: "${doc['coverImg']}",
//                                      ));
//                                },
//                              );
//                            }).toList(),
//                            height: 200.0,
//                            autoPlay: true);
                      default:
                        DocumentSnapshot ds =
                            snapshot.data.documents[index - 1];
                        final Feed feed = new Feed("${ds['topic']}",
                            "${ds['source']}", "${ds['coverImg']}", "${ds['excerpt']}");
                        return new FeedItem(feed: feed);
                    }
                  });
            }));
  }
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.grey[100],
  accentColor: Colors.grey,
);

void main() {
  runApp(new MaterialApp(
    title: 'My app', // used by the OS task switcher
//    home: new DefaultTabController(
//      length: 3,
//      child: new Scaffold(
//        appBar: new AppBar(
//          bottom: new TabBar(
//            tabs: [
//              new Tab(icon: new Icon(Icons.directions_car)),
//              new Tab(icon: new Icon(Icons.directions_transit)),
//              new Tab(icon: new Icon(Icons.directions_bike)),
//            ],
//          ),
//          title: new Text('Tabs Demo'),
//        ),
//        body: new TabBarView(
//          children: [
//            new Home(),
//            new Icon(Icons.directions_transit),
//            new Icon(Icons.directions_bike),
//          ],
//        ),
//      ),
//    ),
  home: new Home(),
    theme: defaultTargetPlatform == TargetPlatform.iOS //new
        ? kIOSTheme //new
        : kDefaultTheme,
  ));
}
