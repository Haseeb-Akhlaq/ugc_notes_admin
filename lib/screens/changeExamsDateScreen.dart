import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ChangeExamsDateScreen extends StatefulWidget {
  final String previousDate;
  final String courseId;

  const ChangeExamsDateScreen({this.previousDate, this.courseId});

  @override
  _ChangeExamsDateScreenState createState() => _ChangeExamsDateScreenState();
}

class _ChangeExamsDateScreenState extends State<ChangeExamsDateScreen> {
  TextEditingController dateController = TextEditingController();

  setPreviousDate() {
    dateController.text = widget.previousDate;
  }

  updateDate(context) async {
    await FirebaseFirestore.instance
        .collection('AllCourses')
        .doc(widget.courseId)
        .update({'examIn': dateController.text});

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
              child: Row(
                children: [
                  Text('Change Exam Date To :'),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.black,
                    )),
                    height: 80,
                    width: 80,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (dateController.text == '') {
                  Toast.show("Please Select a Valid Date", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  return;
                }
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
