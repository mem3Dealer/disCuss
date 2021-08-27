import 'dart:convert';

class AppState {
  int? version;
  AppState({
    this.version,
  });

  AppState copyWith({
    int? version,
  }) {
    return AppState(
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      version: map['version'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppState.fromJson(String source) =>
      AppState.fromMap(json.decode(source));

  @override
  String toString() => 'AppState(version: $version)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppState && other.version == version;
  }

  @override
  int get hashCode => version.hashCode;
}
