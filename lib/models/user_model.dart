import 'dart:convert';

class User {
  int? id;
  String? nome;
  String? email;
  String? cpf;
  String? cep;
  String? rua;
  int? numero;
  String? bairro;
  String? cidade;
  String? uf;
  String? pais;
  String? pathImage;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.cpf,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.pais,
    required this.pathImage,
  });

  User.empty();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
      'pais': pais,
      'pathImage': pathImage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      cpf: map['cpf'],
      cep: map['cep'],
      rua: map['rua'],
      numero: map['numero'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      uf: map['uf'],
      pais: map['pais'],
      pathImage: map['pathImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
