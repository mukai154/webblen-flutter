import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:webblen/styles/flat_colors.dart';
import 'package:webblen/widgets_common/common_flushbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webblen/widgets_chat/chat_row.dart';
import 'package:webblen/models/webblen_chat_message.dart';
import 'package:webblen/firebase_services/chat_data.dart';


class Chat extends StatelessWidget {

  final String currentUsername;
  final String currentUID;
  final String currentProfilePic;
  final String peerUsername;
  final String peerProfilePic;
  final String peerUID;
  final String chatDocKey;

  Chat({this.peerUsername, this.peerUID, this.peerProfilePic, this.currentUsername, this.currentUID, this.currentProfilePic, this.chatDocKey});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        brightness: Brightness.light,
        elevation: 2.0,
        backgroundColor: FlatColors.iosOffWhite,
        leading: BackButton(color: FlatColors.londonSquare),
        title: new Text(
          '@$peerUsername',
          style: TextStyle(color: FlatColors.blackPearl, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new ChatScreen(
        currentUsername: currentUsername,
        currentUID: currentUID,
        currentProfilePic: currentProfilePic,
        peerUsername: peerUsername,
        peerProfilePic: peerProfilePic,
        chatDocKey: chatDocKey,
        peerUID: peerUID
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {

  final String currentUsername;
  final String currentUID;
  final String currentProfilePic;
  final String peerUsername;
  final String peerProfilePic;
  final String chatDocKey;
  final String peerUID;
  ChatScreen({this.currentUsername, this.currentUID, this.currentProfilePic, this.peerUsername, this.peerProfilePic, this.chatDocKey, this.peerUID});

  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  List messageList;
  List previousSeenByList;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;
  String newChatDocKey;

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child('message_pics').child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, "image");
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      AlertFlushbar(headerText: "Image Error", bodyText: "This File Is Not an Image").showAlertFlushbar(context);
    });
  }

  void onSendMessage(String content, String type) {

    String messageSentTime = DateTime.now().millisecondsSinceEpoch.toString();
    List seenByList = [widget.currentUID];

    if (content.trim() != '') {
      textEditingController.clear();

      var messageReference = Firestore.instance
          .collection('chats')
          .document(widget.chatDocKey == null ? newChatDocKey : widget.chatDocKey)
          .collection('messages')
          .document(messageSentTime);


      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          messageReference, {
            'username': widget.currentUsername,
            'userImageURL': widget.currentProfilePic,
            'timestamp': messageSentTime,
            'messageContent': content,
            'messageType': type
        },
        );
      });


      if (previousSeenByList.contains(widget.peerUID) || previousSeenByList.isEmpty){
        ChatDataService().addMessageNotification(widget.peerUID);
      }
      ChatDataService().updateLastMessageSent(widget.chatDocKey == null ? newChatDocKey : widget.chatDocKey, widget.currentUsername, messageSentTime, type, seenByList, content);

      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      AlertFlushbar(headerText: "Message Error", bodyText: "Nothing to Send").showAlertFlushbar(context);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    WebblenChatMessage chatMessage = WebblenChatMessage.fromMap(document.data);
    if (document['username'] == widget.currentUsername) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showDate(index)
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                  DateFormat('MMM dd, h:mm a').format(DateTime.fromMillisecondsSinceEpoch(int.parse(chatMessage.timestamp))),
                  style: TextStyle(color: FlatColors.londonSquare, fontSize: 14.0),
                  textAlign: TextAlign.center,
                  ),
                )
              : Container(),
          SentMessage(chatMessage: chatMessage),
        ],
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SenderPic(userProfilePicUrl: widget.peerProfilePic),
                ReceivedMessage(chatMessage: chatMessage),
              ],
            ),
            // Time
            showDate(index)
                ? Container(
              child: Text(
                DateFormat('MMM dd, h:mm a')
                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(chatMessage.timestamp))),
                style: TextStyle(color: FlatColors.londonSquare, fontSize: 14.0, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool showDate(int index){
    bool returnDate = false;
    if (messageList != null && messageList[index]['messageType'] != 'initial') {
      if (messageList[index] != messageList.last){
        int messageTimeInMillisecondsA = int.parse(messageList[index]['timestamp']);
        int messageTimeInMillisecondsB = int.parse(messageList[index + 1]['timestamp']);
        if (messageTimeInMillisecondsA - messageTimeInMillisecondsB >= 7200000) {
          returnDate = true;
        }
      } else if (messageList[index] == messageList.last){
        returnDate = true;
      }
    }
    return returnDate;
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', "sticker"),
                child: new Image.asset(
                  'images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', "sticker"),
                child: new Image.asset(
                  'images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', "sticker"),
                child: new Image.asset(
                  'images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', "sticker"),
                child: new Image.asset(
                  'images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', "sticker"),
                child: new Image.asset(
                  'images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', "sticker"),
                child: new Image.asset(
                  'images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', "sticker"),
                child: new Image.asset(
                  'images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', "sticker"),
                child: new Image.asset(
                  'images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', "sticker"),
                child: new Image.asset(
                  'images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: FlatColors.lightAmericanGray, width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(FlatColors.webblenRed)),
        ),
        color: Colors.white.withOpacity(0.8),
      )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
                color: FlatColors.webblenRed,
              ),
            ),
            color: Colors.white,
          ),
//          Material(
//            child: new Container(
//              margin: new EdgeInsets.symmetric(horizontal: 1.0),
//              child: new IconButton(
//                icon: new Icon(Icons.face),
//                onPressed: getSticker,
//                color: FlatColors.webblenRed,
//              ),
//            ),
//            color: Colors.white,
//          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: FlatColors.blackPearl, fontSize: 18.0, fontWeight: FontWeight.w500),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: FlatColors.londonSquare),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, "text"),
                color: FlatColors.webblenRed,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: FlatColors.clouds, width: 1)),
          color: Colors.white
      ),
    );
  }

  Widget buildMessageList() {
    return Flexible(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('chats')
                .document(widget.chatDocKey == null ? newChatDocKey : widget.chatDocKey)
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(FlatColors.webblenRed)));
              } else {
                messageList = snapshot.data.documents;
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                  reverse: true,
                  controller: listScrollController,
                );
              }
            },
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.chatDocKey == null){
      ChatDataService().createChat(widget.currentUID, widget.peerUID, widget.currentUsername, widget.peerUsername, widget.currentProfilePic, widget.peerProfilePic).then((newChatKey){
        setState(() {
          newChatDocKey = newChatKey;
        });
      });
    } else {
      ChatDataService().getSeenByList(widget.chatDocKey).then((seenByList){
        setState(() {
          previousSeenByList = seenByList;
        });
        ChatDataService().updateSeenMessage(widget.chatDocKey, widget.currentUID);
      });
    }
    focusNode.addListener(onFocusChange);
    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              buildMessageList(),
              // Sticker
              (isShowSticker ? buildSticker() : Container()),
              // Input content
              buildInput(),
            ],
          ),
          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }


}