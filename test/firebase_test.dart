// @dart=2.9
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class StackTraceFake extends Fake implements StackTrace {}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  FirebaseAnalytics firebaseAnalytics;
  FirebaseCrashlytics firebaseCrashlytics;
  setUp(() {
    firebaseAnalytics = MockFirebaseAnalytics();
    firebaseCrashlytics = MockFirebaseCrashlytics();
    registerFallbackValue(StackTraceFake());
    when(() => firebaseCrashlytics.recordError(any, any<StackTrace>(),
        reason: any(named: "reason"))).thenAnswer((realInvocation) async {
      print("firebase: ${realInvocation.positionalArguments.first}");
    });
    // when(firebaseCrashlytics.setUserIdentifier(any)).thenAnswer((_) async => print(_.positionalArguments.first));

    when(() => firebaseAnalytics.logEvent(
            name: any(named: "name"), parameters: any(named: "parameters")))
        .thenAnswer((realInvocation) async =>
            print("Lytics: ${realInvocation.namedArguments[Symbol('name')]}"));
    // when(firebaseAnalytics.setUserId(any)).thenAnswer((_) async => print(_.positionalArguments.first));
  });
}
