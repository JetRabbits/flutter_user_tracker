// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackAction _$TrackActionFromJson(Map<String, dynamic> json) {
  return TrackAction(
    id: json['id'] as String,
    type: json['type'] as String,
    system: _$enumDecode(_$TrackSystemEnumMap, json['system']),
    eventParameters: json['event_parameters'] as Map<String, dynamic>?,
    eventName: json['event_name'] as String,
  );
}

Map<String, dynamic> _$TrackActionToJson(TrackAction instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
    'event_name': instance.eventName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('event_parameters', instance.eventParameters);
  val['system'] = _$TrackSystemEnumMap[instance.system];
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$TrackSystemEnumMap = {
  TrackSystem.GOOGLE: 'GOOGLE',
  TrackSystem.YANDEX: 'YANDEX',
};
