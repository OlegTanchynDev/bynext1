import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const googleApiKeyIos = "AIzaSyCZ_S3boVTA-ne7H5PT2NfUBbm_oWygFZU";
const googleApiKeyAndroid = "AIzaSyBUL46fYVu8TyQm-21H61xd02qOFjqouog";

const servicesUrl = kDebugMode ? "https://playground.cleanlyapp.com/services" : "https://cleanlyapp.com/services";
//const servicesUrl = kDebugMode ? "https://playground.bynext.co/services" : "https://bynext.co/services";
const mediaUrl = "https://uploads-static.cleanlyapp.com/";
//const mediaUrl = "https://uploads-static.bynext.co/";
//const policyUrl = "https://cleanly.com/concierge/ticket-reimbursement-attendance/";
const policyUrl = "https://bynext.co/concierge/ticket-reimbursement-attendance/";
//const generalInfoUrl = "https://cleanly.com/concierge/rating-overview/";
const generalInfoUrl = "https://bynext.co/concierge/rating-overview/";

const requestTimeout = Duration(seconds: 15);

const driverSupportNumber = "1(855)8552221";

const raisedButtonColor = Color(0xFF403D9C);
