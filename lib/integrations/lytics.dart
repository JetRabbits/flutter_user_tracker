
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
class Lytics {
  static final Lytics _instance = Lytics._();

  static Future<void> initialize() async {
    print("Firebase.initialize");
    await Firebase.initializeApp();
    await Lytics().configure(
        Lytics: FirebaseAnalytics(),
        crashlytics: FirebaseCrashlytics.instance,
        options: LyticsOptions.guestOptions);
  }

  LyticsOptions? options;

  Lytics._();

  factory Lytics() {
    return _instance;
  }

  late FirebaseAnalytics _Lytics;
  FirebaseAnalyticsObserver? _observer;
  late FirebaseCrashlytics _crashlytics;
  BuildContext? _context;

  Future<void> configure(
      {FirebaseCrashlytics? crashlytics,
      FirebaseAnalytics? Lytics,
        LyticsOptions? options}) async {
    print("Lytics configure");
    if (crashlytics != null) {
      _crashlytics = crashlytics;
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
    }
    print("Lytics object: $Lytics");
    if (Lytics != null) {
      _Lytics = Lytics;
      print("Lytics create FirebaseLyticsObserver");
      _observer = FirebaseAnalyticsObserver(analytics: _Lytics);
    }
    this.options = options;
  }

  get observer => _observer;

  factory Lytics.of(BuildContext? context) {
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
        await _Lytics.setUserId(_userId);
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
          await _Lytics.setUserProperty(name: key, value: _props[key]);
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
        (_) => _Lytics.logEvent(name: eventName, parameters: parameters));
  }

  void logError(exception, stackTrace, Map<String, dynamic> parameters) {
    String eventName = "application_error_event";
    _fillParams(_context).then((_) async {
      await _Lytics.logEvent(name: eventName, parameters: parameters);
      await _crashlytics.recordError(exception, stackTrace);
    });
  }
}

class LyticsOptions {
  static LyticsOptions guestOptions =
  LyticsOptions(onUserId: (_) async => "guest");
  final Future<String> Function(BuildContext context)? onUserId;
  final Future<Map<String, String>> Function(BuildContext context)?
      onCustomProperties;

  LyticsOptions({this.onUserId, this.onCustomProperties});
}

loggableAction(String actionName, BuildContext context, VoidCallback action) {
  Lytics.of(context).logTapEvent(actionName);
  action();
}
