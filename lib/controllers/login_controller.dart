import 'package:application_adv3/controllers/auth_controller.dart';
import 'package:application_adv3/models/user_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  ValueNotifier<bool> isLoadind = ValueNotifier(true);

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(result.user!.displayName);
    print(result.user!.email);
    setUserLogged(result.user!);
    return result;
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult facebookUser = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential credential =
        FacebookAuthProvider.credential(facebookUser.accessToken!.token);

    // Once signed in, return the UserCredential
    final UserCredential result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(result.user!.displayName);
    print(result.user!.email);
    setUserLogged(result.user!);
    return result;
  }

  Future<void> setUserLogged(User? firebaseUser) async {
    final token = await firebaseUser!.getIdToken();
    final userAuth = UserAuth(
      email: firebaseUser.email!,
      name: firebaseUser.displayName!,
      urlPhoto: firebaseUser.photoURL!,
      token: token,
    );
    final authController = GetIt.I.get<AuthController>();
    authController.userLogged = userAuth;
  }
}
