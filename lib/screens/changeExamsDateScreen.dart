import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChangeExamsDateScreen extends StatefulWidget {
  final String previousDate;
  final String courseId;

  const ChangeExamsDateScreen({this.previousDate, this.courseId});

  @override
  _ChangeExamsDateScreenState createState() => _ChangeExamsDateScreenState();
}

class _ChangeExamsDateScreenState extends State<ChangeExamsDateScreen> {
  String examDate = '';

  setPreviousDate() {
    examDate = widget.previousDate;
  }

  updateDate(context) async {
    await FirebaseFirestore.instance
        .collection('AllCourses')
        .doc(widget.courseId)
        .update({'examDate': examDate});

    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    setPreviousDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Exam Date'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Change Exam Date To :'),
                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      setState(() {
                        examDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    },
                    child: Text(
                      'Select Exam Date',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Exam Will Be On:  ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(examDate),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                updateDate(context);
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Change',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
