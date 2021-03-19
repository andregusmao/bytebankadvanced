import 'package:bytebankadvanced/database/dao/contact_dao.dart';
import 'package:bytebankadvanced/models/contact.dart';
import 'package:bytebankadvanced/screens/contacts/form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State {
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
              // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('carregando'),
                  ],
                ),
              );
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
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
              // TODO: Handle this case.
              final List<Contact> contacts = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ContactItem(contact);
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
            .push(MaterialPageRoute(builder: (context) => ContactForm()))
            .then((value) => setState(() {})),
        child: Icon(Icons.add),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final Contact contact;

  ContactItem(this.contact);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          contact.account.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
