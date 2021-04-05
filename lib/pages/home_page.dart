import 'package:application_adv3/models/user_model.dart';
import 'package:flutter/material.dart';

import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final users = [
    {
      'nome': 'Edson',
      'email': 'edson@gmail.com',
      'cpf': '999.999.999-00',
      'cep': '99699-000',
      'rua': 'rua do edson',
      'numero': 00,
      'bairro': 'centro',
      'cidade': 'Porto Alegre',
      'uf': 'RS',
      'pais': 'Brasil',
      'pathImage': 'https://robohash.org/1.png',
    },
    {
      'nome': 'Gabriel',
      'email': 'gabriel@gmail.com',
      'cpf': '999.999.999-00',
      'cep': '99699-000',
      'rua': 'Rua do gabriel',
      'numero': 11,
      'bairro': 'centro',
      'cidade': 'Sao Paulo',
      'uf': 'SP',
      'pais': 'Brasil',
      'pathImage': 'https://robohash.org/3.png',
    },
    {
      'nome': 'Thobias',
      'email': 'thobias@gmail.com',
      'cpf': '999.999.999-00',
      'cep': '99699-000',
      'pathImage': 'https://robohash.org/4.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listagem de Alunos'),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (ctx, index) {
            var user = users[index];
            return ListTile(
              title: Text('${user['nome']}'),
              subtitle: Text('${user['email']}'),
              leading: CircleAvatar(
                child: Image.network('${user['pathImage']}'),
              ),
              onTap: () {
                Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(
                      user: User.fromMap(user),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
