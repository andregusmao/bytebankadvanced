import 'dart:convert';

import 'package:bytebankadvanced/models/transaction.dart';
import 'package:http/http.dart';

import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client
        .get(
          Uri.parse('$BASE_URL/transactions'),
        )
        .timeout(Duration(seconds: 5));

    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic json) => Transaction.fromJson(json)).toList();
  }

  Future<Transaction> save(Transaction transaction) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client
        .post(Uri.parse('$BASE_URL/transactions'),
            headers: {'Content-type': 'application/json', 'password': '1000'}, body: transactionJson)
        .timeout(Duration(seconds: 5));

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
