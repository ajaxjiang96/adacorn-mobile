import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:transparent_image/transparent_image.dart';


final baseTextStyle = const TextStyle(
    fontFamily: 'Poppins'
);

final headerTextStyle = baseTextStyle.copyWith(
    color: Colors.black87,
    fontSize: 18.0,
    fontWeight: FontWeight.w600
);

final regularTextStyle = baseTextStyle.copyWith(
    color: Colors.black38,
    fontSize: 9.0,
    fontWeight: FontWeight.w400
);

final subHeaderTextStyle = regularTextStyle.copyWith(
    fontSize: 12.0
);

class Feed {
  final String topic;
  final String source;
  final String coverImg;
  final String excerpt;

  Feed(this.topic, this.source, this.coverImg, this.excerpt);
}

class FeedItem extends StatelessWidget {
  final Feed feed;

  FeedItem({@required this.feed});

  Widget card() {
    return new Container(
//      height: 150.0,
      margin: const EdgeInsets.only(left: 46.0, right: 0.0, top: 0.0, bottom: 0.0),
      decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0))
          ]),
      child: cardContent(),
    );
  }

  Widget coverImage() {
    return new Container(
      width: 92.0,
      height: 92.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: new BoxDecoration(
          color: Colors.deepPurple,
//        borderRadius: new BorderRadius.circular(46.0),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            new BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(0.0, 10.0))
          ],
//          border: new Border.all(color: Colors.white, width: 2.0, style: BorderStyle.solid),
          image: new DecorationImage(
              fit: BoxFit.cover, image: new NetworkImage(feed.coverImg))),
    );
  }

  Widget cardContent() {
    return new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
//      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(feed.topic,
            style: headerTextStyle,
          ),
          new Container(height: 10.0),
          new Text(feed.excerpt.substring(0, 100) + "...",
              style: subHeaderTextStyle

          ),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 18.0,
              color: new Color(0xff00c6ff)
          ),
          new Container(
            height: 20.0,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: _cardValue(value: "20", icon: Icons.people),
                ),
//              new Text(planet.gravity,
//                style: regularTextStyle,
//              ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardValue({String value, IconData icon}) {
    return new Row(
        children: <Widget>[
          new Icon(icon, size: 12.0, color: Colors.black38),
          new Container(width: 8.0),
          new Text(value,
            style: regularTextStyle,
          ),
        ]
    );
  }

    @override
    Widget build(BuildContext context) {
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: new Stack(
          children: <Widget>[
            card(),
            coverImage(),
          ],
        ),
      );
    }
  }

