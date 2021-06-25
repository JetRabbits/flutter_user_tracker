library flutter_user_tracker;

import 'package:flutter_draft/flutter_draft.dart';
import 'package:flutter_user_tracker/actions/track_action.dart';

import 'integrations/google_tracker.dart';

export 'actions/track_action.dart';
export 'error_handling/catcher/lytics_report_mode.dart';
export 'integrations/google_tracker.dart';

setupUserTracker() async {
  await GoogleTracker.initialize();
  ActionRegister.addAction('tracker', TrackAction.toJson, TrackAction.fromJson);
}