import 'package:flutter/material.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/styles/fonts.dart';
import 'dart:io';

class ConfirmEventPage extends StatefulWidget {

  final EventPost newEvent;
  final File newEventImage;
  ConfirmEventPage({this.newEvent, this.newEventImage});

  @override
  _ConfirmEventPageState createState() => _ConfirmEventPageState();
}

class _ConfirmEventPageState extends State<ConfirmEventPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 600.0,
            backgroundColor: FlatColors.exodusPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black38
                ),
                child: Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                  child: Fonts().textW500(widget.newEvent.title, 16.0, Colors.white, TextAlign.left),
                ),
              ),
              background: SizedBox.expand(
                child: Image.file(widget.newEventImage, fit: BoxFit.cover)
              ),
            ),
            elevation: 2.0,
            forceElevated: true,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
                <Widget>[
                  /// Rating average
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text('No Current Ratings', style: TextStyle(color: FlatColors.londonSquare, fontWeight: FontWeight.w600, fontSize: 30.0)
                      ),
                    ),
                  ),
                  /// Rating stars
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.black12, size: 48.0),
                        Icon(Icons.star, color: Colors.black12, size: 48.0),
                        Icon(Icons.star, color: Colors.black12, size: 48.0),
                        Icon(Icons.star, color: Colors.black12, size: 48.0),
                        Icon(Icons.star, color: Colors.black12, size: 48.0),
                      ],
                    ),
                  ),
                  /// Rating chart lines
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        /// 5 stars and progress bar
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded(
                                child: Theme(
                                  data: ThemeData(accentColor: Colors.green),
                                  child: LinearProgressIndicator(
                                    value: 0.0,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black12, size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded(
                                child: Theme(
                                  data: ThemeData(accentColor: Colors.lightGreen),
                                  child: LinearProgressIndicator(
                                    value: 0.0,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black12, size: 16.0),
                                  Icon(Icons.star, color: Colors.black12, size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded(
                                child: Theme(
                                  data: ThemeData(accentColor: Colors.yellow),
                                  child: LinearProgressIndicator(
                                    value: 0.0,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black12, size: 16.0),
                                  Icon(Icons.star, color: Colors.black12, size: 16.0),
                                  Icon(Icons.star, color: Colors.black12, size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded(
                                child: Theme(
                                  data: ThemeData(accentColor: Colors.orange),
                                  child: LinearProgressIndicator(
                                    value: 0.0,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.star, color: Colors.black54, size: 16.0),
                                  Icon(Icons.star, color: Colors.black12, size: 16.0),
                                  Icon(Icons.star, color: Colors.black12, size: 16.0),
                                  Icon(Icons.star, color: Colors.black12, size: 16.0),
                                  Icon(Icons.star, color: Colors.black12, size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: Colors.red),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.0,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
//                  Divider(),
//                  /// Review
//                  Padding(
//                    padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
//                    child: Material(
//                      elevation: 12.0,
//                      color: Colors.white,
//                      borderRadius: BorderRadius.only(
//                        topRight: Radius.circular(20.0),
//                        bottomLeft: Radius.circular(20.0),
//                        bottomRight: Radius.circular(20.0),
//                      ),
//                      child: Container(
//                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
//                        child: Container(
//                          child: ListTile(
////                            leading: CircleAvatar(
////                              backgroundColor: Colors.purple,
////                              child: Text('AI'),
////                            ),
//                            title: Text('Ivascu Adrian ★★★★★', style: TextStyle()),
//                            subtitle: Text('The shoes were shipped one day before the shipping date, but this wasn\'t at all a problem :). The shoes are very comfortable and good looking.', style: TextStyle()),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                  /// Review reply
//                  Padding(
//                    padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
//                    child: Row(
//                      mainAxisSize: MainAxisSize.min,
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: <Widget>[
//                        Material(
//                          elevation: 12.0,
//                          color: Colors.tealAccent,
//                          borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(20.0),
//                            bottomLeft: Radius.circular(20.0),
//                            bottomRight: Radius.circular(20.0),
//                          ),
//                          child: Container
//                            (
//                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
//                            child: Text('Happy to hear that!', style: Theme.of(context).textTheme.subhead),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                  Divider(),
//                  /// Review
//                  Padding
//                    (
//                    padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
//                    child: Material
//                      (
//                      elevation: 12.0,
//                      color: Colors.white,
//                      borderRadius: BorderRadius.only
//                        (
//                        topRight: Radius.circular(20.0),
//                        bottomLeft: Radius.circular(20.0),
//                        bottomRight: Radius.circular(20.0),
//                      ),
//                      child: Container
//                        (
//                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
//                        child: Column
//                          (
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>
//                          [
//                            Container
//                              (
//                              child: ListTile
//                                (
//                                leading: CircleAvatar
//                                  (
//                                  backgroundColor: Colors.purple,
//                                  child: Text('AI'),
//                                ),
//                                title: Text('Ivascu Adrian ★★★★★', style: TextStyle()),
//                                subtitle: Text('The shoes were shipped one day before the shipping date, but this wasn\'t at all a problem :). The shoes are very comfortable and good looking', style: TextStyle()),
//                              ),
//                            ),
//                            Padding
//                              (
//                              padding: EdgeInsets.only(top: 4.0, right: 10.0),
//                              child: FlatButton.icon
//                                (
//                                  onPressed: () {},
//                                  icon: Icon(Icons.reply, color: Colors.blueAccent),
//                                  label: Text('Reply', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w700, fontSize: 16.0))
//                              ),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                  Divider(),
//                  /// Review
//                  Padding
//                    (
//                    padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
//                    child: Material
//                      (
//                      elevation: 12.0,
//                      color: Colors.white,
//                      borderRadius: BorderRadius.only
//                        (
//                        topRight: Radius.circular(20.0),
//                        bottomLeft: Radius.circular(20.0),
//                        bottomRight: Radius.circular(20.0),
//                      ),
//                      child: Container
//                        (
//                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
//                        child: Column
//                          (
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>
//                          [
//                            Container
//                              (
//                              child: ListTile
//                                (
//                                leading: CircleAvatar
//                                  (
//                                  backgroundColor: Colors.purple,
//                                  child: Text('AI'),
//                                ),
//                                title: Text('Ivascu Adrian ★★★★★', style: TextStyle()),
//                                subtitle: Text('The shoes were shipped one day before the shipping date, but this wasn\'t at all a problem :). The shoes are very comfortable and good looking', style: TextStyle()),
//                              ),
//                            ),
//                            Padding
//                              (
//                              padding: EdgeInsets.only(top: 4.0, right: 10.0),
//                              child: FlatButton.icon
//                                (
//                                  onPressed: () {},
//                                  icon: Icon(Icons.reply, color: Colors.blueAccent),
//                                  label: Text('Reply', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w700, fontSize: 16.0))
//                              ),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}