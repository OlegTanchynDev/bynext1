class RestError implements Exception {

  const RestError({this.nonFieldErrors, this.fieldErrors,});

  final String nonFieldErrors;
  final Map<String, String> fieldErrors;

  static const String _keyFieldErrors = 'fieldErrors';
  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';
  static const String _keyNonFieldErrors = 'non_field_errors';

  factory RestError.fromJson(Map<String, dynamic> map) {
    final fieldMap = {
      _keyUsername: (map[_keyUsername] as List).join(", "),
      _keyPassword: (map[_keyPassword] as List).join(", "),
    };
    return RestError(
      nonFieldErrors: (map[_keyNonFieldErrors] as List).join(", "),
      fieldErrors: fieldMap,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    _keyNonFieldErrors: nonFieldErrors,
    _keyUsername: fieldErrors[_keyUsername],
    _keyPassword: fieldErrors[_keyPassword],
  };

  factory RestError.fromMap(Map<String, dynamic> map) {
    final fieldMap = {
      _keyUsername: (map[_keyUsername] as List).join(", "),
      _keyPassword: (map[_keyPassword] as List).join(", "),
    };
    return RestError(
      nonFieldErrors: (map[_keyNonFieldErrors] as List).join(", "),
      fieldErrors: fieldMap,
    );
  }
}