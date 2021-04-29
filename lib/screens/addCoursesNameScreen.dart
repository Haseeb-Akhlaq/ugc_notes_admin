import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugc_notes_admin/providers/addNewCourseProvider.dart';
import 'package:ugc_notes_admin/screens/UnitsScreen.dart';

class AddNewCourseNameAndIdScreen extends StatefulWidget {
  @override
  _AddNewCourseNameAndIdScreenState createState() =>
      _AddNewCourseNameAndIdScreenState();
}

class _AddNewCourseNameAndIdScreenState
    extends State<AddNewCourseNameAndIdScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String courseName;
  String courseId;

  saveData() {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    Provider.of<AddNewCourseProvider>(context, listen: false)
        .setNewCourseNameAndId(courseName, courseId);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UnitsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter the Course Name'),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10, top: 5, bottom: 5),
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: 'Course Name',
                              border: InputBorder.none,
                            ),
                            onSaved: (value) {
                              courseName = value;
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter valid Name';
                              }
                              if (value.length < 4) {
                                return 'Please Enter Name greater than 4 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text('Enter 8 digits Course Code '),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Every course must have unique code'),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Users will search course by this code'),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10, top: 5, bottom: 5),
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Course Code',
                              border: InputBorder.none,
                            ),
                            onSaved: (value) {
                              courseId = value;
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid Code';
                              }
                              if (value.length != 8) {
                                return 'Code must be 8 characters long';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  saveData();
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
                      'Next',
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
      ),
    );
  }
}
