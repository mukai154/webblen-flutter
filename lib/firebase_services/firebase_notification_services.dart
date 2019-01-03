import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:webblen/widgets_common/common_flushbar.dart';
import 'package:webblen/firebase_services/user_data.dart';

class FirebaseNotificationsService {

final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  configFirebaseMessaging(BuildContext context){
    String messageTitle;
    String messageBody;
    String messageType;
    String userID;
    double userPoints;

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message){
        messageTitle = message['aps']['alert']['title'];
        messageBody = message['aps']['alert']['body'];
        messageType = message['TYPE'];
        userID = message['UID'];
        userPoints = double.parse(message['USER_POINTS']);

        AlertFlushbar(headerText: messageTitle, bodyText: messageBody, notificationType: messageType, userPoints: userPoints, uid: userID)
            .showNotificationFlushBar(context);
      },
      onMessage: (Map<String, dynamic> message){
        messageTitle = message['aps']['alert']['title'];
        messageBody = message['aps']['alert']['body'];
        messageType = message['TYPE'];
        userID = message['UID'];
        userPoints = double.parse(message['USER_POINTS']);

        AlertFlushbar(headerText: messageTitle, bodyText: messageBody, notificationType: messageType, userPoints: userPoints, uid: userID)
            .showNotificationFlushBar(context);
      },
      onResume: (Map<String, dynamic> message){
        messageTitle = message['aps']['alert']['title'];
        messageBody = message['aps']['alert']['body'];
        messageType = message['TYPE'];
        userID = message['UID'];
        userPoints = double.parse(message['USER_POINTS']);

        AlertFlushbar(headerText: messageTitle, bodyText: messageBody, notificationType: messageType, userPoints: userPoints, uid: userID)
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

}