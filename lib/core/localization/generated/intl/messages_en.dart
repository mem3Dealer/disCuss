// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) =>
      "Well, ${name}, you can`t write here. Go ask for perm.";

  static String m1(category) =>
      "You are creating new discussion in ${category} category.";

  static String m2(category) => "New ${category} discussion";

  static String m3(category) => "${category} rooms";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "areYouNew":
            MessageLookupByLibrary.simpleMessage("New to DisCuss? Register"),
        "authStatusEmailAlreadyExists": MessageLookupByLibrary.simpleMessage(
            "This email has already been registered. Please login or reset your password."),
        "authStatusInvEmail": MessageLookupByLibrary.simpleMessage(
            "Your email address appears to be malformed."),
        "authStatusOperationNotAllowed": MessageLookupByLibrary.simpleMessage(
            "Signing in with Email and Password is not enabled."),
        "authStatusTooManyRequests": MessageLookupByLibrary.simpleMessage(
            "Too many requests. Try again later."),
        "authStatusUndefError": MessageLookupByLibrary.simpleMessage(
            "An undefined Error happened."),
        "authStatusUserDisabled": MessageLookupByLibrary.simpleMessage(
            "User with this email has been disabled."),
        "authStatusUserNotFound": MessageLookupByLibrary.simpleMessage(
            "User with this email doesn\'t exist."),
        "authStatusWrongPassword":
            MessageLookupByLibrary.simpleMessage("Your password is wrong."),
        "catsPage": MessageLookupByLibrary.simpleMessage("Select category"),
        "chatPageBodyMessageBanned": MessageLookupByLibrary.simpleMessage(
            "You were banned from this discussion"),
        "chatPageBodyMessageEmptyChat":
            MessageLookupByLibrary.simpleMessage("ooops... Such empty!"),
        "chatPageBodyMessageNotMember": MessageLookupByLibrary.simpleMessage(
            "You are not yet member of this group"),
        "chatPageBodyMessageRequestDev": MessageLookupByLibrary.simpleMessage(
            "Your request is under develeopement"),
        "chatPageSnackForOpenRoom": MessageLookupByLibrary.simpleMessage(
            "Hit + to join this room and be able to send messages"),
        "chatPageSnackForPerm": m0,
        "chatPageSnackJoinedRoom": MessageLookupByLibrary.simpleMessage(
            "You have joined this room. Be nice!"),
        "chatPageSnackSentRequest": MessageLookupByLibrary.simpleMessage(
            "Join reqeust sent. Fingers crossed"),
        "dbCatsAstrology": MessageLookupByLibrary.simpleMessage("Astrology"),
        "dbCatsBelgiumCrysis":
            MessageLookupByLibrary.simpleMessage("Belgium Crysis"),
        "dbCatsCats": MessageLookupByLibrary.simpleMessage("Cats"),
        "dbCatsClothes": MessageLookupByLibrary.simpleMessage("Clothes"),
        "dbCatsGlobalWarming":
            MessageLookupByLibrary.simpleMessage("Global Warming"),
        "dbCatsHike": MessageLookupByLibrary.simpleMessage("Hike"),
        "dbCatsLiterature": MessageLookupByLibrary.simpleMessage("Literature"),
        "dbCatsPhysics": MessageLookupByLibrary.simpleMessage("Physics"),
        "dbCatsPolitics": MessageLookupByLibrary.simpleMessage("Politics"),
        "dbCatsPsychologies":
            MessageLookupByLibrary.simpleMessage("Psychologies"),
        "dbCatsRenissans": MessageLookupByLibrary.simpleMessage("Renissans"),
        "dbCatsRock": MessageLookupByLibrary.simpleMessage("Rock`n`Roll"),
        "dbCatsSport": MessageLookupByLibrary.simpleMessage("Sport"),
        "dbCatsStarWars": MessageLookupByLibrary.simpleMessage("Star Wars"),
        "dbCatsVideoGames": MessageLookupByLibrary.simpleMessage("Video Games"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "emailIsEmpty":
            MessageLookupByLibrary.simpleMessage("Please, enter Your e-mail"),
        "grCrAddNewMembers":
            MessageLookupByLibrary.simpleMessage("Add new members"),
        "grCrContContentIsTooShort":
            MessageLookupByLibrary.simpleMessage("Please, expand your topic"),
        "grCrContEditLabel":
            MessageLookupByLibrary.simpleMessage("Edit content"),
        "grCrContLabelOfNewDiscussion":
            MessageLookupByLibrary.simpleMessage("Content of discussion"),
        "grCrContNewDiscussionHelper": MessageLookupByLibrary.simpleMessage(
            "Should be at least couple of words"),
        "grCrContNoContent": MessageLookupByLibrary.simpleMessage(
            "Please enter dicsussion content"),
        "grCrDiscussButton": MessageLookupByLibrary.simpleMessage("Discuss"),
        "grCrFutureParticipants": MessageLookupByLibrary.simpleMessage(
            "You may add future participants below:"),
        "grCrMessageOfDifinedCat": m1,
        "grCrNewDiscussionInThisCat": m2,
        "grCrNewDiscussionTitle":
            MessageLookupByLibrary.simpleMessage("Create new discussion"),
        "grCrNickNameHint": MessageLookupByLibrary.simpleMessage("@nickname"),
        "grCrNickNameNoAt": MessageLookupByLibrary.simpleMessage(
            "Please enter nickname starting with @"),
        "grCrNoCategorySelected":
            MessageLookupByLibrary.simpleMessage("Please select category"),
        "grCrSaveChanges": MessageLookupByLibrary.simpleMessage("Save changes"),
        "grCrSelectCat": MessageLookupByLibrary.simpleMessage(
            "Please, select category for future discussion below:"),
        "grCrSelectCatHintText":
            MessageLookupByLibrary.simpleMessage("Select category"),
        "grCrTopicEditLabel":
            MessageLookupByLibrary.simpleMessage("Edit theme"),
        "grCrTopicHelperText": MessageLookupByLibrary.simpleMessage(
            "Enter main idea of this discussion. Press lock icon to make discussion private"),
        "grCrTopicIsEmpty": MessageLookupByLibrary.simpleMessage(
            "Please enter discussion topic!"),
        "grCrTopicIsTooShort":
            MessageLookupByLibrary.simpleMessage("Please be more specific"),
        "grCrTopicNewLabel":
            MessageLookupByLibrary.simpleMessage("Topic of discussion"),
        "grCrUserAlreadySelected": MessageLookupByLibrary.simpleMessage(
            "This user is already selected"),
        "grCreditingPageTitle":
            MessageLookupByLibrary.simpleMessage("Editing Page"),
        "homeNoRooms": MessageLookupByLibrary.simpleMessage(
            "There are no rooms in this category.\nBe very first and start new discussion!"),
        "homePageTitle": m3,
        "language": MessageLookupByLibrary.simpleMessage("English"),
        "memPageButtonCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "memPageButtonSave": MessageLookupByLibrary.simpleMessage("Save"),
        "memPageLabelAdmins": MessageLookupByLibrary.simpleMessage("Admins"),
        "memPageLabelBanned":
            MessageLookupByLibrary.simpleMessage("Banned users:"),
        "memPageLabelCreator": MessageLookupByLibrary.simpleMessage("Creator"),
        "memPageLabelMembers": MessageLookupByLibrary.simpleMessage("Members"),
        "memPageLabelReqs":
            MessageLookupByLibrary.simpleMessage("Join Requests"),
        "memPageTitle": MessageLookupByLibrary.simpleMessage("Chat Members"),
        "memTilesActionAccept": MessageLookupByLibrary.simpleMessage("Accept"),
        "memTilesActionBan": MessageLookupByLibrary.simpleMessage("Ban"),
        "memTilesActionCantWrite":
            MessageLookupByLibrary.simpleMessage("Can`t write"),
        "memTilesActionDecline":
            MessageLookupByLibrary.simpleMessage("Decline"),
        "memTilesActionDemote": MessageLookupByLibrary.simpleMessage("Demote"),
        "memTilesActionKick": MessageLookupByLibrary.simpleMessage("Kick"),
        "memTilesActionPromote":
            MessageLookupByLibrary.simpleMessage("Promote"),
        "memTilesActionUnban": MessageLookupByLibrary.simpleMessage("Unban"),
        "memTilesDelete": MessageLookupByLibrary.simpleMessage("Delete"),
        "memTilesDeleteWarning":
            MessageLookupByLibrary.simpleMessage("Delete this room?"),
        "memTilesLeave": MessageLookupByLibrary.simpleMessage("Leave"),
        "memTilesLeaveWarning":
            MessageLookupByLibrary.simpleMessage("Leave this room?"),
        "nickNameIsTaken": MessageLookupByLibrary.simpleMessage(
            "This username is already taken :("),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordIsIncorrect":
            MessageLookupByLibrary.simpleMessage("Please, enter password"),
        "passwordIsTooShort":
            MessageLookupByLibrary.simpleMessage("Enter password 6+ long"),
        "regEmail": MessageLookupByLibrary.simpleMessage("Enter your e-mail"),
        "regEmailIsEmpty":
            MessageLookupByLibrary.simpleMessage("Enter an email adress"),
        "regEmailNoAt":
            MessageLookupByLibrary.simpleMessage("Please enter valid email"),
        "regNameHelper": MessageLookupByLibrary.simpleMessage(
            "It should be at least 2 characters long"),
        "regNameLabel":
            MessageLookupByLibrary.simpleMessage("What is your name?"),
        "regNameMissing":
            MessageLookupByLibrary.simpleMessage("Please, enter Your name"),
        "regNameTooShort":
            MessageLookupByLibrary.simpleMessage("Name is too short"),
        "regNickNameHelper":
            MessageLookupByLibrary.simpleMessage("It should start with @"),
        "regNickNameLabel":
            MessageLookupByLibrary.simpleMessage("Enter your nickname"),
        "regNickNameNoAt": MessageLookupByLibrary.simpleMessage(
            "please enter nickname starting with @"),
        "regNickNameTooShort": MessageLookupByLibrary.simpleMessage(
            "Nickname should be at least 4 characters long"),
        "regPassword": MessageLookupByLibrary.simpleMessage("Create password"),
        "regPasswordHelper": MessageLookupByLibrary.simpleMessage(
            "It should be at least 6 chatacters long"),
        "regPasswordIsTooShort":
            MessageLookupByLibrary.simpleMessage("Enter an password 6+ long"),
        "regRegister": MessageLookupByLibrary.simpleMessage("Register"),
        "regYouAreNotNew": MessageLookupByLibrary.simpleMessage(
            "Already have an account? Sign in"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In")
      };
}
