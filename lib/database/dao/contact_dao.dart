import 'package:bytebankadvanced/models/contact.dart';
import 'package:sqflite/sqflite.dart';

import '../app_database.dart';

class ContactDao {
  static const String _TABLE_CONTACT = 'contacts';
  static const String _COLUMN_ID = 'id';
  static const String _COLUMN_NAME = 'name';
  static const String _COLUMN_ACCOUNT = 'account';

  static const String CREATE_TABLE = 'CREATE TABLE $_TABLE_CONTACT ('
      '$_COLUMN_ID INTEGER PRIMARY KEY, '
      '$_COLUMN_NAME TEXT, '
      '$_COLUMN_ACCOUNT INTEGER)';

  Future _getList(Database db, List<Contact> contacts) async {
    for (Map<String, dynamic> map in await db.query(_TABLE_CONTACT)) {
      final Contact contact = Contact(
        map[_COLUMN_ID],
        map[_COLUMN_NAME],
        map[_COLUMN_ACCOUNT],
      );
      contacts.add(contact);
    }
  }

  Map<String, dynamic> _getMap(Contact contact) {
    final Map<String, dynamic> map = Map();
    map[_COLUMN_NAME] = contact.name;
    map[_COLUMN_ACCOUNT] = contact.account;
    return map;
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Contact> contacts = [];
    await _getList(db, contacts);
    return contacts;
  }

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();
    Map<String, dynamic> map = _getMap(contact);
    return db.insert(_TABLE_CONTACT, map);
  }
}
