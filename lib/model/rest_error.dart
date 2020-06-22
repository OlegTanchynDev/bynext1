class RestError implements Exception {

  const RestError({this.errors,});

//  final String nonFieldErrors;
  final Map<String, String> errors;

//  static const String _keyFieldErrors = 'fieldErrors';
//  static const String _keyUsername = 'username';
//  static const String _keyPassword = 'password';
//  static const String _keyNonFieldErrors = 'non_field_errors';

//  factory RestError.fromJson(Map<String, dynamic> map) {
//    return RestError(
////      nonFieldErrors: (map[_keyNonFieldErrors] as List).join(", "),
////      fieldErrors: fieldMap,
//      errors: map.map((key, value) => MapEntry(key, (value as List).join(",")))
//    );
//  }

//  Map<String, dynamic> toMap() => <String, dynamic>{
//
//  };

  factory RestError.fromMap(Map<String, dynamic> map) {
    return RestError(
      errors: map.map((key, value) => MapEntry(key, (value as List).join(",")))

    );
  }
}