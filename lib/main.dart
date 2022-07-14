import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:safe_space/controller/provider_class.dart';
import 'package:safe_space/firebase_options.dart';
import 'package:safe_space/screens/home_screen.dart';
import 'package:safe_space/services/auth_services.dart';

import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            Provider<AuthService>(
              create: (_) => AuthService(FirebaseAuth.instance),
            ),
            StreamProvider(
              create: ((context) =>
                  context.read<AuthService>().authStateChanges),
              initialData: null,
            ),
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AuthWrapper(),
          ),
        );
      }));
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if (user != null) {
      return HomeScreen();
    }
    return const LoginPage();
  }
}
