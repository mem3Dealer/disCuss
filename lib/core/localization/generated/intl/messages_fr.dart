// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(name) =>
      "Eh bien, ${name}, vous ne pouvez pas écrire ici. Allez demander une perm.";

  static String m1(category) =>
      "Vous créez une nouvelle discussion dans la catégorie ${category}.";

  static String m2(category) => "Nouvelle discussion ${category}";

  static String m3(category) => "${category} chambres";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "areYouNew": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous nouveau sur DisCuss ? S\'inscrire"),
        "catsPage":
            MessageLookupByLibrary.simpleMessage("Sélectionnez une catégorie"),
        "chatPageBodyMessageBanned": MessageLookupByLibrary.simpleMessage(
            "Vous avez été banni de cette discussion"),
        "chatPageBodyMessageEmptyChat":
            MessageLookupByLibrary.simpleMessage("ooops... Tellement vide!"),
        "chatPageBodyMessageNotMember": MessageLookupByLibrary.simpleMessage(
            "Vous n\'êtes pas encore membre de ce groupe"),
        "chatPageBodyMessageRequestDev": MessageLookupByLibrary.simpleMessage(
            "Votre demande est en cours de développement"),
        "chatPageSnackForOpenRoom": MessageLookupByLibrary.simpleMessage(
            "Appuyez sur + pour rejoindre cette salle et pouvoir envoyer des messages"),
        "chatPageSnackForPerm": m0,
        "chatPageSnackJoinedRoom": MessageLookupByLibrary.simpleMessage(
            "Vous avez rejoint cette salle. Soyez gentil!"),
        "chatPageSnackSentRequest": MessageLookupByLibrary.simpleMessage(
            "Demande d\'adhésion envoyée. Croisons les doigts"),
        "dbCatsAstrology": MessageLookupByLibrary.simpleMessage("Astrologie"),
        "dbCatsBelgiumCrysis":
            MessageLookupByLibrary.simpleMessage("Belgium Crysis"),
        "dbCatsCats": MessageLookupByLibrary.simpleMessage("Chats"),
        "dbCatsClothes": MessageLookupByLibrary.simpleMessage("Vêtements"),
        "dbCatsGlobalWarming":
            MessageLookupByLibrary.simpleMessage("Réchauffement climatique"),
        "dbCatsHike": MessageLookupByLibrary.simpleMessage("Randonnée"),
        "dbCatsLiterature": MessageLookupByLibrary.simpleMessage("Littérature"),
        "dbCatsPhysics": MessageLookupByLibrary.simpleMessage("Physique"),
        "dbCatsPolitics": MessageLookupByLibrary.simpleMessage("Politique"),
        "dbCatsPsychologies":
            MessageLookupByLibrary.simpleMessage("Psychologies"),
        "dbCatsRenissans": MessageLookupByLibrary.simpleMessage("Renissans"),
        "dbCatsRock": MessageLookupByLibrary.simpleMessage("Rock`n`Roll"),
        "dbCatsSport": MessageLookupByLibrary.simpleMessage("Sport"),
        "dbCatsStarWars": MessageLookupByLibrary.simpleMessage("Star Wars"),
        "dbCatsVideoGames": MessageLookupByLibrary.simpleMessage("Jeux vidéo"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "emailIsEmpty": MessageLookupByLibrary.simpleMessage(
            "S\'il vous plaît, entrez votre e-mail"),
        "grCrAddNewMembers":
            MessageLookupByLibrary.simpleMessage("Ajouter de nouveaux membres"),
        "grCrContContentIsTooShort": MessageLookupByLibrary.simpleMessage(
            "S\'il vous plaît, développez votre sujet"),
        "grCrContEditLabel":
            MessageLookupByLibrary.simpleMessage("Modifier le contenu"),
        "grCrContLabelOfNewDiscussion":
            MessageLookupByLibrary.simpleMessage("Contenu de la discussion"),
        "grCrContNewDiscussionHelper": MessageLookupByLibrary.simpleMessage(
            "Devrait être au moins deux mots"),
        "grCrContNoContent": MessageLookupByLibrary.simpleMessage(
            "Veuillez saisir le contenu de la discussion"),
        "grCrDiscussButton": MessageLookupByLibrary.simpleMessage("Discuter"),
        "grCrFutureParticipants": MessageLookupByLibrary.simpleMessage(
            "Vous pouvez ajouter de futurs participants ci-dessous :"),
        "grCrMessageOfDifinedCat": m1,
        "grCrNewDiscussionInThisCat": m2,
        "grCrNewDiscussionTitle": MessageLookupByLibrary.simpleMessage(
            "Créer une nouvelle discussion"),
        "grCrNickNameHint": MessageLookupByLibrary.simpleMessage("@nickname"),
        "grCrNickNameNoAt": MessageLookupByLibrary.simpleMessage(
            "Veuillez saisir le pseudonyme commençant par @"),
        "grCrNoCategorySelected": MessageLookupByLibrary.simpleMessage(
            "Veuillez sélectionner une catégorie"),
        "grCrSaveChanges": MessageLookupByLibrary.simpleMessage(
            "Enregistrer les modifications"),
        "grCrSelectCat": MessageLookupByLibrary.simpleMessage(
            "Veuillez sélectionner une catégorie pour une discussion future ci-dessous :"),
        "grCrSelectCatHintText":
            MessageLookupByLibrary.simpleMessage("Sélectionner la catégorie"),
        "grCrTopicEditLabel":
            MessageLookupByLibrary.simpleMessage("Modifier le thème"),
        "grCrTopicHelperText": MessageLookupByLibrary.simpleMessage(
            "Entrez l\'idée principale de cette discussion. Appuyez sur l\'icône de verrouillage pour rendre la discussion privée"),
        "grCrTopicIsEmpty": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer le sujet de discussion!"),
        "grCrTopicIsTooShort":
            MessageLookupByLibrary.simpleMessage("Veuillez être plus précis"),
        "grCrTopicNewLabel":
            MessageLookupByLibrary.simpleMessage("Sujet de discussion"),
        "grCrUserAlreadySelected": MessageLookupByLibrary.simpleMessage(
            "Cet utilisateur est déjà sélectionné"),
        "grCreditingPageTitle":
            MessageLookupByLibrary.simpleMessage("Page d\'édition"),
        "homeNoRooms": MessageLookupByLibrary.simpleMessage(
            "Il n\'y a pas de chambres dans cette catégorie.\nSoyez le premier et commencez une nouvelle discussion!"),
        "homePageTitle": m3,
        "memPageButtonCancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "memPageButtonSave":
            MessageLookupByLibrary.simpleMessage("Enregistrer"),
        "memPageLabelAdmins":
            MessageLookupByLibrary.simpleMessage("Administrateurs"),
        "memPageLabelBanned":
            MessageLookupByLibrary.simpleMessage("Utilisateurs interdits :"),
        "memPageLabelCreator": MessageLookupByLibrary.simpleMessage("Créateur"),
        "memPageLabelMembers": MessageLookupByLibrary.simpleMessage("Membres"),
        "memPageLabelReqs":
            MessageLookupByLibrary.simpleMessage("Demandes de jointure"),
        "memPageTitle": MessageLookupByLibrary.simpleMessage("Membres du chat"),
        "memTilesActionAccept":
            MessageLookupByLibrary.simpleMessage("Accepter"),
        "memTilesActionBan": MessageLookupByLibrary.simpleMessage("Ban"),
        "memTilesActionCantWrite":
            MessageLookupByLibrary.simpleMessage("Impossible d\'écrire"),
        "memTilesActionDecline":
            MessageLookupByLibrary.simpleMessage("Decline"),
        "memTilesActionDemote": MessageLookupByLibrary.simpleMessage("Demote"),
        "memTilesActionKick": MessageLookupByLibrary.simpleMessage("Kick"),
        "memTilesActionPromote":
            MessageLookupByLibrary.simpleMessage("Promouvoir"),
        "memTilesActionUnban": MessageLookupByLibrary.simpleMessage("Unban"),
        "memTilesDelete": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "memTilesDeleteWarning":
            MessageLookupByLibrary.simpleMessage("Supprimer cette pièce ?"),
        "memTilesLeave": MessageLookupByLibrary.simpleMessage("Quitter"),
        "memTilesLeaveWarning":
            MessageLookupByLibrary.simpleMessage("Quitter cette pièce ?"),
        "password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "passwordIsIncorrect": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer le mot de passe"),
        "passwordIsTooShort": MessageLookupByLibrary.simpleMessage(
            "Entrez un mot de passe d\'au moins six caractères"),
        "regEmail": MessageLookupByLibrary.simpleMessage("Entrez votre e-mail"),
        "regEmailIsEmpty":
            MessageLookupByLibrary.simpleMessage("Entrez une adresse e-mail"),
        "regEmailNoAt": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer une adresse e-mail valide"),
        "regNameHelper": MessageLookupByLibrary.simpleMessage(
            "Il doit contenir au moins 2 caractères"),
        "regNameLabel":
            MessageLookupByLibrary.simpleMessage("Quel est votre nom?"),
        "regNameMissing":
            MessageLookupByLibrary.simpleMessage("Veuillez entrer votre nom"),
        "regNameTooShort":
            MessageLookupByLibrary.simpleMessage("Le nom est trop court"),
        "regNickNameHelper":
            MessageLookupByLibrary.simpleMessage("Il devrait commencer par @"),
        "regNickNameLabel":
            MessageLookupByLibrary.simpleMessage("Entrez votre pseudo"),
        "regNickNameNoAt": MessageLookupByLibrary.simpleMessage(
            "veuillez saisir le pseudonyme commençant par @"),
        "regNickNameTooShort": MessageLookupByLibrary.simpleMessage(
            "Le pseudo doit comporter au moins 4 caractères"),
        "regPassword":
            MessageLookupByLibrary.simpleMessage("Créer un mot de passe"),
        "regPasswordHelper": MessageLookupByLibrary.simpleMessage(
            "Il doit contenir au moins 6 chatactères"),
        "regPasswordIsTooShort": MessageLookupByLibrary.simpleMessage(
            "Entrez un mot de passe 6+ long"),
        "regYouAreNotNew": MessageLookupByLibrary.simpleMessage(
            "Vous avez déjà un compte ? Connectez-vous"),
        "signIn": MessageLookupByLibrary.simpleMessage("s\'identifier")
      };
}
