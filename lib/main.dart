import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/app_colors.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/stream_repository.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'logic/cubits/navigation/navigation_cubit.dart';
import 'logic/cubits/stream/stream_cubit.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'core/theme/app_theme.dart';
import 'logic/cubits/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Core
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase Core init failed: $e. Falling back to Mock Auth.');
  }

  // Initialize Google Sign-In v7+
  try {
    await GoogleSignIn.instance.initialize();
  } catch (e) {
    // Suppress for unsupported platforms/dev environments
  }

  // Set system UI overlay colors for premium look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Repositories
  final authRepository = HybridAuthRepository();
  final streamRepository = MockStreamRepository();

  runApp(
    MyApp(
      authRepository: authRepository,
      streamRepository: streamRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final StreamRepository streamRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.streamRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<StreamRepository>.value(value: streamRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepository),
          ),
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider<StreamCubit>(
            create: (context) => StreamCubit(streamRepository),
          ),
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'Alive',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
