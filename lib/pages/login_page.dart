import 'package:application_adv3/pages/home_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  var formKey = GlobalKey<FormState>();
  String? email;
  String? senha;

  bool doLogin() {
    if (!formKey.currentState!.validate()) {
      isLoading = false;
      setState(() {});
      return false;
    }
    formKey.currentState!.save();
    return true;
  }

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
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                colors: [
                  Colors.deepPurple[900]!,
                  Colors.lightBlue[400]!,
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      child: SignInButton(
                        Buttons.Google,
                        onPressed: () => signInWithGoogle(),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 50,
                      child: SignInButton(
                        Buttons.FacebookNew,
                        onPressed: () => signInWithFacebook(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginInput() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) return 'Preencha o email.';
              if (!EmailValidator.validate(value)) return 'E-mail inválido';

              return null;
            },
            initialValue: 'email@email.com',
            onSaved: (value) => email = value,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.grey[800],
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) return 'Preencha a senha.';
              return null;
            },
            initialValue: '1',
            onSaved: (value) => senha = value,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Senha',
              labelStyle: TextStyle(
                color: Colors.grey[800],
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              if (doLogin())
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(),
                  ),
                );
            },
            child: Text('Entrar'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[900],
              textStyle: TextStyle(
                fontSize: 18,
              ),
              minimumSize: Size(double.infinity, 40),
            ),
          ),
          isLoading
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 5,
                ),
        ],
      ),
    );
  }
}
