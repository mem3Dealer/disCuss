// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(name) =>
      "Bueno, ${name}, no puedes escribir aquí. Ve a pedir la permanente";

  static String m1(category) =>
      "Está creando una nueva discusión en la categoría ${category}.";

  static String m2(category) => "Nueva discusión de ${category}";

  static String m3(category) => "{categoría} habitaciones";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "areYouNew": MessageLookupByLibrary.simpleMessage(
            "¿Eres nuevo en DisCuss? Registrarse"),
        "catsPage":
            MessageLookupByLibrary.simpleMessage("Seleccionar categoría"),
        "chatPageBodyMessageBanned": MessageLookupByLibrary.simpleMessage(
            "Se le prohibió participar en esta discusión"),
        "chatPageBodyMessageEmptyChat":
            MessageLookupByLibrary.simpleMessage("ooops... ¡Qué vacío!"),
        "chatPageBodyMessageNotMember": MessageLookupByLibrary.simpleMessage(
            "Aún no eres miembro de este grupo"),
        "chatPageBodyMessageRequestDev": MessageLookupByLibrary.simpleMessage(
            "Su solicitud está en desarrollo"),
        "chatPageSnackForOpenRoom": MessageLookupByLibrary.simpleMessage(
            "Pulsa + para unirte a esta sala y poder enviar mensajes"),
        "chatPageSnackForPerm": m0,
        "chatPageSnackJoinedRoom": MessageLookupByLibrary.simpleMessage(
            "Te has unido a esta sala. ¡Sé amable!"),
        "chatPageSnackSentRequest": MessageLookupByLibrary.simpleMessage(
            "Se ha enviado la solicitud para unirse. Crucemos los dedos"),
        "dbCatsAstrology": MessageLookupByLibrary.simpleMessage("Astrología"),
        "dbCatsBelgiumCrysis":
            MessageLookupByLibrary.simpleMessage("Bélgica Crysis"),
        "dbCatsCats": MessageLookupByLibrary.simpleMessage("Gatos"),
        "dbCatsClothes": MessageLookupByLibrary.simpleMessage("Ropa"),
        "dbCatsGlobalWarming":
            MessageLookupByLibrary.simpleMessage("Calentamiento global"),
        "dbCatsHike": MessageLookupByLibrary.simpleMessage("Caminata"),
        "dbCatsLiterature": MessageLookupByLibrary.simpleMessage("Literatura"),
        "dbCatsPhysics": MessageLookupByLibrary.simpleMessage("Física"),
        "dbCatsPolitics": MessageLookupByLibrary.simpleMessage("Política"),
        "dbCatsPsychologies":
            MessageLookupByLibrary.simpleMessage("Psicologías"),
        "dbCatsRenissans": MessageLookupByLibrary.simpleMessage("Renissans"),
        "dbCatsRock": MessageLookupByLibrary.simpleMessage("Rock`n`Roll"),
        "dbCatsSport": MessageLookupByLibrary.simpleMessage("Deporte"),
        "dbCatsStarWars": MessageLookupByLibrary.simpleMessage("Star Wars"),
        "dbCatsVideoGames": MessageLookupByLibrary.simpleMessage("Videojuegos"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "emailIsEmpty": MessageLookupByLibrary.simpleMessage(
            "Por favor introduzca su correo electrónico"),
        "grCrAddNewMembers":
            MessageLookupByLibrary.simpleMessage("Agregar nuevos miembros"),
        "grCrContContentIsTooShort":
            MessageLookupByLibrary.simpleMessage("Por favor, expanda su tema"),
        "grCrContEditLabel":
            MessageLookupByLibrary.simpleMessage("Editar contenido"),
        "grCrContLabelOfNewDiscussion":
            MessageLookupByLibrary.simpleMessage("Contenido del debate"),
        "grCrContNewDiscussionHelper": MessageLookupByLibrary.simpleMessage(
            "Debe contener al menos un par de palabras"),
        "grCrContNoContent": MessageLookupByLibrary.simpleMessage(
            "Introduzca el contenido de la discusión"),
        "grCrDiscussButton": MessageLookupByLibrary.simpleMessage("Discutir"),
        "grCrFutureParticipants": MessageLookupByLibrary.simpleMessage(
            "Puede agregar futuros participantes a continuación:"),
        "grCrMessageOfDifinedCat": m1,
        "grCrNewDiscussionInThisCat": m2,
        "grCrNewDiscussionTitle":
            MessageLookupByLibrary.simpleMessage("Crear nuevo debate"),
        "grCrNickNameHint": MessageLookupByLibrary.simpleMessage("@nickname"),
        "grCrNickNameNoAt": MessageLookupByLibrary.simpleMessage(
            "Ingresa un apodo que comience con @"),
        "grCrNoCategorySelected":
            MessageLookupByLibrary.simpleMessage("Seleccione una categoría"),
        "grCrSaveChanges":
            MessageLookupByLibrary.simpleMessage("Guardar cambios"),
        "grCrSelectCat": MessageLookupByLibrary.simpleMessage(
            "Por favor, seleccione la categoría para discusión futura a continuación:"),
        "grCrSelectCatHintText":
            MessageLookupByLibrary.simpleMessage("Seleccionar categoría"),
        "grCrTopicEditLabel":
            MessageLookupByLibrary.simpleMessage("Editar tema"),
        "grCrTopicHelperText": MessageLookupByLibrary.simpleMessage(
            "Ingrese la idea principal de esta discusión. Presione el ícono de candado para hacer que la discusión sea privada"),
        "grCrTopicIsEmpty": MessageLookupByLibrary.simpleMessage(
            "¡Ingrese el tema de discusión!"),
        "grCrTopicIsTooShort":
            MessageLookupByLibrary.simpleMessage("Sea más específico"),
        "grCrTopicNewLabel":
            MessageLookupByLibrary.simpleMessage("Tema de discusión"),
        "grCrUserAlreadySelected": MessageLookupByLibrary.simpleMessage(
            "Este usuario ya está seleccionado"),
        "grCreditingPageTitle":
            MessageLookupByLibrary.simpleMessage("Página de edición"),
        "homeNoRooms": MessageLookupByLibrary.simpleMessage(
            "No hay salas en esta categoría. \n¡Sé el primero y comienza una nueva conversación!"),
        "homePageTitle": m3,
        "memPageButtonCancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "memPageButtonSave": MessageLookupByLibrary.simpleMessage("Guardar"),
        "memPageLabelAdmins":
            MessageLookupByLibrary.simpleMessage("Administradores"),
        "memPageLabelBanned":
            MessageLookupByLibrary.simpleMessage("Usuarios prohibidos:"),
        "memPageLabelCreator": MessageLookupByLibrary.simpleMessage("Creador"),
        "memPageLabelMembers": MessageLookupByLibrary.simpleMessage("Miembros"),
        "memPageLabelReqs":
            MessageLookupByLibrary.simpleMessage("Solicitudes de unión"),
        "memPageTitle":
            MessageLookupByLibrary.simpleMessage("Miembros del chat"),
        "memTilesActionAccept": MessageLookupByLibrary.simpleMessage("Aceptar"),
        "memTilesActionBan": MessageLookupByLibrary.simpleMessage("Prohibir"),
        "memTilesActionCantWrite":
            MessageLookupByLibrary.simpleMessage("No se puede escribir"),
        "memTilesActionDecline":
            MessageLookupByLibrary.simpleMessage("Rechazar"),
        "memTilesActionDemote":
            MessageLookupByLibrary.simpleMessage("Degradar"),
        "memTilesActionKick": MessageLookupByLibrary.simpleMessage("Patada"),
        "memTilesActionPromote":
            MessageLookupByLibrary.simpleMessage("Promocionar"),
        "memTilesActionUnban":
            MessageLookupByLibrary.simpleMessage("Desbancar"),
        "memTilesDelete": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "memTilesDeleteWarning":
            MessageLookupByLibrary.simpleMessage("¿Eliminar esta sala?"),
        "memTilesLeave": MessageLookupByLibrary.simpleMessage("Salir"),
        "memTilesLeaveWarning":
            MessageLookupByLibrary.simpleMessage("¿Salir de esta habitación?"),
        "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
        "passwordIsIncorrect": MessageLookupByLibrary.simpleMessage(
            "Por favor, ingrese contraseña"),
        "passwordIsTooShort": MessageLookupByLibrary.simpleMessage(
            "Por favor ingrese una contraseña de al menos seis caracteres"),
        "regEmail": MessageLookupByLibrary.simpleMessage(
            "Ingrese su correo electrónico"),
        "regEmailIsEmpty": MessageLookupByLibrary.simpleMessage(
            "Ingrese una dirección de correo electrónico"),
        "regEmailNoAt": MessageLookupByLibrary.simpleMessage(
            "Introduzca un correo electrónico válido"),
        "regNameHelper": MessageLookupByLibrary.simpleMessage(
            "Debe tener al menos 2 caracteres"),
        "regNameLabel":
            MessageLookupByLibrary.simpleMessage("¿Cómo te llamas?"),
        "regNameMissing": MessageLookupByLibrary.simpleMessage(
            "Por favor, ingrese su nombre"),
        "regNameTooShort": MessageLookupByLibrary.simpleMessage(
            "El nombre es demasiado corto"),
        "regNickNameHelper":
            MessageLookupByLibrary.simpleMessage("Debería empezar con @"),
        "regNickNameLabel":
            MessageLookupByLibrary.simpleMessage("Ingresa tu apodo"),
        "regNickNameNoAt": MessageLookupByLibrary.simpleMessage(
            "ingrese el apodo que comience con @"),
        "regNickNameTooShort": MessageLookupByLibrary.simpleMessage(
            "El apodo debe tener al menos 4 caracteres"),
        "regPassword": MessageLookupByLibrary.simpleMessage("Crear contraseña"),
        "regPasswordHelper": MessageLookupByLibrary.simpleMessage(
            "Debe tener al menos 6 chatacters"),
        "regPasswordIsTooShort": MessageLookupByLibrary.simpleMessage(
            "Introduzca una contraseña de más de 6"),
        "regRegister": MessageLookupByLibrary.simpleMessage("Registrarse"),
        "regYouAreNotNew": MessageLookupByLibrary.simpleMessage(
            "¿Ya tienes una cuenta? Iniciar sesión"),
        "signIn": MessageLookupByLibrary.simpleMessage("Iniciar sesión")
      };
}
