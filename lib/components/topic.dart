import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';                      //new
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

import '../globals.dart' as globals;
import 'elements/message.dart';

class Topic extends StatefulWidget {
  Topic();

  @override
  createState() => new TopicState();
}

class TopicState extends State<Topic> with TickerProviderStateMixin {
  String title = 'private int numWorkers';
  int userCount = 5;
  bool _isComposing = false;
  final List<ChatMessage> _messages = <ChatMessage>[];

  final TextEditingController _textController = new TextEditingController();

  TopicState();

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user =  globals.googleSignIn.currentUser;
    if (user == null)
      user = await globals.googleSignIn.signInSilently();
    if (user == null) {
      try {
        await globals.googleSignIn.signIn();
      } catch (error) {
        print(error);
      }    }
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String text) =>
                      setState(() => _isComposing = text.length > 0),
                  onSubmitted: _handleSubmitted,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS ?  //modified
                  new CupertinoButton(                                       //new
                    child: new Text("Send"),                                 //new
                    onPressed: _isComposing                                  //new
                        ? () =>  _handleSubmitted(_textController.text)      //new
                        : null,) :                                           //new
                  new IconButton(                                            //modified
                    icon: new Icon(Icons.send),
                    onPressed: _isComposing ?
                        () =>  _handleSubmitted(_textController.text) : null,
                  ))
            ])));
  }

//  void _handleSubmitted(String text) {
//    _textController.clear();
//    ChatMessage message = new ChatMessage(
//      text: text,
//      animationController: new AnimationController(
//          vsync: this, duration: new Duration(milliseconds: 400)),
//    );
//    setState(() {
//      _messages.insert(0, message);
//      _isComposing = false;
//    });
//    message.animationController.forward();
//  }

  Future<Null> _handleSubmitted(String text) async {         //modified
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    await _ensureLoggedIn();                                       //new
    _sendMessage(text: text);                                      //new
  }

  void _sendMessage({ String text }) {
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 400),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose() {
    //new
    for (ChatMessage message in _messages) //new
      message.animationController.dispose(); //new
    super.dispose(); //new
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
            title: new Text(title + '($userCount)'),
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                  child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              )),
              new Divider(height: 1.0),
              new Container(
                decoration: new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              )
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS //new
              ? new BoxDecoration(                                     //new
            border: new Border(                                  //new
              top: new BorderSide(color: Colors.grey[200]),      //new
            ),                                                   //new
          )                                                      //new
              : null),
        );
  }
}
