// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Call Dispatcher`
  String get drawerCallDispatcher {
    return Intl.message(
      'Call Dispatcher',
      name: 'drawerCallDispatcher',
      desc: '',
      args: [],
    );
  }

  /// `Tasks`
  String get drawerTasks {
    return Intl.message(
      'Tasks',
      name: 'drawerTasks',
      desc: '',
      args: [],
    );
  }

  /// `Navigation`
  String get drawerNavigation {
    return Intl.message(
      'Navigation',
      name: 'drawerNavigation',
      desc: '',
      args: [],
    );
  }

  /// `Shifts`
  String get drawerShifts {
    return Intl.message(
      'Shifts',
      name: 'drawerShifts',
      desc: '',
      args: [],
    );
  }

  /// `Jobs`
  String get drawerJobs {
    return Intl.message(
      'Jobs',
      name: 'drawerJobs',
      desc: '',
      args: [],
    );
  }

  /// `My Salary`
  String get drawerMySalary {
    return Intl.message(
      'My Salary',
      name: 'drawerMySalary',
      desc: '',
      args: [],
    );
  }

  /// `My Invoice`
  String get drawerMyInvoice {
    return Intl.message(
      'My Invoice',
      name: 'drawerMyInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Issues`
  String get drawerIssues {
    return Intl.message(
      'Issues',
      name: 'drawerIssues',
      desc: '',
      args: [],
    );
  }

  /// `General Info`
  String get drawerGeneralInfo {
    return Intl.message(
      'General Info',
      name: 'drawerGeneralInfo',
      desc: '',
      args: [],
    );
  }

  /// `Policies`
  String get drawerPolicies {
    return Intl.message(
      'Policies',
      name: 'drawerPolicies',
      desc: '',
      args: [],
    );
  }

  /// `Switch Task`
  String get drawerSwitchTask {
    return Intl.message(
      'Switch Task',
      name: 'drawerSwitchTask',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get drawerLogout {
    return Intl.message(
      'Logout',
      name: 'drawerLogout',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password`
  String get forgotPasswordHeader {
    return Intl.message(
      'Forgot your password',
      name: 'forgotPasswordHeader',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email to reset your password:`
  String get forgotPasswordText {
    return Intl.message(
      'Please enter your email to reset your password:',
      name: 'forgotPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `In a few minutes you will receive an email with further instructions to reset your password`
  String get forgotPasswordResponseOk {
    return Intl.message(
      'In a few minutes you will receive an email with further instructions to reset your password',
      name: 'forgotPasswordResponseOk',
      desc: '',
      args: [],
    );
  }

  /// `Note:`
  String get forgotPasswordNote {
    return Intl.message(
      'Note:',
      name: 'forgotPasswordNote',
      desc: '',
      args: [],
    );
  }

  /// `The password reset links included in the emails are time-sensitive. If you click the link and it doesn't work, try requesting a new one and use the link as soon as you can.`
  String get forgotPasswordNotesText {
    return Intl.message(
      'The password reset links included in the emails are time-sensitive. If you click the link and it doesn\'t work, try requesting a new one and use the link as soon as you can.',
      name: 'forgotPasswordNotesText',
      desc: '',
      args: [],
    );
  }

  /// `Shift Cancellation`
  String get alertTitleShiftCancellation {
    return Intl.message(
      'Shift Cancellation',
      name: 'alertTitleShiftCancellation',
      desc: '',
      args: [],
    );
  }

  /// `Canceling a shift that starts in less than 24h will affect your grade and might result in temporary suspension. Are you sure you want to cancel this shift?`
  String get alertMessageLessThan24hCancellation {
    return Intl.message(
      'Canceling a shift that starts in less than 24h will affect your grade and might result in temporary suspension. Are you sure you want to cancel this shift?',
      name: 'alertMessageLessThan24hCancellation',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get alertTitleReminder {
    return Intl.message(
      'Reminder',
      name: 'alertTitleReminder',
      desc: '',
      args: [],
    );
  }

  /// `The shift start time is too close.\n\nIf there is an emergency please call and leave a message.`
  String get alertMessageCallReminder {
    return Intl.message(
      'The shift start time is too close.\n\nIf there is an emergency please call and leave a message.',
      name: 'alertMessageCallReminder',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `CALL`
  String get call {
    return Intl.message(
      'CALL',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Reason for canceling`
  String get alertTitleShiftCancellationReason {
    return Intl.message(
      'Reason for canceling',
      name: 'alertTitleShiftCancellationReason',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}