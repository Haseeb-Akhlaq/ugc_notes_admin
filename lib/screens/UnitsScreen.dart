import 'package:flutter/material.dart';
import 'package:ugc_notes_admin/screens/addNewUnitNameScreen.dart';

class UnitsScreen extends StatefulWidget {
  @override
  _UnitsScreenState createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Course Units'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewUnitNameScreen()));
              })
        ],
      ),
    );
  }
}
