import 'package:bytebankadvanced/components/progress.dart';
import 'package:bytebankadvanced/database/dao/contact_dao.dart';
import 'package:bytebankadvanced/models/contact.dart';
import 'package:bytebankadvanced/screens/contacts/form.dart';
import 'package:bytebankadvanced/screens/transactions/form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  final ContactDao _contactDao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transferências')),
      body: FutureBuilder<List<Contact>>(
        initialData: [],
        future: _contactDao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress();
              break;
            case ConnectionState.active:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('carregando... ${snapshot.data.length}'),
                  ],
                ),
              );
              break;
            case ConnectionState.done:
              final List<Contact> contacts = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return _ContactItem(contact, onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => TransactionForm(contact)),
                    );
                  });
                },
                itemCount: contacts.length,
              );
              break;
          }

          return Text('Deu pau');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ContactForm())),
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onTap;

  _ContactItem(this.contact, {@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: this.onTap,
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
