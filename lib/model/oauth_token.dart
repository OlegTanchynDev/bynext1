class OauthToken {
  const OauthToken({
    this.accessToken,
    this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';

  factory OauthToken.fromJson(Map<String, dynamic> map) {
    return OauthToken(
      accessToken: map[_keyAccessToken],
      refreshToken: map[_keyRefreshToken],
    );
  }

  Map<String, dynamic> toMap() => <String, String>{
    _keyAccessToken: accessToken,
    _keyRefreshToken: refreshToken,
  };

  factory OauthToken.fromMap(Map<String, dynamic> map) => OauthToken(
    accessToken: map[_keyAccessToken] as String,
    refreshToken: map[_keyRefreshToken] as String,
  );
}