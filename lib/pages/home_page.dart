import 'dart:io';

import 'package:application_adv3/data/db.dart';
import 'package:application_adv3/data/repository.dart';
import 'package:application_adv3/models/user_model.dart';
import 'package:flutter/material.dart';

import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repository = Repository(MyDatabase());
  Future<List<User>>? futureUsers;

  @override
  void initState() {
    super.initState();
    getAll();
  }

  void getAll() async {
    setState(() {
      futureUsers = repository.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listagem de Alunos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: futureUsers,
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text('Ocorreu um erro. Tente novamente'),
              );
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              print('SIM');
              print(snapshot.data);
            }
            final List<User> users = snapshot.data!;
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (ctx, index) {
                  var user = users[index];
                  return Dismissible(
                    key: ValueKey(user.id),
                    onDismissed: (direction) {
                      setState(() {
                        users.removeAt(index);
                      });
                    },
                    confirmDismiss: (direction) async {
                      return await repository.delete(user);
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.delete,
                            size: 40,
                            color: Colors.white,
                          ),
                          /*  SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Excluindo...',
                            style: TextStyle(color: Colors.white),
                          ), */
                        ],
                      ),
                    ),
                    child: ListTile(
                      title: Text(user.nome!),
                      subtitle: Text(user.email!),
                      leading: user.pathImage != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(File(user.pathImage!)),
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  NetworkImage('https://robohash.org/4.png'),
                            ),
                      onTap: () {
                        Navigator.of(ctx).push(
                          MaterialPageRoute(
                            builder: (_) => ProfilePage(
                              user: user,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                });
          }),
    );
  }
}
