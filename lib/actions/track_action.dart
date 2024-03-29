import 'package:flutter_draft/flutter_draft.dart';
import 'package:flutter_user_tracker/integrations/google_tracker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track_action.g.dart';

enum TrackSystem { GOOGLE, YANDEX }

@JsonSerializable()
class TrackAction extends Action {
  final String eventName;
  final Map<String, dynamic>? eventParameters;
  final TrackSystem system;

  TrackAction(
      {required String id,
      String type = 'track',
      required this.system,
      this.eventParameters,
      required this.eventName})
      : super(type: type, id: id);

  static Map<String, dynamic> toJson(Action instance) =>
      _$TrackActionToJson(instance as TrackAction);

  static Action fromJson(dynamic json) => _$TrackActionFromJson(json);

  @override
  Future<void> perform(
      BuildContext context, Map<String, dynamic> parameters) async {
    switch (system) {
      case TrackSystem.GOOGLE:
        GoogleTracker().logAction(eventName, parameters: eventParameters);
        break;
      case TrackSystem.YANDEX:
        throw 'Not Implemented';
    }
  }
}
