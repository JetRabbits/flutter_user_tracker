//
// Generated file. Do not edit.
//

// ignore_for_file: lines_longer_than_80_chars

import 'package:catcher/catcher_web_plugin.dart';
import 'package:device_info_plus_web/device_info_plus_web.dart';
import 'package:firebase_analytics_web/firebase_analytics_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  CatcherWebPlugin.registerWith(registrar);
  DeviceInfoPlusPlugin.registerWith(registrar);
  FirebaseAnalyticsWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  FluttertoastWebPlugin.registerWith(registrar);
  PackageInfoPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
