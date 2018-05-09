import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../globals.dart' as globals;

const String _name = "Ajax";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final AnimationController animationController;
  final String text;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.fastOutSlowIn),
        axisAlignment: -2.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
//                child: new Text('a'),
                child: new CircleAvatar(
                    backgroundImage: // modified
                        new NetworkImage(
                            globals.googleSignIn.currentUser.photoUrl)),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(globals.googleSignIn.currentUser.displayName,
//                      new Text('Ajax',
                        style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
