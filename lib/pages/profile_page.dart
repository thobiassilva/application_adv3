import 'dart:io';
import 'package:application_adv3/data/db.dart';
import 'package:application_adv3/data/repository.dart';
import 'package:application_adv3/models/user_model.dart';
import 'package:application_adv3/data/service.dart';
import 'package:application_adv3/pages/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  final User? user;

  ProfilePage({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final ufController = TextEditingController();

  final repository = Repository(MyDatabase());

  User? user = User.empty();
  bool isLoading = false;

  /* String? nome;
  String? email;
  String? cpf;
  String? cep;
  String? rua;
  String? numero;
  String? bairro;
  String? cidade;
  String? uf;
  String? pais;
  String? urlAvatar; */

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      user = widget.user;

      cepController.text = widget.user!.cep!;
      ruaController.text = widget.user!.rua!;
      numeroController.text = widget.user!.numero!.toString();
      bairroController.text = widget.user!.bairro!;
      cidadeController.text = widget.user!.cidade!;
      ufController.text = widget.user!.uf!;
    }
  }

  void editPhoto(BuildContext context) async {
    final picker = ImagePicker();
    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Tirar foto'),
              onTap: () async {
                try {
                  final pickedFile =
                      await picker.getImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      user?.pathImage = pickedFile.path;

                      Navigator.pop(ctx);
                    });
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_photo),
              title: Text('Escolher foto'),
              onTap: () async {
                try {
                  final pickedFile =
                      await picker.getImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    setState(() {
                      user?.pathImage = pickedFile.path;
                    });
                    Navigator.pop(ctx);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void findCep(String cep) async {
    cep = cep.replaceAll('.', '').replaceAll('-', '');
    print(cep);
    Map<String, dynamic> response = await Service().findCep(cep);
    ruaController.text = response['logradouro'];
    bairroController.text = response['bairro'];
    cidadeController.text = response['localidade'];
    ufController.text = response['uf'];

    setState(() {
      isLoading = false;
    });
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 200,
                    height: 150,
                    child: Stack(
                      children: [
                        if (user?.pathImage == null)
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://robohash.org/4.png'),
                            radius: 100,
                          ),
                        if (user?.pathImage != null)
                          CircleAvatar(
                            backgroundImage: FileImage(File(user!.pathImage!)),
                            radius: 100,
                          ),
                        /* Visibility(
                          visible: user?.pathImage != null,
                          replacement: CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://robohash.org/4.png'),
                            radius: 100,
                          ),
                          child: CircleAvatar(
                            backgroundImage: FileImage(File(user!.pathImage!)),
                            radius: 100,
                          ),
                        ), */
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Builder(
                            builder: (context) {
                              return IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                onPressed: () => editPhoto(context),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                buildInputs(),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();

                    user?.id == null
                        ? await repository.insert(user!)
                        : await repository.update(user!);

                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => HomePage()));
                  },
                  child: Text('Salvar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputs() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            initialValue: user?.nome,
            validator: (value) {
              if (value!.isEmpty) return 'Preencha o nome';
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
            ],
            keyboardType: TextInputType.name,
            onSaved: (value) => user?.nome = value!,
            decoration: InputDecoration(
              labelText: 'Nome Completo',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(50),
                  ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            initialValue: user?.email,
            validator: (value) {
              if (value!.isEmpty) return 'Preencha o email';
              if (!EmailValidator.validate(value)) return 'Email inválido';

              return null;
            },
            onSaved: (value) => user?.email = value!,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(50),
                  ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            initialValue: user?.cpf,
            validator: (value) {
              if (value!.isEmpty) return 'Preencha o CPF';
              return null;
            },
            onSaved: (value) => user?.cpf = value!,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter(),
            ],
            decoration: InputDecoration(
              labelText: 'CPF',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(50),
                  ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  onSaved: (value) => user?.cep = value!,
                  keyboardType: TextInputType.number,
                  controller: cepController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: 'CEP',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(50),
                        ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 1,
                child: isLoading
                    ? Center(
                        child: Container(child: CircularProgressIndicator()))
                    : TextButton.icon(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          findCep((cepController.text));
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Buscar CEP',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  onSaved: (value) => user?.rua = value!,
                  validator: (value) {
                    if (value!.isEmpty) return 'Preencha a rua';
                    return null;
                  },
                  controller: ruaController,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    labelText: 'Rua',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(50),
                        ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  onSaved: (value) => user?.numero = int.tryParse(value!) ?? 0,
                  validator: (value) {
                    if (value!.isEmpty) return 'Preencha o numero';
                    return null;
                  },
                  controller: numeroController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Número',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(50),
                        ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  onSaved: (value) => user?.bairro = value!,
                  validator: (value) {
                    if (value!.isEmpty) return 'Preencha o bairro';
                    return null;
                  },
                  controller: bairroController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(50),
                        ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  onSaved: (value) => user?.cidade = value!,
                  validator: (value) {
                    if (value!.isEmpty) return 'Preencha a cidade';
                    return null;
                  },
                  controller: cidadeController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Cidade',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(50),
                        ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) return 'Preencha o UF';
                    return null;
                  },
                  onSaved: (value) => user?.uf = value!,
                  controller: ufController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                  ],
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'UF',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(50),
                        ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: user!.pais,
                  validator: (value) {
                    if (value!.isEmpty) return 'Preencha o Pais';
                    return null;
                  },
                  onSaved: (value) => user?.pais = value!,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                  ],
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Pais',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(50),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
