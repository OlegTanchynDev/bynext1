class RestError implements Exception {
  const RestError({this.username, this.password, this.nonFieldErrors,});

  final List username;
  final List password;
  final List nonFieldErrors;

  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';
  static const String _keyNonFieldErrors = 'non_field_errors';

  factory RestError.fromJson(Map<String, dynamic> map) {
    return RestError(
      username: map[_keyUsername],
      password: map[_keyPassword],
      nonFieldErrors: map[_keyNonFieldErrors],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    _keyUsername: username,
    _keyPassword: password,
    _keyNonFieldErrors: nonFieldErrors,
  };

  factory RestError.fromMap(Map<String, dynamic> map) => RestError(
    username: map[_keyUsername],
    password: map[_keyPassword],
    nonFieldErrors: map[_keyNonFieldErrors],
  );
}