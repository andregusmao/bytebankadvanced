import 'dart:convert';

import 'package:bytebankadvanced/models/transaction.dart';
import 'package:http/http.dart';

import '../webclient.dart';

class TransactionWebClient {
  static final Map<int, String> _statusCodeResponse = {
    400: 'Informações inválidas',
    401: 'Falha na autenticação',
    409: 'Transação já existe'
  };

  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(
      Uri.parse('$BASE_URL/transactions'),
    );

    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic json) => Transaction.fromJson(json)).toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    await Future.delayed(Duration(seconds: 10));

    final Response response = await client.post(Uri.parse('$BASE_URL/transactions'),
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: transactionJson);

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw ApiException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if (_statusCodeResponse.containsKey(statusCode)) {
      return _statusCodeResponse[statusCode];
    }
    return 'Erro desconhecido';
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);
}
