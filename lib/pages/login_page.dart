import 'package:application_adv3/controllers/auth_controller.dart';
import 'package:application_adv3/controllers/login_controller.dart';
import 'package:application_adv3/models/user_auth.dart';
import 'package:application_adv3/pages/home_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  //bool isLoading = true;
  //var formKey = GlobalKey<FormState>();
  // String? email;
  // String? senha;

/*   bool doLogin() {
    if (!formKey.currentState!.validate()) {
      isLoading = false;
      setState(() {});
      return false;
    }
    formKey.currentState!.save();
    return true;
  } */

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = LoginController();
  final authController = GetIt.I.get<AuthController>();

  @override
  void initState() {
    super.initState();
  }

  void goToHomePage(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomePage()));
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
                child: FutureBuilder(
                  future: authController.isLogged(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return loadind();
                    }
                    if (!snapshot.data!) {
                      return loginButtons();
                    }
                    goToHomePage(context);
                    return loadind();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadind() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Carregando...',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget loginButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          child: SignInButton(
            Buttons.Google,
            onPressed: () => controller.signInWithGoogle(),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          height: 50,
          child: SignInButton(
            Buttons.FacebookNew,
            onPressed: () => controller.signInWithFacebook(),
          ),
        ),
      ],
    );
  }
}
