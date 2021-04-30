import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugc_notes_admin/providers/addNewCourseProvider.dart';
import 'package:ugc_notes_admin/screens/UnitsScreen.dart';
import 'package:ugc_notes_admin/screens/addCoursesNameScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewCourseProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add courses'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNewCourseNameAndIdScreen()));
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'All Availible Courses',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('AllCourses')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final coursesData = snapshot.data.docs;
                  return ListView.builder(
                      itemCount: coursesData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UnitsScreen(
                                          courseId: coursesData[index]
                                              ['courseId'],
                                        )));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Course Code: ${coursesData[index]['courseId']}',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Course Name: ${coursesData[index]['courseName']}',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Exams In: ${coursesData[index]['examIn']} Days',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Total Units: ${coursesData[index]['totalUnits']}',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Total Topics: ${coursesData[index]['totalTopics']}',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Total Cards: ${coursesData[index]['totalCards']}',
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              )),
            ],
          ),
        ));
  }
}
