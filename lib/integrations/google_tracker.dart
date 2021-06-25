
import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

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

  static Future<void> initialize() async {
    print("Firebase.initialize");
    await Firebase.initializeApp();
    await GoogleTracker().configure(
        firebaseAnalytics: FirebaseAnalytics(),
        crashlytics: FirebaseCrashlytics.instance,
        options: GoogleTarckerOptions.guestOptions);
  }

  GoogleTarckerOptions? options;

  GoogleTracker._();

  factory GoogleTracker() {
    return _instance;
  }

  late FirebaseAnalytics _firebaseAnalytics;
  FirebaseAnalyticsObserver? _observer;
  late FirebaseCrashlytics _crashlytics;
  BuildContext? _context;

  Future<void> configure(
      {FirebaseCrashlytics? crashlytics,
      FirebaseAnalytics? firebaseAnalytics,
        GoogleTarckerOptions? options}) async {
    print("Lytics configure");
    if (crashlytics != null) {
      _crashlytics = crashlytics;
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
    }
    print("Lytics object: $firebaseAnalytics");
    if (firebaseAnalytics != null) {
      _firebaseAnalytics = firebaseAnalytics;
      print("Lytics create FirebaseLyticsObserver");
      _observer = FirebaseAnalyticsObserver(analytics: _firebaseAnalytics);
    }
    this.options = options;
  }

  get observer => _observer;

  factory GoogleTracker.of(BuildContext? context) {
    _instance._context = context;
    return _instance;
  }

  Future<void> _fillParams(BuildContext? context) async {
    if (context == null) {
      print(
          "Can not set Lytics properties due to null context. Consider use Lytics.of()");
      return;
    }

    try {
      if (options?.onUserId != null) {
        String _userId = await options!.onUserId!(context);
        await _firebaseAnalytics.setUserId(_userId);
        await _crashlytics.setUserIdentifier(_userId);
      }
    } catch (e, stack) {
      print("Can not set user id: $e");
      print(stack);
    }

    try {
      if (options?.onCustomProperties != null) {
        Map<String, String> _props = await options!.onCustomProperties!(context);
        await Future.forEach(_props.keys, (dynamic key) async {
          await _firebaseAnalytics.setUserProperty(name: key, value: _props[key]);
          await _crashlytics.setCustomKey(key, _props[key]!);
        });
      }
    } catch (e) {
      print("Can not set Lytics properties");
    }
  }

  void logTapEvent(String buttonName, {Map<String, dynamic>? parameters}) {
    String eventName = "tap_$buttonName";
    _fillParams(_context).then(
        (_) => _firebaseAnalytics.logEvent(name: eventName, parameters: parameters));
  }

  void logError(exception, stackTrace, Map<String, dynamic> parameters) {
    String eventName = "application_error_event";
    _fillParams(_context).then((_) async {
      await _firebaseAnalytics.logEvent(name: eventName, parameters: parameters);
      await _crashlytics.recordError(exception, stackTrace);
    });
  }

  void logAction(String action, {Map<String, dynamic>? parameters}) {
    _firebaseAnalytics.logEvent(
        name: action.replaceAll(" ", "_"), parameters: parameters);
  }
}

class GoogleTarckerOptions {
  static GoogleTarckerOptions guestOptions =
  GoogleTarckerOptions(onUserId: (_) async => "guest");
  final Future<String> Function(BuildContext context)? onUserId;
  final Future<Map<String, String>> Function(BuildContext context)?
      onCustomProperties;

  GoogleTarckerOptions({this.onUserId, this.onCustomProperties});
}

loggableAction(String actionName, BuildContext context, VoidCallback action) {
  GoogleTracker.of(context).logTapEvent(actionName);
  action();
}