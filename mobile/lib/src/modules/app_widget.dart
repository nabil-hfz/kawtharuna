import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kawtharuna/main.dart';
import 'package:kawtharuna/src/core/di/di.dart';
import 'package:kawtharuna/src/core/managers/ads/ads_controller.dart';
import 'package:kawtharuna/src/core/managers/app_lifecycle/app_lifecycle.dart';
import 'package:kawtharuna/src/core/managers/audio/audio_controller.dart';
import 'package:kawtharuna/src/core/managers/games_services/games_services.dart';
import 'package:kawtharuna/src/core/managers/games_services/score.dart';
import 'package:kawtharuna/src/core/managers/in_app_purchase/in_app_purchase.dart';
import 'package:kawtharuna/src/core/managers/localization/generated/l10n.dart';
import 'package:kawtharuna/src/core/managers/managers.dart';
import 'package:kawtharuna/src/core/managers/player_progress/persistence/player_progress_persistence.dart';
import 'package:kawtharuna/src/core/managers/player_progress/player_progress.dart';
import 'package:kawtharuna/src/core/managers/settings/persistence/settings_persistence.dart';
import 'package:kawtharuna/src/core/managers/settings/settings.dart';
import 'package:kawtharuna/src/core/style/my_transition.dart';
import 'package:kawtharuna/src/core/style/palette.dart';
import 'package:kawtharuna/src/core/style/snack_bar.dart';
import 'package:kawtharuna/src/modules/level_selection/level_selection_screen.dart';
import 'package:kawtharuna/src/modules/level_selection/levels.dart';
import 'package:kawtharuna/src/modules/main_menu/screens/main_menu_screen.dart';
import 'package:kawtharuna/src/modules/play_session/play_session_screen.dart';
import 'package:kawtharuna/src/modules/settings/settings_screen.dart';
import 'package:kawtharuna/src/modules/win_game/win_game_screen.dart';

class MyApp extends StatelessWidget {
  // static final _router = navigator.buildRouter();
  GoRouter buildRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const MainMenuScreen(key: Key('main menu')),
          routes: [
            GoRoute(
              path: 'play',
              pageBuilder: (context, state) => buildMyTransition<void>(
                child: const LevelSelectionScreen(
                  key: Key('level selection'),
                ),
                color: context.watch<Palette>().backgroundLevelSelection,
              ),
              routes: [
                GoRoute(
                  path: 'session/:level',
                  pageBuilder: (context, state) {
                    final levelNumber = int.parse(state.params['level']!);
                    final level =
                        gameLevels.singleWhere((e) => e.number == levelNumber);
                    return buildMyTransition<void>(
                      child: PlaySessionScreen(
                        level,
                        key: const Key('play session'),
                      ),
                      color: context.watch<Palette>().backgroundPlaySession,
                    );
                  },
                ),
                GoRoute(
                  path: 'won',
                  pageBuilder: (context, state) {
                    final map = state.extra! as Map<String, dynamic>;
                    final score = map['score'] as Score;

                    return buildMyTransition<void>(
                      child: WinGameScreen(
                        score: score,
                        key: const Key('win game'),
                      ),
                      color: context.watch<Palette>().backgroundPlaySession,
                    );
                  },
                )
              ],
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) =>
                  const SettingsScreen(key: Key('settings')),
            ),
          ],
        ),
      ],
    );
  }

  final PlayerProgressPersistence playerProgressPersistence;

  final SettingsPersistence settingsPersistence;

  final GamesServicesController? gamesServicesController;

  final InAppPurchaseController? inAppPurchaseController;

  final AdsController? adsController;

  const MyApp({
    required this.playerProgressPersistence,
    required this.settingsPersistence,
    required this.inAppPurchaseController,
    required this.adsController,
    required this.gamesServicesController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final router = buildRouter();
    final appTheme = findDep<AppThemeManager>();
    final appLanguageManager = findDep<AppLanguageManager>();
    return AppLifecycleObserver(
      child: Builder(builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => appLanguageManager),
            ChangeNotifierProvider(create: (_) => appTheme),
            ChangeNotifierProvider(
              create: (context) {
                var progress = PlayerProgress(playerProgressPersistence);
                progress.getLatestFromStore();
                return progress;
              },
            ),
            Provider<GamesServicesController?>.value(
                value: gamesServicesController),
            Provider<AdsController?>.value(value: adsController),
            ChangeNotifierProvider<InAppPurchaseController?>.value(
              value: inAppPurchaseController,
            ),
            Provider<SettingsController>(
              lazy: false,
              create: (context) => SettingsController(
                persistence: settingsPersistence,
              )..loadStateFromPersistence(),
            ),
            ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,
                AudioController>(
              // Ensures that the AudioController is created on startup,
              // and not "only when it's needed", as is default behavior.
              // This way, music starts immediately.
              lazy: false,
              create: (context) => AudioController()..initialize(),
              update: (context, settings, lifecycleNotifier, audio) {
                if (audio == null) throw ArgumentError.notNull();
                audio.attachSettings(settings);
                audio.attachLifecycleNotifier(lifecycleNotifier);
                return audio;
              },
              dispose: (context, audio) => audio.dispose(),
            ),
            // Provider(
            //   create: (context) => Palette(),
            // ),
          ],
          child: Consumer<AppLanguageManager>(
            builder: (context, appLanguage, child) {
              return Consumer<AppThemeManager>(
                builder: (context, appTheme, _) {
                  return MaterialApp.router(
                    title: envVariables.appName,
                    debugShowCheckedModeBanner: false,
                    theme: appTheme.isDarkMode
                        ? appTheme.getDarkTheme
                        : appTheme.getLightTheme,
                    routeInformationProvider: router.routeInformationProvider,
                    routeInformationParser: router.routeInformationParser,
                    routerDelegate: router.routerDelegate,
                    scaffoldMessengerKey: scaffoldMessengerKey,
                    locale: appLanguage.appLocal,
                    supportedLocales: Translations.delegate.supportedLocales,
                    localeResolutionCallback: (locale, supportedLocales) {
                      return locale;
                    },
                    localizationsDelegates: const [
                      Translations.delegate,
                      // RefreshLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}