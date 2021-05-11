// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:ugc_notes_admin/Models/QuestionModel.dart';
// import 'package:ugc_notes_admin/screens/questionsConfigrationScreen.dart';
//
// class AllQuestions extends StatefulWidget {
//   @override
//   _AllQuestionsState createState() => _AllQuestionsState();
// }
//
// class _AllQuestionsState extends State<AllQuestions> {
//   List<QuestionModel> allQuestion = [];
//   bool isLoading = false;
//
//   fetchQuestions() async {
//     setState(() {
//       isLoading = true;
//     });
//     final questions =
//         await FirebaseFirestore.instance.collection('AllQuestions').get();
//     questions.docs.forEach((element) {
//       allQuestion.add(QuestionModel.fromMap(element.data()));
//       print(allQuestion.length);
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     fetchQuestions();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: isLoading
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : ListView.builder(
//                 itemCount: allQuestion.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () async {
//                       final results = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EnterQuestionData(
//                             questionData: allQuestion[index],
//                           ),
//                         ),
//                       );
//                       if (results == null) {
//                         allQuestion = [];
//                         fetchQuestions();
//                       }
//                     },
//                     child: Card(
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: ListTile(
//                           title: Text(allQuestion[index].questionTitle),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//       ),
//     );
//   }
// }
