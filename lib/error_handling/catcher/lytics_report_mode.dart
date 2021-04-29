import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_jetlytics/integrations/lytics.dart';

///
/// Catcher report mode powered by Google Lytics/Crashlytics
///
class LyticsCatcherReportMode extends SilentReportMode {
  @override
  void requestAction(Report report, BuildContext? context) {
    Lytics.of(context)
        .logError(report.error, report.stackTrace, report.customParameters);
    super.requestAction(report, context);
  }

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() => PlatformType.values;
}
