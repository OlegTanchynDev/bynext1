class Token {
  const Token({
    this.token
  });

//  final String accessToken;
//  final String refreshToken;
  final String token;

//  static const String _keyAccessToken = 'access_token';
//  static const String _keyRefreshToken = 'refresh_token';

  static const String _keyToken = 'token';

  factory Token.fromJson(Map<String, dynamic> map) {
    return Token(
//      accessToken: map[_keyAccessToken],
//      refreshToken: map[_keyRefreshToken],

      token: map[_keyToken],
    );
  }

  Map<String, dynamic> toMap() => <String, String>{
//    _keyAccessToken: accessToken,
//    _keyRefreshToken: refreshToken,

    _keyToken: token,
  };

  factory Token.fromMap(Map<String, dynamic> map) => Token(
//    accessToken: map[_keyAccessToken] as String,
//    refreshToken: map[_keyRefreshToken] as String,

    token: map[_keyToken],
  );
}