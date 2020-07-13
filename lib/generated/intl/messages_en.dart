// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "alertMessageCallReminder" : MessageLookupByLibrary.simpleMessage("The shift start time is too close.\n\nIf there is an emergency please call and leave a message."),
    "alertMessageLessThan24hCancellation" : MessageLookupByLibrary.simpleMessage("Canceling a shift that starts in less than 24h will affect your grade and might result in temporary suspension. Are you sure you want to cancel this shift?"),
    "alertTitleReminder" : MessageLookupByLibrary.simpleMessage("Reminder"),
    "alertTitleShiftCancellation" : MessageLookupByLibrary.simpleMessage("Shift Cancellation"),
    "alertTitleShiftCancellationReason" : MessageLookupByLibrary.simpleMessage("Reason for canceling"),
    "call" : MessageLookupByLibrary.simpleMessage("CALL"),
    "continueJobButton" : MessageLookupByLibrary.simpleMessage("Continue Job"),
    "drawerCallDispatcher" : MessageLookupByLibrary.simpleMessage("Call Dispatcher"),
    "drawerGeneralInfo" : MessageLookupByLibrary.simpleMessage("General Info"),
    "drawerIssues" : MessageLookupByLibrary.simpleMessage("Issues"),
    "drawerJobs" : MessageLookupByLibrary.simpleMessage("Jobs"),
    "drawerLogout" : MessageLookupByLibrary.simpleMessage("Logout"),
    "drawerMyInvoice" : MessageLookupByLibrary.simpleMessage("My Invoice"),
    "drawerMySalary" : MessageLookupByLibrary.simpleMessage("My Salary"),
    "drawerNavigation" : MessageLookupByLibrary.simpleMessage("Navigation"),
    "drawerPolicies" : MessageLookupByLibrary.simpleMessage("Policies"),
    "drawerShifts" : MessageLookupByLibrary.simpleMessage("Shifts"),
    "drawerSwitchTask" : MessageLookupByLibrary.simpleMessage("Switch Task"),
    "drawerTasks" : MessageLookupByLibrary.simpleMessage("Tasks"),
    "forgotPasswordHeader" : MessageLookupByLibrary.simpleMessage("Forgot your password"),
    "forgotPasswordNote" : MessageLookupByLibrary.simpleMessage("Note:"),
    "forgotPasswordNotesText" : MessageLookupByLibrary.simpleMessage("The password reset links included in the emails are time-sensitive. If you click the link and it doesn\'t work, try requesting a new one and use the link as soon as you can."),
    "forgotPasswordResponseOk" : MessageLookupByLibrary.simpleMessage("In a few minutes you will receive an email with further instructions to reset your password"),
    "forgotPasswordText" : MessageLookupByLibrary.simpleMessage("Please enter your email to reset your password:"),
    "no" : MessageLookupByLibrary.simpleMessage("No"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "save" : MessageLookupByLibrary.simpleMessage("Save"),
    "startJobButton" : MessageLookupByLibrary.simpleMessage("Start Job"),
    "taskChangedMessage" : MessageLookupByLibrary.simpleMessage("You have been assigned a new task by dispatch."),
    "taskChangedTitle" : MessageLookupByLibrary.simpleMessage("Task Changed"),
    "yes" : MessageLookupByLibrary.simpleMessage("Yes")
  };
}
