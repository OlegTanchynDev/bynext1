class Profile {
  const Profile({
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.referralCode,
    this.weightedGrade,
  });

  final String firstName;
  final String lastName;
  final String profilePhotoUrl;
  final String referralCode;
  final num weightedGrade;

  static final String _keyFirstName = "first_name";
  static final String _keyLastName = "last_name";
  static final String _keyProfilePhotoUrl = "profile_photo_url";
  static final String _keyReferralCode = "referral_code";
  static final String _keyWeightedGrade = "weighted_grade";

  Map<String, dynamic> toMap() => <String, dynamic>{
    _keyFirstName: firstName,
    _keyLastName: lastName,
    _keyProfilePhotoUrl: profilePhotoUrl,
    _keyReferralCode: referralCode,
    _keyWeightedGrade: weightedGrade,
  };

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
    firstName: map[_keyFirstName] as String,
    lastName: map[_keyLastName] as String,
    profilePhotoUrl: map[_keyProfilePhotoUrl] as String,
    referralCode: map[_keyReferralCode] as String,
    weightedGrade: map[_keyWeightedGrade] as num,
  );
}