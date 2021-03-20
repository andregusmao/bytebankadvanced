import 'package:bytebankadvanced/screens/contacts/list.dart';
import 'package:bytebankadvanced/screens/transactions/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FeatureItem(
                  'Transferências',
                  Icons.monetization_on,
                  onTap: () => _showContactsList(context),
                ),
                _FeatureItem(
                  'Transações',
                  Icons.description,
                  onTap: () => _showTransactionsList(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactsList(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactsList()));
  }

  void _showTransactionsList(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransactionsList()));
  }
}

class _FeatureItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  _FeatureItem(this.title, this.icon, {@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: this.onTap,
          child: Container(
            padding: EdgeInsets.all(8.0),
            height: 100,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  this.icon,
                  color: Colors.white,
                  size: 24.0,
                ),
                Text(
                  this.title,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
