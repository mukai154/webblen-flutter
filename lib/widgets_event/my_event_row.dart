import 'package:flutter/material.dart';
import 'package:webblen/models/event_post.dart';
import 'package:webblen/animations/transition_animations.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/event_pages/event_message_board_page.dart';
import 'event_circle_image.dart';


class MyEventRow extends StatelessWidget {

  final EventPost eventPost;
  final TextStyle headerTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 24.0, color: FlatColors.blackPearl);
  final TextStyle subHeaderTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: FlatColors.londonSquare);
  final TextStyle bodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: FlatColors.blackPearl);
  final TextStyle boldBodyTextStyle =  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: FlatColors.blackPearl);
  final TextStyle statTextStyle =  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: FlatColors.lightAmericanGray);
  final String currentUID;
  MyEventRow(this.currentUID, this.eventPost);


  @override
  Widget build(BuildContext context) {

    void transitionToMessageBoard () =>  Navigator.push(context, ScaleAndPopRoute(widget: EventMessageBoardPage(currentUID: currentUID, eventPost: eventPost)));


    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Stack(
        children: <Widget>[
          /// Item card
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox.fromSize(
                size: Size.fromHeight(172.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    /// Item description inside a material
                    Container(
                      margin: EdgeInsets.only(top: 24.0),
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(12.0),
                        shadowColor: Color(0x802196F3),
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {transitionToMessageBoard();},
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /// Title and rating
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(eventPost.title, style: headerTextStyle),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Rating Currently Unavailable', style: subHeaderTextStyle),
                                      ],
                                    ),
                                  ],
                                ),
                                /// Infos
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Views:', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(8.0),
                                        color: FlatColors.londonSquare,
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('${eventPost.views}', style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                    Text('Estimated Turnout:', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(8.0),
                                        color: FlatColors.electronBlue,
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('${eventPost.estimatedTurnout} users', style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    /// Item image
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: EventCircleImage(eventImageUrl: eventPost.pathToImage, size: 80.0),
                      ),
                    ),
                  ],
                )
            ),
          ),
          /// Message
          Padding(
            padding: EdgeInsets.only(top: 160.0, left: 40.0),
            child: Material(
              elevation: 12.0,
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  gradient: LinearGradient(
                      colors: [ Color(0xFF84fab0), Color(0xFF8fd3f4) ],
                      end: Alignment.topLeft,
                      begin: Alignment.bottomRight
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2.0),
                  child: ListTile(
//                    leading: CircleAvatar(
//                      backgroundColor: FlatColors.londonSquare,
//                      child: Text('AI'),
//                    ),
                    title: Text('Last Message', style: boldBodyTextStyle),
                    subtitle: Text('No Recent Messages for this Event', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle()),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}