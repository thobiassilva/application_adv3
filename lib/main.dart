import 'package:application_adv3/controllers/auth_controller.dart';
import 'package:application_adv3/models/user_auth.dart';
import 'package:application_adv3/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<AuthController>(AuthController());
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final authController = GetIt.I.get<AuthController>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text('Erro: ${snapshot.error}'),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return ValueListenableBuilder<UserAuth?>(
            valueListenable: authController.user,
            builder: (BuildContext context, UserAuth? userAuth, Widget? _) {
              print('MATERIAL APP');
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Advanced 3',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  accentColor: Colors.blueAccent,
                  primaryColor: Colors.blue,
                ),
                home: LoginPage(),
              );
            });
      },
    );
  }
}
