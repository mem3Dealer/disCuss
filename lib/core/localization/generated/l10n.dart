// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class I10n {
  I10n();

  static I10n? _current;

  static I10n get current {
    assert(_current != null,
        'No instance of I10n was loaded. Try to initialize the I10n delegate before accessing I10n.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<I10n> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = I10n();
      I10n._current = instance;

      return instance;
    });
  }

  static I10n of(BuildContext context) {
    final instance = I10n.maybeOf(context);
    assert(instance != null,
        'No instance of I10n present in the widget tree. Did you add I10n.delegate in localizationsDelegates?');
    return instance!;
  }

  static I10n? maybeOf(BuildContext context) {
    return Localizations.of<I10n>(context, I10n);
  }

  /// `English`
  String get language {
    return Intl.message(
      'English',
      name: 'language',
      desc: 'The default langauage',
      args: [],
    );
  }

  /// `New to DisCuss? Register`
  String get areYouNew {
    return Intl.message(
      'New to DisCuss? Register',
      name: 'areYouNew',
      desc: 'are you new?',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Password label',
      args: [],
    );
  }

  /// `Please, enter password`
  String get passwordIsIncorrect {
    return Intl.message(
      'Please, enter password',
      name: 'passwordIsIncorrect',
      desc: 'Message when password is not correct',
      args: [],
    );
  }

  /// `Enter password 6+ long`
  String get passwordIsTooShort {
    return Intl.message(
      'Enter password 6+ long',
      name: 'passwordIsTooShort',
      desc: 'Message when password is too short',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: 'Sign in button',
      args: [],
    );
  }

  /// `E-mail`
  String get email {
    return Intl.message(
      'E-mail',
      name: 'email',
      desc: 'email label',
      args: [],
    );
  }

  /// `Please, enter Your e-mail`
  String get emailIsEmpty {
    return Intl.message(
      'Please, enter Your e-mail',
      name: 'emailIsEmpty',
      desc: 'email is missing',
      args: [],
    );
  }

  /// `What is your name?`
  String get regNameLabel {
    return Intl.message(
      'What is your name?',
      name: 'regNameLabel',
      desc: 'Label for name text form field',
      args: [],
    );
  }

  /// `It should be at least 2 characters long`
  String get regNameHelper {
    return Intl.message(
      'It should be at least 2 characters long',
      name: 'regNameHelper',
      desc: 'Helper for name text form field',
      args: [],
    );
  }

  /// `Please, enter Your name`
  String get regNameMissing {
    return Intl.message(
      'Please, enter Your name',
      name: 'regNameMissing',
      desc: 'Error message when name is missing',
      args: [],
    );
  }

  /// `Name is too short`
  String get regNameTooShort {
    return Intl.message(
      'Name is too short',
      name: 'regNameTooShort',
      desc: 'Error message when name is too short',
      args: [],
    );
  }

  /// `Enter your nickname`
  String get regNickNameLabel {
    return Intl.message(
      'Enter your nickname',
      name: 'regNickNameLabel',
      desc: 'Label text for nickname text form field',
      args: [],
    );
  }

  /// `It should start with @`
  String get regNickNameHelper {
    return Intl.message(
      'It should start with @',
      name: 'regNickNameHelper',
      desc: 'Helper text for this...',
      args: [],
    );
  }

  /// `please enter nickname starting with @`
  String get regNickNameNoAt {
    return Intl.message(
      'please enter nickname starting with @',
      name: 'regNickNameNoAt',
      desc: 'Error message when there is no @',
      args: [],
    );
  }

  /// `Nickname should be at least 4 characters long`
  String get regNickNameTooShort {
    return Intl.message(
      'Nickname should be at least 4 characters long',
      name: 'regNickNameTooShort',
      desc: 'Error message when nick is too short',
      args: [],
    );
  }

  /// `Enter your e-mail`
  String get regEmail {
    return Intl.message(
      'Enter your e-mail',
      name: 'regEmail',
      desc: 'label email text',
      args: [],
    );
  }

  /// `Enter an email adress`
  String get regEmailIsEmpty {
    return Intl.message(
      'Enter an email adress',
      name: 'regEmailIsEmpty',
      desc: 'Error message when email is missing',
      args: [],
    );
  }

  /// `Please enter valid email`
  String get regEmailNoAt {
    return Intl.message(
      'Please enter valid email',
      name: 'regEmailNoAt',
      desc: 'Error message when there is no @',
      args: [],
    );
  }

  /// `Create password`
  String get regPassword {
    return Intl.message(
      'Create password',
      name: 'regPassword',
      desc: 'Error message when password is too short',
      args: [],
    );
  }

  /// `It should be at least 6 chatacters long`
  String get regPasswordHelper {
    return Intl.message(
      'It should be at least 6 chatacters long',
      name: 'regPasswordHelper',
      desc: 'helper for password',
      args: [],
    );
  }

  /// `Enter an password 6+ long`
  String get regPasswordIsTooShort {
    return Intl.message(
      'Enter an password 6+ long',
      name: 'regPasswordIsTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? Sign in`
  String get regYouAreNotNew {
    return Intl.message(
      'Already have an account? Sign in',
      name: 'regYouAreNotNew',
      desc: 'Text for sign in',
      args: [],
    );
  }

  /// `Register`
  String get regRegister {
    return Intl.message(
      'Register',
      name: 'regRegister',
      desc: 'Register button',
      args: [],
    );
  }

  /// `Editing Page`
  String get grCreditingPageTitle {
    return Intl.message(
      'Editing Page',
      name: 'grCreditingPageTitle',
      desc: 'title for this page',
      args: [],
    );
  }

  /// `Create new discussion`
  String get grCrNewDiscussionTitle {
    return Intl.message(
      'Create new discussion',
      name: 'grCrNewDiscussionTitle',
      desc: 'title for this page',
      args: [],
    );
  }

  /// `New {category} discussion`
  String grCrNewDiscussionInThisCat(Object category) {
    return Intl.message(
      'New $category discussion',
      name: 'grCrNewDiscussionInThisCat',
      desc: 'title for this page with category',
      args: [category],
    );
  }

  /// `You are creating new discussion in {category} category.`
  String grCrMessageOfDifinedCat(Object category) {
    return Intl.message(
      'You are creating new discussion in $category category.',
      name: 'grCrMessageOfDifinedCat',
      desc: 'message when category is defined',
      args: [category],
    );
  }

  /// `Please, select category for future discussion below:`
  String get grCrSelectCat {
    return Intl.message(
      'Please, select category for future discussion below:',
      name: 'grCrSelectCat',
      desc: 'Suggestion to pick a category',
      args: [],
    );
  }

  /// `Add new members`
  String get grCrAddNewMembers {
    return Intl.message(
      'Add new members',
      name: 'grCrAddNewMembers',
      desc: 'adding new members',
      args: [],
    );
  }

  /// `You may add future participants below:`
  String get grCrFutureParticipants {
    return Intl.message(
      'You may add future participants below:',
      name: 'grCrFutureParticipants',
      desc: 'Adding first members',
      args: [],
    );
  }

  /// `This user is already selected`
  String get grCrUserAlreadySelected {
    return Intl.message(
      'This user is already selected',
      name: 'grCrUserAlreadySelected',
      desc: 'message when user is alerady selected',
      args: [],
    );
  }

  /// `@nickname`
  String get grCrNickNameHint {
    return Intl.message(
      '@nickname',
      name: 'grCrNickNameHint',
      desc: 'Nickname hint here',
      args: [],
    );
  }

  /// `Please enter nickname starting with @`
  String get grCrNickNameNoAt {
    return Intl.message(
      'Please enter nickname starting with @',
      name: 'grCrNickNameNoAt',
      desc: 'Nickname has no @',
      args: [],
    );
  }

  /// `Please select category`
  String get grCrNoCategorySelected {
    return Intl.message(
      'Please select category',
      name: 'grCrNoCategorySelected',
      desc: 'when category is null',
      args: [],
    );
  }

  /// `Select category`
  String get grCrSelectCatHintText {
    return Intl.message(
      'Select category',
      name: 'grCrSelectCatHintText',
      desc: 'hint text for cat selection ',
      args: [],
    );
  }

  /// `Save changes`
  String get grCrSaveChanges {
    return Intl.message(
      'Save changes',
      name: 'grCrSaveChanges',
      desc: 'button text saving changes',
      args: [],
    );
  }

  /// `Discuss`
  String get grCrDiscussButton {
    return Intl.message(
      'Discuss',
      name: 'grCrDiscussButton',
      desc: 'button text discuss',
      args: [],
    );
  }

  /// `Edit content`
  String get grCrContEditLabel {
    return Intl.message(
      'Edit content',
      name: 'grCrContEditLabel',
      desc: 'Label editing content',
      args: [],
    );
  }

  /// `Please enter dicsussion content`
  String get grCrContNoContent {
    return Intl.message(
      'Please enter dicsussion content',
      name: 'grCrContNoContent',
      desc: 'Error message when there is no content',
      args: [],
    );
  }

  /// `Please, expand your topic`
  String get grCrContContentIsTooShort {
    return Intl.message(
      'Please, expand your topic',
      name: 'grCrContContentIsTooShort',
      desc: 'Content is too short',
      args: [],
    );
  }

  /// `Content of discussion`
  String get grCrContLabelOfNewDiscussion {
    return Intl.message(
      'Content of discussion',
      name: 'grCrContLabelOfNewDiscussion',
      desc: 'Label new discussion',
      args: [],
    );
  }

  /// `Should be at least couple of words`
  String get grCrContNewDiscussionHelper {
    return Intl.message(
      'Should be at least couple of words',
      name: 'grCrContNewDiscussionHelper',
      desc: 'helper',
      args: [],
    );
  }

  /// `Please enter discussion topic!`
  String get grCrTopicIsEmpty {
    return Intl.message(
      'Please enter discussion topic!',
      name: 'grCrTopicIsEmpty',
      desc: 'No topic :(',
      args: [],
    );
  }

  /// `Please be more specific`
  String get grCrTopicIsTooShort {
    return Intl.message(
      'Please be more specific',
      name: 'grCrTopicIsTooShort',
      desc: 'topic is too short',
      args: [],
    );
  }

  /// `Edit theme`
  String get grCrTopicEditLabel {
    return Intl.message(
      'Edit theme',
      name: 'grCrTopicEditLabel',
      desc: 'label for editing topic',
      args: [],
    );
  }

  /// `Topic of discussion`
  String get grCrTopicNewLabel {
    return Intl.message(
      'Topic of discussion',
      name: 'grCrTopicNewLabel',
      desc: 'label for new topic',
      args: [],
    );
  }

  /// `Enter main idea of this discussion. Press lock icon to make discussion private`
  String get grCrTopicHelperText {
    return Intl.message(
      'Enter main idea of this discussion. Press lock icon to make discussion private',
      name: 'grCrTopicHelperText',
      desc: 'this badass helper',
      args: [],
    );
  }

  /// `{category} rooms`
  String homePageTitle(Object category) {
    return Intl.message(
      '$category rooms',
      name: 'homePageTitle',
      desc: 'title for this page',
      args: [category],
    );
  }

  /// `There are no rooms in this category.\nBe very first and start new discussion!`
  String get homeNoRooms {
    return Intl.message(
      'There are no rooms in this category.\nBe very first and start new discussion!',
      name: 'homeNoRooms',
      desc: 'message when there is no rooms',
      args: [],
    );
  }

  /// `Chat Members`
  String get memPageTitle {
    return Intl.message(
      'Chat Members',
      name: 'memPageTitle',
      desc: 'title for this page',
      args: [],
    );
  }

  /// `Creator`
  String get memPageLabelCreator {
    return Intl.message(
      'Creator',
      name: 'memPageLabelCreator',
      desc: 'Creator label',
      args: [],
    );
  }

  /// `Admins`
  String get memPageLabelAdmins {
    return Intl.message(
      'Admins',
      name: 'memPageLabelAdmins',
      desc: 'Admins label',
      args: [],
    );
  }

  /// `Members`
  String get memPageLabelMembers {
    return Intl.message(
      'Members',
      name: 'memPageLabelMembers',
      desc: 'Members label',
      args: [],
    );
  }

  /// `Join Requests`
  String get memPageLabelReqs {
    return Intl.message(
      'Join Requests',
      name: 'memPageLabelReqs',
      desc: 'Join Requests label',
      args: [],
    );
  }

  /// `Banned users:`
  String get memPageLabelBanned {
    return Intl.message(
      'Banned users:',
      name: 'memPageLabelBanned',
      desc: 'Banned users label',
      args: [],
    );
  }

  /// `Save`
  String get memPageButtonSave {
    return Intl.message(
      'Save',
      name: 'memPageButtonSave',
      desc: 'save button',
      args: [],
    );
  }

  /// `Cancel`
  String get memPageButtonCancel {
    return Intl.message(
      'Cancel',
      name: 'memPageButtonCancel',
      desc: 'Cancel button',
      args: [],
    );
  }

  /// `Delete this room?`
  String get memTilesDeleteWarning {
    return Intl.message(
      'Delete this room?',
      name: 'memTilesDeleteWarning',
      desc: 'warning before deleting',
      args: [],
    );
  }

  /// `Delete`
  String get memTilesDelete {
    return Intl.message(
      'Delete',
      name: 'memTilesDelete',
      desc: 'deleting button',
      args: [],
    );
  }

  /// `Leave this room?`
  String get memTilesLeaveWarning {
    return Intl.message(
      'Leave this room?',
      name: 'memTilesLeaveWarning',
      desc: 'warning before leaving',
      args: [],
    );
  }

  /// `Leave`
  String get memTilesLeave {
    return Intl.message(
      'Leave',
      name: 'memTilesLeave',
      desc: 'Leaving button',
      args: [],
    );
  }

  /// `Kick`
  String get memTilesActionKick {
    return Intl.message(
      'Kick',
      name: 'memTilesActionKick',
      desc: 'kicking user',
      args: [],
    );
  }

  /// `Ban`
  String get memTilesActionBan {
    return Intl.message(
      'Ban',
      name: 'memTilesActionBan',
      desc: 'Banning user',
      args: [],
    );
  }

  /// `Demote`
  String get memTilesActionDemote {
    return Intl.message(
      'Demote',
      name: 'memTilesActionDemote',
      desc: 'Demoting user',
      args: [],
    );
  }

  /// `Promote`
  String get memTilesActionPromote {
    return Intl.message(
      'Promote',
      name: 'memTilesActionPromote',
      desc: 'Promoting user',
      args: [],
    );
  }

  /// `Can't write`
  String get memTilesActionCantWrite {
    return Intl.message(
      'Can`t write',
      name: 'memTilesActionCantWrite',
      desc: 'takig right to write',
      args: [],
    );
  }

  /// `Accept`
  String get memTilesActionAccept {
    return Intl.message(
      'Accept',
      name: 'memTilesActionAccept',
      desc: 'accepcting join Requests',
      args: [],
    );
  }

  /// `Decline`
  String get memTilesActionDecline {
    return Intl.message(
      'Decline',
      name: 'memTilesActionDecline',
      desc: 'declining join Requests',
      args: [],
    );
  }

  /// `Unban`
  String get memTilesActionUnban {
    return Intl.message(
      'Unban',
      name: 'memTilesActionUnban',
      desc: 'unbanning join Requests',
      args: [],
    );
  }

  /// `Well, {name}, you can't write here. Go ask for perm.`
  String chatPageSnackForPerm(Object name) {
    return Intl.message(
      'Well, $name, you can`t write here. Go ask for perm.',
      name: 'chatPageSnackForPerm',
      desc: 'Snack bar text asking to ask perm',
      args: [name],
    );
  }

  /// `Hit + to join this room and be able to send messages`
  String get chatPageSnackForOpenRoom {
    return Intl.message(
      'Hit + to join this room and be able to send messages',
      name: 'chatPageSnackForOpenRoom',
      desc: 'snack for open room',
      args: [],
    );
  }

  /// `Join reqeust sent. Fingers crossed`
  String get chatPageSnackSentRequest {
    return Intl.message(
      'Join reqeust sent. Fingers crossed',
      name: 'chatPageSnackSentRequest',
      desc: 'snack for sent request',
      args: [],
    );
  }

  /// `You have joined this room. Be nice!`
  String get chatPageSnackJoinedRoom {
    return Intl.message(
      'You have joined this room. Be nice!',
      name: 'chatPageSnackJoinedRoom',
      desc: 'snack for joined room',
      args: [],
    );
  }

  /// `You were banned from this discussion`
  String get chatPageBodyMessageBanned {
    return Intl.message(
      'You were banned from this discussion',
      name: 'chatPageBodyMessageBanned',
      desc: 'body message for banned user',
      args: [],
    );
  }

  /// `You are not yet member of this group`
  String get chatPageBodyMessageNotMember {
    return Intl.message(
      'You are not yet member of this group',
      name: 'chatPageBodyMessageNotMember',
      desc: 'body message for user not being yet member',
      args: [],
    );
  }

  /// `Your request is under develeopement`
  String get chatPageBodyMessageRequestDev {
    return Intl.message(
      'Your request is under develeopement',
      name: 'chatPageBodyMessageRequestDev',
      desc: 'body message request develeopement',
      args: [],
    );
  }

  /// `ooops... Such empty!`
  String get chatPageBodyMessageEmptyChat {
    return Intl.message(
      'ooops... Such empty!',
      name: 'chatPageBodyMessageEmptyChat',
      desc: 'body message for empty chat',
      args: [],
    );
  }

  /// `Sport`
  String get dbCatsSport {
    return Intl.message(
      'Sport',
      name: 'dbCatsSport',
      desc: 'Sport category',
      args: [],
    );
  }

  /// `Video Games`
  String get dbCatsVideoGames {
    return Intl.message(
      'Video Games',
      name: 'dbCatsVideoGames',
      desc: 'Video Games category',
      args: [],
    );
  }

  /// `Literature`
  String get dbCatsLiterature {
    return Intl.message(
      'Literature',
      name: 'dbCatsLiterature',
      desc: 'Literature category',
      args: [],
    );
  }

  /// `Rock'n'Roll`
  String get dbCatsRock {
    return Intl.message(
      'Rock`n`Roll',
      name: 'dbCatsRock',
      desc: 'Rock`n`Roll category',
      args: [],
    );
  }

  /// `Physics`
  String get dbCatsPhysics {
    return Intl.message(
      'Physics',
      name: 'dbCatsPhysics',
      desc: 'Physics category',
      args: [],
    );
  }

  /// `Renissans`
  String get dbCatsRenissans {
    return Intl.message(
      'Renissans',
      name: 'dbCatsRenissans',
      desc: 'Renissans category',
      args: [],
    );
  }

  /// `Star Wars`
  String get dbCatsStarWars {
    return Intl.message(
      'Star Wars',
      name: 'dbCatsStarWars',
      desc: 'Star Wars category',
      args: [],
    );
  }

  /// `Hike`
  String get dbCatsHike {
    return Intl.message(
      'Hike',
      name: 'dbCatsHike',
      desc: 'Hike category',
      args: [],
    );
  }

  /// `Politics`
  String get dbCatsPolitics {
    return Intl.message(
      'Politics',
      name: 'dbCatsPolitics',
      desc: 'Politics category',
      args: [],
    );
  }

  /// `Global Warming`
  String get dbCatsGlobalWarming {
    return Intl.message(
      'Global Warming',
      name: 'dbCatsGlobalWarming',
      desc: 'Global Warming category',
      args: [],
    );
  }

  /// `Belgium Crysis`
  String get dbCatsBelgiumCrysis {
    return Intl.message(
      'Belgium Crysis',
      name: 'dbCatsBelgiumCrysis',
      desc: 'Belgium Crysis category',
      args: [],
    );
  }

  /// `Clothes`
  String get dbCatsClothes {
    return Intl.message(
      'Clothes',
      name: 'dbCatsClothes',
      desc: 'Clothes category',
      args: [],
    );
  }

  /// `Psychologies`
  String get dbCatsPsychologies {
    return Intl.message(
      'Psychologies',
      name: 'dbCatsPsychologies',
      desc: 'Psychologies category',
      args: [],
    );
  }

  /// `Astrology`
  String get dbCatsAstrology {
    return Intl.message(
      'Astrology',
      name: 'dbCatsAstrology',
      desc: 'Astrology category',
      args: [],
    );
  }

  /// `Cats`
  String get dbCatsCats {
    return Intl.message(
      'Cats',
      name: 'dbCatsCats',
      desc: 'Cats category',
      args: [],
    );
  }

  /// `Select category`
  String get catsPage {
    return Intl.message(
      'Select category',
      name: 'catsPage',
      desc: ' title for this page',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<I10n> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<I10n> load(Locale locale) => I10n.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
