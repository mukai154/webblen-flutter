import 'package:flutter/material.dart';
import 'package:webblen/widgets_common/common_alert.dart';
import 'dart:async';

class ShowAlertDialogService {

  Future<bool> showAlert(BuildContext context, Widget alertWidget, bool isDismissible) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: isDismissible, // user must tap button!
        builder: (BuildContext context) { return alertWidget; });
  }

  Future<bool> showSuccessDialog(BuildContext context, String header, String body) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) { return SuccessDialog(header: header, body: body); });
  }

  Future<bool> showFailureDialog(BuildContext context, String header, String body) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) { return FailureDialog(header: header, body: body); });
  }

  Future<bool> showCancelEventDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) { return CancelEventDialog(); });
  }

  Future<bool> showInfoDialog(BuildContext context, String header, String body) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) { return InfoDialog(header: header, body: body); });
  }

  Future<bool> showUpdateDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) { return UpdateAvailableDialog(); });
  }

  Future<bool> showLoadingDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, //// user must tap button!
        builder: (BuildContext context) { return LoadingDialog(); });
  }

  Future<bool> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, //// user must tap button!
        builder: (BuildContext context) { return LogoutDialog(context: context); });
  }

  Future<bool> showConfirmationDialog(BuildContext context, String header, String confirmActionTitle, VoidCallback confirmAction, VoidCallback cancelAction) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, //// user must tap button!
        builder: (BuildContext context) { return ConfirmationDialog(header: header, confirmActionTitle: confirmActionTitle, confirmAction: confirmAction, cancelAction: cancelAction); });
  }

}