import 'package:bytebankadvanced/database/dao/contact_dao.dart';
import 'package:bytebankadvanced/models/contact.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final ContactDao _contactDao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Novo Contato')),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _accountController,
                  decoration: InputDecoration(labelText: 'Número da conta'),
                  style: TextStyle(fontSize: 24.0),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Gravar'),
                    onPressed: () {
                      final String name = _nameController.text;
                      final int account = int.tryParse(_accountController.text);

                      final Contact contact = Contact(0, name, account);
                      _contactDao.save(contact).then((id) => Navigator.pop(context));
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
