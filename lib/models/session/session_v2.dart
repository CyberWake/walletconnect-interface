import 'package:equatable/equatable.dart';
import 'package:walletconnect_interface/models/session/session.dart';

class SessionV2 extends WCSession {
  SessionV2({
    required this.topic,
    required this.expiry,
    required this.relay,
    required this.active,
    this.peerMetadata,
  });

  final String topic;
  final int expiry;
  final RelayerProtocolOptions relay;
  final bool active;
  final AppMetadata? peerMetadata;

  @override
  List<Object?> get props => [topic, expiry, relay, active, peerMetadata];

  @override
  String toUri() {
    throw UnimplementedError();
  }
}

class RelayerProtocolOptions extends Equatable {
  const RelayerProtocolOptions({
    required this.protocol,
    this.data,
  });

  factory RelayerProtocolOptions.fromJson(Map<String, dynamic> json) =>
      RelayerProtocolOptions(
        protocol: json['protocol'] as String,
        data: json['data'] as String?,
      );

  final String protocol;

  final String? data;

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{
      'protocol': protocol,
    };

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('data', data);
    return val;
  }

  @override
  List<Object?> get props => [protocol, data];
}

class AppMetadata extends Equatable {
  const AppMetadata({
    required this.name,
    required this.description,
    required this.url,
    required this.icons,
  });

  final String name;

  final String description;

  final String url;

  final List<String> icons;

  @override
  List<Object?> get props => [name, description, url, icons];
}
