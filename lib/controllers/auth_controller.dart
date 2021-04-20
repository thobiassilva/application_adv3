import 'package:application_adv3/models/user_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  ValueNotifier<UserAuth?> _userLogged = ValueNotifier(null);

  ValueNotifier<UserAuth?> get user => _userLogged;

  set userLogged(UserAuth? user) => _userLogged.value = user;

  Future<bool> isLogged() async {
    await Future.delayed(Duration(seconds: 1));
    final userLogged = FirebaseAuth.instance.currentUser;
    if (userLogged != null) {
      loadUser(userLogged);
      return true;
    }
    return false;
  }

  Future<void> loadUser(User userFirebase) async {
    if (user.value == null) {
      final token = await userFirebase.getIdToken();
      userLogged = UserAuth(
        email: userFirebase.email!,
        name: userFirebase.displayName!,
        urlPhoto: userFirebase.photoURL!,
        token: token,
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    userLogged = null;
  }
}
