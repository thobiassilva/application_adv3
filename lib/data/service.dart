import 'package:dio/dio.dart';

class Service {
  final dio = Dio();
  bool doLogin({
    required String email,
    required String pass,
  }) {
    if (email == 'teste@teste.com') {
      return false;
    }
    Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<Map<String, dynamic>> findCep(String cep) async {
    Response response = await dio.get('https://viacep.com.br/ws/$cep/json/');
    return (response.data as Map<String, dynamic>);
  }
}
