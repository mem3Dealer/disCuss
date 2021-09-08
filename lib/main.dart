import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/states/auth_state.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/pages/home.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/services/wrapper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_chat_app/shared/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() async {
  // final userCubit = GetIt.I.get<UserCubit>();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  // WidgetsFlutterBinding.ensureInitialized();
  // print('ayy');
  GetIt.instance
    //..registerSingleton<RoomState>(
    //  RoomState()) // может не синглтон? или порядок не тот
    ..registerSingleton<DataBaseService>(DataBaseService())
    ..registerSingleton<UserCubit>(UserCubit())
    ..registerFactory(() => AuthService())
    ..registerSingleton<AuthCubit>(AuthCubit())
    ..registerSingleton<RoomCubit>(RoomCubit())

    // ..registerFactory(() => RoomCubit())
    ..registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

  // await userCubit.getUsersList();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authCubit = GetIt.I.get<AuthCubit>();
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
                themeMode: ThemeMode.system,
                theme: appThemeLight,
                darkTheme: appThemeDark,
                routes: <String, WidgetBuilder>{
                  '/home_page': (BuildContext context) => HomePage(),
                  '/wrapper': (BuildContext context) => Wrapper(),
                  // '/signIn': (BuildContext context) => SignInPage()
                },
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('ru', ''), // English, no country code
                  // Spanish, no country code
                ],
                home:
                    //SliverPage(),
                    BlocBuilder<AuthCubit, AuthState>(
                        bloc: authCubit,
                        // value: AuthService().user,
                        builder: (context, state) {
                          // authCubit.checkUser();
                          return SplashScreenView(
                              duration: 2000,
                              imageSize: 450,
                              imageSrc: 'assets/logo.png',
                              navigateRoute: Wrapper());
                          // Wrapper();
                        }));
          } else
            return Container();
        });
  }
  // else {
  //   return Container();
}
