import 'package:flutter/material.dart';
import 'package:ugc_notes_admin/screens/addnewTopicScreen.dart';

class TopicsScreen extends StatefulWidget {
  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Unit Topics'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNewTopicName(),
                    ));
              })
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
