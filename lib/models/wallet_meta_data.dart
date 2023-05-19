import 'package:equatable/equatable.dart';

class ApplicationMeta extends Equatable {
  const ApplicationMeta({
    required this.name,
    required this.description,
    required this.url,
    required this.icons,
  });

  factory ApplicationMeta.empty() => const ApplicationMeta(
        name: '',
        description: '',
        url: '',
        icons: [],
      );

  factory ApplicationMeta.fromJson(Map<String, dynamic> json) =>
      ApplicationMeta(
        name: json['name'] as String,
        description: json['description'] as String,
        url: json['url'] as String,
        icons:
            (json['icons'] as List<dynamic>).map((e) => e as String).toList(),
      );
  final String name;

  final String description;

  final String url;

  final List<String> icons;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'description': description,
        'url': url,
        'icons': icons,
      };

  @override
  List<Object?> get props => [name, description, url, icons];
}
