import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

///
/// Aggregates together both Google Lytics and Google Crashlytics features.
/// So this way allow to see Lytics events and errors in user session context
/// and it is useful to restore step by step scenario when app is crashed or
/// none-critical error is occurred.
///
/// Usage:
///
/// main.dart
/// ---
/// void main() async {
///   await Lytics.initialize();
///   // Call configure everytime you new new callbacks or reconfigure
///   await Lytics().configure(
///     options: LyticsOptions(onUserId: ..., onCustomProperties: ...)
///   )
/// }
///
class GoogleTracker {
  static final GoogleTracker _instance = GoogleTracker._();
  static final _logger = Logger("GoogleTracker");

  String? _deviceId;

  static Future<void> initialize() async {
    _logger.info("Firebase.initialize");
    await Firebase.initializeApp();
    await GoogleTracker().configure(
        firebaseAnalytics: FirebaseAnalytics(),
        crashlytics: FirebaseCrashlytics.instance,
        options: GoogleTrackerOptions.guestOptions);
  }

  GoogleTrackerOptions? options;

  GoogleTracker._();

  factory GoogleTracker() {
    return _instance;
  }

  void _setUser({String? userId, String? personId}) {
    _logger.info("setting user id");
    try {
      if (userId != null && userId.isNotEmpty) {
        _firebaseAnalytics.setUserId(userId);
        _crashlytics.setUserIdentifier(userId);
      } else {
        _firebaseAnalytics.setUserId(_deviceId == null ? "guest": "guest_$_deviceId");
        _crashlytics.setUserIdentifier(_deviceId == null ? "guest": "guest_$_deviceId");
      }

      if (personId != null && personId.isNotEmpty) {
        _firebaseAnalytics.setUserProperty(name: "person_id", value: personId);
        _crashlytics.setCustomKey("person_id", personId);
      } else {
        _firebaseAnalytics.setUserProperty(name: "person_id", value: "");
        _crashlytics.setCustomKey("person_id", "");
      }
    } catch (e) {
      print("Can not set analytics properties");
    }
  }

  late FirebaseAnalytics _firebaseAnalytics;
  FirebaseAnalyticsObserver? _observer;
  late FirebaseCrashlytics _crashlytics;

  Future<void> configure(
      {FirebaseCrashlytics? crashlytics,
      FirebaseAnalytics? firebaseAnalytics,
      String? userId,
      String? personId,
      GoogleTrackerOptions? options}) async {
    _logger.info("configure");
    if (crashlytics != null) {
      _crashlytics = crashlytics;
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
    }
    _logger.info("object: $firebaseAnalytics");
    if (firebaseAnalytics != null) {
      _firebaseAnalytics = firebaseAnalytics;
      _logger.info("create FirebaseAnalyticsObserver");
      _observer = FirebaseAnalyticsObserver(analytics: _firebaseAnalytics);
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      _deviceId = (await deviceInfo.androidInfo).androidId;
    } else {
      _deviceId = (await deviceInfo.iosInfo).identifierForVendor;
    }
    _setUser(userId: userId, personId: personId);

    this.options = options;
  }

  get observer => _observer;

  Future<void> _fillParams() async {
    try {
      if (options?.onUserId != null) {
        String _userId = await options!.onUserId!();
        if (_userId.isNotEmpty) {
          await _firebaseAnalytics.setUserId(_userId);
          await _crashlytics.setUserIdentifier(_userId);
        }
      }
    } catch (e, stack) {
      _logger.info("Can not set user id", e, stack);
    }

    try {
      if (options?.onCustomProperties != null) {
        Map<String, String> _props =
            await options!.onCustomProperties!();
        await Future.forEach(_props.keys, (dynamic key) async {
          await _firebaseAnalytics.setUserProperty(
              name: key, value: _props[key]);
          await _crashlytics.setCustomKey(key, _props[key]!);
        });
      }
    } catch (e, stack) {
      _logger.info("Can not set properties", e, stack);
    }
  }

  void logTapEvent(String buttonName, {Map<String, dynamic>? parameters}) {
    _logger.info("logTapEvent $buttonName");
    String eventName = "tap_$buttonName";
    _fillParams().then((_) =>
        _firebaseAnalytics.logEvent(name: eventName, parameters: parameters));
  }

  void logError(exception, StackTrace? stackTrace, Map<String, dynamic> parameters) {
    _logger.info("logError");
    String eventName = "application_error_event";
    _fillParams().then((_) async {
      await _firebaseAnalytics.logEvent(
          name: eventName, parameters: parameters);
      await _crashlytics.recordError(exception, stackTrace, printDetails: false);
    });
  }

  void logAction(String action, {Map<String, dynamic>? parameters}) {
    _logger.info("logAction");
    _firebaseAnalytics.logEvent(
        name: action.replaceAll(" ", "_"), parameters: parameters);
  }
}

class GoogleTrackerOptions {
  static GoogleTrackerOptions guestOptions =
      GoogleTrackerOptions(onUserId: () async => "guest");
  final Future<String> Function()? onUserId;
  final Future<Map<String, String>> Function()?
      onCustomProperties;

  GoogleTrackerOptions({this.onUserId, this.onCustomProperties});
}

loggableAction(String actionName, VoidCallback action) {
  GoogleTracker().logTapEvent(actionName);
  action();
}
