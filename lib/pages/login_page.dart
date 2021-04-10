import 'package:application_adv3/pages/home_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) return 'Preencha o email.';
                          if (!EmailValidator.validate(value))
                            return 'E-mail inválido';

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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
