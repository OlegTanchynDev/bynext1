import 'package:bynextcourier/model/shift.dart';

class Profile {
  const Profile({
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.referralCode,
    this.weightedGrade,
    this.captureLocationIntervalSec,
    this.sendLocationIntervalSec,
    this.distanceToleranceMeter,
    this.minimumGeoLocationDistance,
    this.rateSystem,
  });

  final String firstName;
  final String lastName;
  final String profilePhotoUrl;
  final String referralCode;
  final num weightedGrade;
  final num captureLocationIntervalSec;
  final num sendLocationIntervalSec;
  final num distanceToleranceMeter;
  final num minimumGeoLocationDistance;
  final RateSystem rateSystem;

  static final String _keyFirstName = "first_name";
  static final String _keyLastName = "last_name";
  static final String _keyProfilePhotoUrl = "profile_photo_url";
  static final String _keyReferralCode = "referral_code";
  static final String _keyWeightedGrade = "weighted_grade";
  static final String keyCaptureLocationIntervalSec = "capture_location_interval_sec";
  static final String keySendLocationIntervalSec = "send_location_interval_sec";
  static final String keyDistanceToleranceMeter = "distance_tolerance_meter";
  static final String keyMinimumGeoLocationDistance = "minimum_geo_location_distance";
  static final String _keyRateSystem = "rate_system";

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
    firstName: map[_keyFirstName] as String,
    lastName: map[_keyLastName] as String,
    profilePhotoUrl: map[_keyProfilePhotoUrl] as String,
    referralCode: map[_keyReferralCode] as String,
    weightedGrade: map[_keyWeightedGrade] as num,
    captureLocationIntervalSec: map[keyCaptureLocationIntervalSec] as num,
    sendLocationIntervalSec: map[keySendLocationIntervalSec] as num,
    distanceToleranceMeter: map[keyDistanceToleranceMeter] as num,
    minimumGeoLocationDistance: map[keyMinimumGeoLocationDistance] as num,
    rateSystem: parseRateSystemFromInt(map[_keyRateSystem] as int)
  );
}