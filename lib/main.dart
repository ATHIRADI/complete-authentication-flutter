import 'package:complete_auth/pages/home_screen.dart';
import 'package:complete_auth/pages/login_screen.dart';
import 'package:complete_auth/utils/helpers.dart';
import 'package:complete_auth/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Connectivity _connectivity;
  late final Stream<ConnectivityResult> _connectivityStream;
  ConnectivityResult? _previousResult;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged.map((event) {
      return event.isNotEmpty ? event.first : ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivityStream,
      builder: (context, snapshot) {
        final connectivityResult = snapshot.data;
        if (connectivityResult == ConnectivityResult.none &&
            _previousResult != ConnectivityResult.none) {
          AppHelpers.showSnackBar(context, "No internet connection");
        }
        _previousResult = connectivityResult;

        return MaterialApp(
          title: 'Complete Authentication Solution',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: CustomTheme.lightTheme,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeScreen();
              } else {
                return const LoginScreen();
              }
            },
          ),
        );
      },
    );
  }
}
