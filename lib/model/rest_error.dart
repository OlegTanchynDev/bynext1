class RestError implements Exception {

  const RestError({this.errors,});

  final Map<String, String> errors;

  factory RestError.fromMap(Map<String, dynamic> map) {
    return RestError(
      errors: map.map((key, value) => MapEntry(key, (value as List).join(",")))
    );
  }
}