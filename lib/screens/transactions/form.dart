import 'dart:async';

import 'package:bytebankadvanced/components/progress.dart';
import 'package:bytebankadvanced/components/response_dialog.dart';
import 'package:bytebankadvanced/components/transaction_auth_dialog.dart';
import 'package:bytebankadvanced/http/webclients/transaction_webclient.dart';
import 'package:bytebankadvanced/models/contact.dart';
import 'package:bytebankadvanced/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = Uuid().v4();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova transação'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Progress(
                  message: 'enviando transferência...',
                ),
                visible: _sending,
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transferância'),
                    onPressed: () {
                      final double value = double.tryParse(_valueController.text);
                      final transactionCreated = Transaction(
                        transactionId,
                        value,
                        widget.contact,
                      );
                      showDialog(
                        context: context,
                        builder: (contextDialog) => TransactionAuthDialog(
                          onConfirm: (String password) {
                            _saveTransaction(transactionCreated, password, context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveTransaction(Transaction transactionCreated, String password, BuildContext context) async {
    setState(() => _sending = true);
    Transaction transaction = await _sendTransaction(transactionCreated, password, context);
    _showSuccessfulMessage(transaction, context);
  }

  Future _showSuccessfulMessage(Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('Transação efetuada com sucesso');
          });
      Navigator.of(context).pop();
    }
  }

  Future<Transaction> _sendTransaction(Transaction transactionCreated, String password, BuildContext context) async {
    final transaction = await _webClient.save(transactionCreated, password).catchError((error) {
      _showFailureMessage(context, message: error.message);
    }, test: (error) => error is ApiException).catchError((error) {
      _showFailureMessage(context, message: 'Tempo de conexão excedido');
    }, test: (error) => error is TimeoutException).catchError((error) {
      _showFailureMessage(context);
    }).whenComplete(() => setState(() => _sending = false));
    return transaction;
  }

  void _showFailureMessage(BuildContext context, {String message = 'Ocorreu um erro desconhecido'}) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}
