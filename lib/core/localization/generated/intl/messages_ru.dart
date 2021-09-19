// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(name) =>
      "Что ж, ${name}, кажется вы не можете здесь писать. Отправьте запрос.";

  static String m1(category) =>
      "Вы создаете новон обсуждение в категории${category} ";

  static String m2(category) => "Новое обсуждение в категории ${category} ";

  static String m3(category) => "Комнаты категории ${category}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "areYouNew": MessageLookupByLibrary.simpleMessage(
            "Вы новичок в DisCuss? Зарегестрируйтесь"),
        "catsPage": MessageLookupByLibrary.simpleMessage("Выберите категорию"),
        "chatPageBodyMessageBanned": MessageLookupByLibrary.simpleMessage(
            "Вы были забанены в этом обсуждении"),
        "chatPageBodyMessageEmptyChat":
            MessageLookupByLibrary.simpleMessage("уууупс... Так пусто!"),
        "chatPageBodyMessageNotMember": MessageLookupByLibrary.simpleMessage(
            "Вы ещё не участник этого обсуждения"),
        "chatPageBodyMessageRequestDev":
            MessageLookupByLibrary.simpleMessage("Ваш запрос рассматривается"),
        "chatPageSnackForOpenRoom": MessageLookupByLibrary.simpleMessage(
            "Нажите + чтобы вступить в обсуждение и отправлять сообщения"),
        "chatPageSnackForPerm": m0,
        "chatPageSnackJoinedRoom": MessageLookupByLibrary.simpleMessage(
            "Вы вступили в это обсуждение"),
        "chatPageSnackSentRequest": MessageLookupByLibrary.simpleMessage(
            "Запрос на вступление отправлен"),
        "dbCatsAstrology": MessageLookupByLibrary.simpleMessage("Астрология"),
        "dbCatsBelgiumCrysis":
            MessageLookupByLibrary.simpleMessage("Бельгийский кризис"),
        "dbCatsCats": MessageLookupByLibrary.simpleMessage("Кошки"),
        "dbCatsClothes": MessageLookupByLibrary.simpleMessage("Шмотки"),
        "dbCatsGlobalWarming":
            MessageLookupByLibrary.simpleMessage("Глобальное потепление"),
        "dbCatsHike": MessageLookupByLibrary.simpleMessage("Пеший туризм"),
        "dbCatsLiterature": MessageLookupByLibrary.simpleMessage("Литература"),
        "dbCatsPhysics": MessageLookupByLibrary.simpleMessage("Физика"),
        "dbCatsPolitics": MessageLookupByLibrary.simpleMessage("Политика"),
        "dbCatsPsychologies":
            MessageLookupByLibrary.simpleMessage("Психология"),
        "dbCatsRenissans": MessageLookupByLibrary.simpleMessage("Ренессанс"),
        "dbCatsRock": MessageLookupByLibrary.simpleMessage("Рок-н-ролл"),
        "dbCatsSport": MessageLookupByLibrary.simpleMessage("Спорт"),
        "dbCatsStarWars":
            MessageLookupByLibrary.simpleMessage("Звёздные войны"),
        "dbCatsVideoGames": MessageLookupByLibrary.simpleMessage("Видеоигры"),
        "email": MessageLookupByLibrary.simpleMessage("Эл. почта"),
        "emailIsEmpty": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите вашу эл. почту"),
        "grCrAddNewMembers":
            MessageLookupByLibrary.simpleMessage("Добавить новых участников"),
        "grCrContContentIsTooShort":
            MessageLookupByLibrary.simpleMessage("Пожалуйста, раскройте тему"),
        "grCrContEditLabel":
            MessageLookupByLibrary.simpleMessage("Редактировать контент"),
        "grCrContLabelOfNewDiscussion":
            MessageLookupByLibrary.simpleMessage("Контент обсуждения"),
        "grCrContNewDiscussionHelper": MessageLookupByLibrary.simpleMessage(
            "Должно быть пару слов как минимум"),
        "grCrContNoContent": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, укажите контент будущего обсуждения"),
        "grCrDiscussButton": MessageLookupByLibrary.simpleMessage("Обсудить"),
        "grCrFutureParticipants": MessageLookupByLibrary.simpleMessage(
            "Вы можете добавить будущих участников ниже:"),
        "grCrMessageOfDifinedCat": m1,
        "grCrNewDiscussionInThisCat": m2,
        "grCrNewDiscussionTitle":
            MessageLookupByLibrary.simpleMessage("Создать новое обсуждение"),
        "grCrNickNameHint": MessageLookupByLibrary.simpleMessage("@nickname"),
        "grCrNickNameNoAt": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите никнейм, начиная с @"),
        "grCrNoCategorySelected": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, выберите категорию"),
        "grCrSaveChanges":
            MessageLookupByLibrary.simpleMessage("Сохранить изменения"),
        "grCrSelectCat": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, выберите категорию будущего обсуждения ниже:"),
        "grCrSelectCatHintText":
            MessageLookupByLibrary.simpleMessage("Выберите категорию"),
        "grCrTopicEditLabel":
            MessageLookupByLibrary.simpleMessage("Редактировать тему"),
        "grCrTopicHelperText": MessageLookupByLibrary.simpleMessage(
            "Введите главную идею обсуждения. Нажмите иконку замка, чтобы сделать обсуждение приватным"),
        "grCrTopicIsEmpty": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите тему обсуждения!"),
        "grCrTopicIsTooShort":
            MessageLookupByLibrary.simpleMessage("Тема слишком короткая"),
        "grCrTopicNewLabel":
            MessageLookupByLibrary.simpleMessage("Тема обсуждения"),
        "grCrUserAlreadySelected": MessageLookupByLibrary.simpleMessage(
            "Этот пользователь уже выбран"),
        "grCreditingPageTitle":
            MessageLookupByLibrary.simpleMessage("Страница редактирования"),
        "homeNoRooms": MessageLookupByLibrary.simpleMessage(
            "В этой категории нет комнат.\nБудь самым первым, и начни обсуждение!"),
        "homePageTitle": m3,
        "memPageButtonCancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "memPageButtonSave": MessageLookupByLibrary.simpleMessage("Сохранить"),
        "memPageLabelAdmins":
            MessageLookupByLibrary.simpleMessage("Модераторы"),
        "memPageLabelBanned":
            MessageLookupByLibrary.simpleMessage("Забаненные пользователи:"),
        "memPageLabelCreator":
            MessageLookupByLibrary.simpleMessage("Создатель"),
        "memPageLabelMembers":
            MessageLookupByLibrary.simpleMessage("Участники"),
        "memPageLabelReqs":
            MessageLookupByLibrary.simpleMessage("Запросы на вступление"),
        "memPageTitle": MessageLookupByLibrary.simpleMessage("Участники чата"),
        "memTilesActionAccept": MessageLookupByLibrary.simpleMessage("Принять"),
        "memTilesActionBan": MessageLookupByLibrary.simpleMessage("Забанить"),
        "memTilesActionCantWrite":
            MessageLookupByLibrary.simpleMessage("Заглушить пользователя"),
        "memTilesActionDecline":
            MessageLookupByLibrary.simpleMessage("Отклонить"),
        "memTilesActionDemote":
            MessageLookupByLibrary.simpleMessage("Понизить"),
        "memTilesActionKick": MessageLookupByLibrary.simpleMessage("Выгнать"),
        "memTilesActionPromote":
            MessageLookupByLibrary.simpleMessage("Повысить"),
        "memTilesActionUnban":
            MessageLookupByLibrary.simpleMessage("Разбанить"),
        "memTilesDelete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "memTilesDeleteWarning":
            MessageLookupByLibrary.simpleMessage("Удалить комнату?"),
        "memTilesLeave": MessageLookupByLibrary.simpleMessage("Выйти"),
        "memTilesLeaveWarning":
            MessageLookupByLibrary.simpleMessage("Покинуть эту комнату?"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "passwordIsIncorrect":
            MessageLookupByLibrary.simpleMessage("Пожалуйста, введите пароль"),
        "passwordIsTooShort": MessageLookupByLibrary.simpleMessage(
            "Пароль должен быть длиннее 6 символов"),
        "regEmail":
            MessageLookupByLibrary.simpleMessage("Введите вашу эл. почту"),
        "regEmailIsEmpty":
            MessageLookupByLibrary.simpleMessage("Укажите вашу эл. почту"),
        "regEmailNoAt": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста укажите существующий адрес эл. почты"),
        "regNameHelper": MessageLookupByLibrary.simpleMessage(
            "Имя должно быть длиной минимум два знака"),
        "regNameLabel": MessageLookupByLibrary.simpleMessage("Как вас зовут?"),
        "regNameMissing": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, укажите ваше имя"),
        "regNameTooShort":
            MessageLookupByLibrary.simpleMessage("Имя слишком короткое"),
        "regNickNameHelper":
            MessageLookupByLibrary.simpleMessage("Он должен начинаться с @"),
        "regNickNameLabel":
            MessageLookupByLibrary.simpleMessage("Введите ваш никнейм"),
        "regNickNameNoAt": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите ваш никнейм, начиная с @"),
        "regNickNameTooShort": MessageLookupByLibrary.simpleMessage(
            "Никнейм должен состоять из четырех символов как минимум"),
        "regPassword":
            MessageLookupByLibrary.simpleMessage("Придумайте пароль"),
        "regPasswordHelper": MessageLookupByLibrary.simpleMessage(
            "Он должен быть длиной как минимум 6 символов"),
        "regPasswordIsTooShort":
            MessageLookupByLibrary.simpleMessage("Пароль слишком короткий"),
        "regRegister":
            MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
        "regYouAreNotNew":
            MessageLookupByLibrary.simpleMessage("Уже есть аккаунт? Войдите"),
        "signIn": MessageLookupByLibrary.simpleMessage("Войти")
      };
}
