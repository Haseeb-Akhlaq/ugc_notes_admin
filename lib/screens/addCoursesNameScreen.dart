import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';
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
  String courseCode = '';
  String examDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 2)));
  String imageUrl = '';
  String courseId = '';

  bool isUploading = false;

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        isUploading = true;
      });

      _image = File(pickedFile.path);
      String fileName = basename(pickedFile.path);

      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('courseThumbnail/$fileName');

      final uploadTask = firebaseStorageRef.putFile(_image);

      final taskSnapshot =
          await uploadTask.whenComplete(() => print('image uploaded'));

      uploadTask.asStream().listen((event) {
        print('wqdddddd');
        print(event.bytesTransferred / event.totalBytes);
      });

      taskSnapshot.ref.getDownloadURL().then(
        (value) {
          setState(() {
            imageUrl = value;
            print("Done: $value");
            isUploading = false;
          });
        },
      );
    } else {
      print('No image selected.');
    }
  }

  setSearchParam(String courseName) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < courseName.length; i++) {
      temp = temp + courseName[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  saveData(BuildContext context) async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    final coursePath =
        FirebaseFirestore.instance.collection('AllCourses').doc(courseId);

    final courseData = await coursePath.get();

    if (courseData.exists) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UnitsScreen(
                    courseId: courseId,
                  )));
    } else {
      List<String> searchParameters = setSearchParam(courseName);

      await FirebaseFirestore.instance
          .collection('AllCourses')
          .doc(courseId)
          .set({
        'courseName': courseName,
        'courseId': courseId,
        'courseCode': courseCode,
        'totalCards': '0',
        'totalUnits': '0',
        'totalTopics': '0',
        'examDate': examDate,
        'coursePic': imageUrl,
        'nameParameters': searchParameters,
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UnitsScreen(
                    courseId: courseId,
                  )));
    }
  }

  @override
  void initState() {
    super.initState();
    Random random = new Random();
    var code = random.nextInt(90000000) + 10000000;
    courseId = code.toString();
    print(courseId);
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
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 130,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: isUploading
                                  ? CircularProgressIndicator()
                                  : _image == null
                                      ? Text('No image')
                                      : Image.file(
                                          _image,
                                          fit: BoxFit.contain,
                                        ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: TextButton.icon(
                              icon: Icon(
                                Icons.photo,
                                color: Colors.blue,
                              ),
                              label: Text(
                                'Pick Image For Course',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text('Enter 3 digits Course Code '),
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
                              courseCode = value;
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid Code';
                              }
                              if (value.length > 3) {
                                return 'Code must be less than 4 digits';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
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
                            examDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
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
              ),
              GestureDetector(
                onTap: () {
                  if (imageUrl == '') {
                    Toast.show("Please Select a picture", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  }
                  saveData(context);
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
