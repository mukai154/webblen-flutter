import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:webblen/widgets_common/common_flushbar.dart';
import 'package:webblen/firebase_services/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webblen/models/webblen_notification.dart';
import 'dart:math';

class FirebaseNotificationsService {

final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
final CollectionReference notificationRef = Firestore.instance.collection("user_notifications");

//** FIREBASE MESSAGING  */
  configFirebaseMessaging(BuildContext context, String uid){
    String messageTitle;
    String messageBody;
    String messageType;
    double userPoints;

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message){
        messageTitle = message['aps']['alert']['title'];
        messageBody = message['aps']['alert']['body'];
        messageType = message['TYPE'];
        userPoints = double.parse(message['USER_POINTS']);
        AlertFlushbar(headerText: messageTitle, bodyText: messageBody, notificationType: messageType, userPoints: userPoints, uid: uid)
            .showNotificationFlushBar(context);
      },
      onMessage: (Map<String, dynamic> message){
        messageTitle = message['aps']['alert']['title'];
        messageBody = message['aps']['alert']['body'];
        messageType = message['TYPE'];
        userPoints = double.parse(message['USER_POINTS']);
        AlertFlushbar(headerText: messageTitle, bodyText: messageBody, notificationType: messageType, userPoints: userPoints, uid: uid)
            .showNotificationFlushBar(context);
      },
      onResume: (Map<String, dynamic> message){
        messageTitle = message['aps']['alert']['title'];
        messageBody = message['aps']['alert']['body'];
        messageType = message['TYPE'];
        userPoints = double.parse(message['USER_POINTS']);
        AlertFlushbar(headerText: messageTitle, bodyText: messageBody, notificationType: messageType, userPoints: userPoints, uid: uid)
              .showNotificationFlushBar(context);
      },

    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: false,
            alert: true,
            badge: true
        )
    );
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings iosSetting){
      //print('ios settings registered');
    });
  }

  updateFirebaseMessageToken(String uid){
    firebaseMessaging.getToken().then((token){
      UserDataService().setUserCloudMessageToken(uid, token);
    });
  }

//** NOTIFICATIONS  */
Future<String> createFriendRequestNotification(String uid, String peerUID, String peerUsername, String peerPicUrl) async {
    String status = "";
    String notifKey = Random().nextInt(999999999).toString();
    String messageToken = await UserDataService().findUserMesseageTokenByID(peerUID);
    WebblenNotification notification = WebblenNotification(
      messageToken: messageToken,
      notificationData: peerUID,
      notificationDescription: "@$peerUsername wants to be your friend",
      notificationExpirationDate: DateTime.now().add(Duration(days: 14)).millisecondsSinceEpoch.toString(),
      notificationKey: notifKey,
      notificationPicData: peerPicUrl,
      notificationSeen: false,
      notificationSender: peerUsername,
      notificationType: "friendRequest",
      sponsoredNotification: false,
      uid: uid,
    );

    notificationRef.document(notifKey).setData(notification.toMap()).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<String> createCommunityDisbandedNotification(String notifData, String receivingUid, String notifDescription) async {
    String status = "";
    String notifKey = Random().nextInt(999999999).toString();
    String messageToken = await UserDataService().findUserMesseageTokenByID(receivingUid);
    WebblenNotification notification = WebblenNotification(
        notificationData: null,
        notificationDescription: notifDescription,
        notificationExpirationDate: DateTime.now().add(Duration(days: 14)).millisecondsSinceEpoch.toString(),
        notificationKey: notifKey,
        notificationPicData: null,
        notificationSeen: false,
        notificationSender: null,
        notificationType: "communityDisbanded",
        sponsoredNotification: false,
        uid: receivingUid,
        messageToken: messageToken
    );

    notificationRef.document(notifKey).setData(notification.toMap()).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<String> createCommunityActiveNotification(String notifData, String receivingUid, String notifDescription) async {
    String status = "";
    String notifKey = Random().nextInt(999999999).toString();
    String messageToken = await UserDataService().findUserMesseageTokenByID(receivingUid);
    WebblenNotification notification = WebblenNotification(
        notificationData: null,
        notificationDescription: notifDescription,
        notificationExpirationDate: DateTime.now().add(Duration(days: 14)).millisecondsSinceEpoch.toString(),
        notificationKey: notifKey,
        notificationPicData: null,
        notificationSeen: false,
        notificationSender: null,
        notificationType: "communityActivated",
        sponsoredNotification: false,
        uid: receivingUid,
        messageToken: messageToken
    );

    notificationRef.document(notifKey).setData(notification.toMap()).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<String> createInviteNotification(String senderUid, String notifData, String receivingUid, String notifDescription) async {
    String status = "";
    String notifKey = Random().nextInt(999999999).toString();
    String messageToken = await UserDataService().findUserMesseageTokenByID(receivingUid);
    WebblenNotification notification = WebblenNotification(
      notificationData: notifData,
      notificationDescription: notifDescription,
      notificationExpirationDate: DateTime.now().add(Duration(days: 14)).millisecondsSinceEpoch.toString(),
      notificationKey: notifKey,
      notificationPicData: null,
      notificationSeen: false,
      notificationSender: senderUid,
      notificationType: "invite",
      sponsoredNotification: false,
      uid: receivingUid,
      messageToken: messageToken
    );

    notificationRef.document(notifKey).setData(notification.toMap()).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<String> createWalletDepositNotification(String uid, double depositAmount, String depositor) async {
    String status = "";
    String notifKey = Random().nextInt(999999999).toString();

    WebblenNotification notification = WebblenNotification(
      notificationData: null,
      notificationDescription: depositAmount.toStringAsFixed(2) + " webblen has been deposited into your wallet",
      notificationExpirationDate: DateTime.now().add(Duration(days: 14)).millisecondsSinceEpoch.toString(),
      notificationKey: notifKey,
      notificationPicData: null,
      notificationSeen: false,
      notificationSender: depositor,
      notificationType: "deposit",
      sponsoredNotification: false,
      uid: uid,
    );

    notificationRef.document(notifKey).setData(notification.toMap()).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<String> eventRecommendationNotification(String uid, String eventKey, String eventTitle) async {
    String status = "";
    String notifKey = Random().nextInt(999999999).toString();

    WebblenNotification notification = WebblenNotification(
      notificationData: eventKey,
      notificationDescription: "We Found an event you might like: $eventTitle",
      notificationExpirationDate: DateTime.now().add(Duration(days: 14)).millisecondsSinceEpoch.toString(),
      notificationKey: notifKey,
      notificationPicData: null,
      notificationSeen: false,
      notificationSender: eventKey,
      notificationType: "eventRecommendation",
      sponsoredNotification: false,
      uid: uid,
    );

    notificationRef.document(notifKey).setData(notification.toMap()).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<String> eventSharedNotification(String uid, String peerUsername, String eventTitle, String peerUID, String eventKey) async {
    String status = "";
    String notifKey = Random().nextInt(999999999).toString();

    WebblenNotification notification = WebblenNotification(
      notificationData: eventKey,
      notificationDescription: "@$peerUsername shared an event with you: $eventTitle",
      notificationExpirationDate: DateTime.now().add(Duration(days: 14)).millisecondsSinceEpoch.toString(),
      notificationKey: notifKey,
      notificationPicData: null,
      notificationSeen: false,
      notificationSender: peerUID,
      notificationType: "eventShare",
      sponsoredNotification: false,
      uid: uid,
    );

    notificationRef.document(notifKey).setData(notification.toMap()).whenComplete((){
    }).catchError((e) {
      status = e.details;
    });
    return status;
  }

  Future<Null> updateNotificationStatus(String notifKey) async {
    notificationRef.document(notifKey).updateData({"notificationSeen": true}).whenComplete(() {
    }).catchError((e) {
    });
  }

  Future<Null> deleteNotification(String notifKey) async {
    notificationRef.document(notifKey).delete();
  }

  Future<Null> deleteFriendRequestByID(String currentUID, String peerUID) async {
    QuerySnapshot notifQuery = await notificationRef
        .where('uid', isEqualTo: currentUID)
        .where('notificationData', isEqualTo: peerUID)
        .where('notificationType', isEqualTo: 'friendRequest')
        .getDocuments();

    notifQuery.documents.forEach((notifDoc){
      notificationRef.document(notifDoc.documentID).delete();
    });
  }


//  Future<Null> createTestNotification() async {
//    WebblenNotification testNotif = WebblenNotification(
//      messageToken: "dkx3Y__zhow:APA91bGe-YnldoRpuidKiom_GEoFVRpwmvsuqpAsYbTzoalRdXtDo9RJa6QgsvFtd4hOh_xutcHb9JkMcrbF-vNJb9zKKYHK7g9t3_s8j4xd9TmVpDnRcvHmGCq_JKZgF1g6OYefAJg4",
//      notificationData: "JYDnjBuv7NN9VjcWlSJFBVWGxYX2",
//      notificationDescription: "You've Been Invited to Join the Community #webblen",
//      notificationExpirationDate: "1557274741714",
//      notificationKey: "572249258",
//      notificationSeen: false,
//      notificationSender: 'dev',
//      sponsoredNotification: false,
//      notificationType: 'invite',
//      uid: 'Dya8eg1EToYMBTiCyAgFekN5J232'
//    );
//
//
//    notificationRef.document(testNotif.notificationKey).setData(testNotif.toMap()).whenComplete(() {
//    }).catchError((e) {
//    });
//  }

}