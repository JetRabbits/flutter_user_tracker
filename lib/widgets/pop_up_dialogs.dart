import 'package:flutter/material.dart';
import 'package:flutter_user_tracker/generated/l10n.dart';
import 'package:flutter_user_tracker/integrations/google_tracker.dart';
// ignore: import_of_legacy_library_into_null_safe

///
/// Alert dialog with ok button and GoogleTracker send
///
Future<void> showAlertPopup(BuildContext context, String title, String detail) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(detail),
      actions: <Widget>[
        TextButton(
            child: Text(LyticsStrings.of(context).ok),
            onPressed: () => loggableAction("dialog_ok", () => Navigator.of(context, rootNavigator: true).pop())),
      ],
    ),
  );
}

///
/// Return true if user choose yes, else return false. GoogleTracker send support
///
Future<bool?> showYesNoPopup(BuildContext context, String title, String detail) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(detail),
            actions: <Widget>[
              TextButton(
                  child: Text(LyticsStrings.of(context).yes_answer,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () =>
                    loggableAction("dialog_yes", () => Navigator.of(context, rootNavigator: true).pop(true))),
              TextButton(
                  child: Text(LyticsStrings.of(context).no_answer,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () =>
                    loggableAction("dialog_no", () => Navigator.of(context, rootNavigator: true).pop(false))),
            ],
          ));
}

///
/// Return true if user choose option1, else return false. GoogleTracker send support.
///
Future<bool?> showOptionsPopup(BuildContext context, String title, String detail, String option1, String option2) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(detail),
            actions: <Widget>[
              TextButton(
                  child: Text(option1,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () =>
                    loggableAction("dialog_option1", () => Navigator.of(context, rootNavigator: true).pop(true))),
              TextButton(
                  child: Text(option2,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () =>
                    loggableAction("dialog_option2", () => Navigator.of(context, rootNavigator: true).pop(false))),
            ],
          ));
}
