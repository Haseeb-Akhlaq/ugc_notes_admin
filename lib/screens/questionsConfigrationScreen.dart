// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:ugc_notes_admin/Models/QuestionModel.dart';
// import 'package:uuid/uuid.dart';
//
// class EnterQuestionData extends StatefulWidget {
//   final QuestionModel questionData;
//   const EnterQuestionData({this.questionData});
//
//   @override
//   _EnterQuestionDataState createState() => _EnterQuestionDataState();
// }
//
// class _EnterQuestionDataState extends State<EnterQuestionData> {
//   bool isUploading = false;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   TextEditingController questionTitleController = TextEditingController();
//   TextEditingController questionContentController = TextEditingController();
//   TextEditingController option1Controller = TextEditingController();
//   TextEditingController option2Controller = TextEditingController();
//   TextEditingController option3Controller = TextEditingController();
//   TextEditingController option4Controller = TextEditingController();
//
//   String questionId = '';
//   String questionTitle = '';
//   String questionContent = '';
//   String option1 = '';
//   String option2 = '';
//   String option3 = '';
//   String option4 = '';
//   String correctAnswer = '';
//   int correctValue = 0;
//
//   Uuid uid = Uuid();
//
//   setData() {
//     questionId = widget.questionData.questionId;
//     questionTitleController.text = widget.questionData.questionTitle;
//     questionContentController.text = widget.questionData.questionContent;
//     option1Controller.text = widget.questionData.option1;
//     option2Controller.text = widget.questionData.option2;
//     option3Controller.text = widget.questionData.option3;
//     option4Controller.text = widget.questionData.option4;
//     correctAnswer = widget.questionData.correctAnswer;
//
//     if (correctAnswer == option1Controller.text) {
//       correctValue = 0;
//     } else if (correctAnswer == option2Controller.text) {
//       correctValue = 1;
//     } else if (correctAnswer == option3Controller.text) {
//       correctValue = 2;
//     } else if (correctAnswer == option4Controller.text) {
//       correctValue = 3;
//     }
//   }
//
//   saveData(BuildContext context) async {
//     bool isValid = _formKey.currentState.validate();
//
//     if (!isValid) {
//       return;
//     }
//
//     _formKey.currentState.save();
//
//     await FirebaseFirestore.instance
//         .collection('AllQuestions')
//         .doc(questionId)
//         .set({
//       'questionId': questionId,
//       'questionTitle': questionTitle,
//       'questionContent': questionContent,
//       'option1': option1Controller.text,
//       'option2': option2Controller.text,
//       'option3': option3Controller.text,
//       'option4': option4Controller.text,
//       'correctAnswer': correctAnswer,
//     });
//
//     Navigator.pop(context);
//   }
//
//   @override
//   void initState() {
//     setData();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter Card Data'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text('Title'),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10, top: 5, bottom: 5),
//                           child: TextFormField(
//                             controller: questionTitleController,
//                             textAlign: TextAlign.left,
//                             maxLines: 1,
//                             decoration: InputDecoration(
//                               hintText: 'Question Title',
//                               border: InputBorder.none,
//                             ),
//                             onSaved: (value) {
//                               questionTitle = value;
//                             },
//                             validator: (String value) {
//                               if (value.isEmpty) {
//                                 return 'Please Enter Valid Title';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text('Question Content'),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10, top: 5, bottom: 5),
//                           child: TextFormField(
//                             controller: questionContentController,
//                             textAlign: TextAlign.left,
//                             maxLines: 6,
//                             decoration: InputDecoration(
//                               hintText: 'Question Content',
//                               border: InputBorder.none,
//                             ),
//                             onSaved: (value) {
//                               questionContent = value;
//                             },
//                             validator: (String value) {
//                               if (value.isEmpty) {
//                                 return 'Please enter valid Question';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 40,
//                       ),
//                       Text('Option 1'),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10, top: 5, bottom: 5),
//                           child: TextFormField(
//                             controller: option1Controller,
//                             textAlign: TextAlign.left,
//                             maxLines: 1,
//                             decoration: InputDecoration(
//                               hintText: 'Option 1',
//                               border: InputBorder.none,
//                             ),
//                             onChanged: (v) {
//                               setState(() {
//                                 option1 = v;
//                               });
//                             },
//                             onSaved: (value) {
//                               option1 = value;
//                             },
//                             validator: (String value) {
//                               if (value.isEmpty) {
//                                 return 'Enter a valid option';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text('Option 2'),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10, top: 5, bottom: 5),
//                           child: TextFormField(
//                             controller: option2Controller,
//                             textAlign: TextAlign.left,
//                             maxLines: 1,
//                             decoration: InputDecoration(
//                               hintText: 'Option 2',
//                               border: InputBorder.none,
//                             ),
//                             onChanged: (v) {
//                               setState(() {
//                                 option2 = v;
//                               });
//                             },
//                             onSaved: (value) {
//                               option2 = value;
//                             },
//                             validator: (String value) {
//                               if (value.isEmpty) {
//                                 return 'Enter a valid option';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text('Option 3'),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10, top: 5, bottom: 5),
//                           child: TextFormField(
//                             controller: option3Controller,
//                             textAlign: TextAlign.left,
//                             maxLines: 1,
//                             decoration: InputDecoration(
//                               hintText: 'Option 3',
//                               border: InputBorder.none,
//                             ),
//                             onChanged: (v) {
//                               setState(() {
//                                 option3 = v;
//                               });
//                             },
//                             onSaved: (value) {
//                               option3 = value;
//                             },
//                             validator: (String value) {
//                               if (value.isEmpty) {
//                                 return 'Enter a valid option';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text('Option 4'),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10, top: 5, bottom: 5),
//                           child: TextFormField(
//                             controller: option4Controller,
//                             textAlign: TextAlign.left,
//                             maxLines: 1,
//                             decoration: InputDecoration(
//                               hintText: 'Option 4',
//                               border: InputBorder.none,
//                             ),
//                             onChanged: (v) {
//                               setState(() {
//                                 option4 = v;
//                               });
//                             },
//                             onSaved: (value) {
//                               option1 = value;
//                             },
//                             validator: (String value) {
//                               if (value.isEmpty) {
//                                 return 'Enter a valid option';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Correct Answer'),
//                           SizedBox(
//                             width: 30,
//                           ),
//                           DropdownButton(
//                             onChanged: (v) {
//                               setState(() {
//                                 correctValue = v;
//                                 print(v);
//                                 if (v == 0) {
//                                   correctAnswer = option1Controller.text;
//                                 } else if (v == 1) {
//                                   correctAnswer = option2Controller.text;
//                                 } else if (v == 2) {
//                                   correctAnswer = option3Controller.text;
//                                 } else if (v == 3) {
//                                   correctAnswer = option4Controller.text;
//                                 }
//                                 print(correctAnswer);
//                               });
//                             },
//                             value: correctValue,
//                             items: [
//                               DropdownMenuItem(
//                                 child: Text(option1Controller.text),
//                                 value: 0,
//                               ),
//                               DropdownMenuItem(
//                                 child: Text(option2Controller.text),
//                                 value: 1,
//                               ),
//                               DropdownMenuItem(
//                                 child: Text(option3Controller.text),
//                                 value: 2,
//                               ),
//                               DropdownMenuItem(
//                                 child: Text(option4Controller.text),
//                                 value: 3,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               isUploading
//                   ? Container()
//                   : GestureDetector(
//                       onTap: () {
//                         saveData(context);
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         width: MediaQuery.of(context).size.width * 0.8,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.blue,
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Text(
//                             'Save',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 17,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
