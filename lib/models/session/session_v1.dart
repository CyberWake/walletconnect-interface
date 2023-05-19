import 'package:walletconnect_interface/models/session/session.dart';

class SessionV1 extends WCSession {
  SessionV1({
    required this.topic,
    required this.version,
    required this.bridge,
    required this.key,
  });

  factory SessionV1.fromJson(Map<String, dynamic> json) {
    return SessionV1(
      topic: json['topic'] as String,
      version: json['version'] as String,
      bridge: json['bridge'] as String,
      key: json['key'] as String,
    );
  }

  final String topic;
  final String version;
  final String bridge;
  final String key;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'topic': topic,
      'version': version,
      'bridge': bridge,
      'key': key,
    };
  }

  @override
  String toUri() => 'wc:$topic@$version?bridge=$bridge&key=$key';

  @override
  List<Object?> get props => [topic, version, bridge, key];
}
