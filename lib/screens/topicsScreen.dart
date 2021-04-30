import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ugc_notes_admin/Models/topicModel.dart';
import 'package:ugc_notes_admin/Models/unitModel.dart';
import 'package:ugc_notes_admin/screens/cardsScreen.dart';

class TopicsScreen extends StatefulWidget {
  final CourseUnitModel courseUnitModel;

  const TopicsScreen({this.courseUnitModel});

  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  List<CourseTopics> allTopics = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String topicName;

  bool isLoading = false;

  incrementTopicInCourse() async {
    final unitData = await FirebaseFirestore.instance
        .collection('AllCourses')
        .doc(widget.courseUnitModel.courseId)
        .get();

    int currentTopics = int.parse(unitData.data()['totalTopics']);

    await FirebaseFirestore.instance
        .collection('AllCourses')
        .doc(widget.courseUnitModel.courseId)
        .update({
      'totalTopics': (currentTopics + 1).toString(),
    });
  }

  saveTopics() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    CourseTopics courseTopics = CourseTopics(
        unitId: widget.courseUnitModel.unitId,
        topicId: (allTopics.length + 1).toString(),
        courseId: widget.courseUnitModel.courseId,
        topicName: topicName);

    print('ddddddddddddddddddddddddddddddddddddd');

    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('CourseTopicsContent')
        .doc(widget.courseUnitModel.courseId)
        .collection('TopicsByunits')
        .doc(widget.courseUnitModel.unitId)
        .collection('allTopics')
        .doc(courseTopics.topicId)
        .set({
      'unitId': widget.courseUnitModel.unitId,
      'courseId': widget.courseUnitModel.courseId,
      'topicId': courseTopics.topicId,
      'topicName': courseTopics.topicName,
      'numberOfCards': '0',
    });

    await incrementTopicInCourse();

    allTopics = [];

    fetchAvailableTopics();

    setState(() {
      isLoading = false;
    });
  }

  fetchAvailableTopics() async {
    setState(() {
      isLoading = true;
    });
    final unitData = await FirebaseFirestore.instance
        .collection('CourseTopicsContent')
        .doc(widget.courseUnitModel.courseId)
        .collection('TopicsByunits')
        .doc(widget.courseUnitModel.unitId)
        .collection('allTopics')
        .get();

    if (unitData.docs.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    unitData.docs.forEach((element) {
      allTopics.add(CourseTopics.fromMap(element.data()));
    });

    await FirebaseFirestore.instance
        .collection('CourseUnitsContent')
        .doc(widget.courseUnitModel.courseId)
        .collection('AllUnitsContent')
        .doc(widget.courseUnitModel.unitId)
        .update({
      'numberOfTopics': allTopics.length.toString(),
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchAvailableTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Topics For ${widget.courseUnitModel.unitName}'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Enter New Topic'),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: TextFormField(
                                            textAlign: TextAlign.left,
                                            maxLines: 10,
                                            decoration: InputDecoration(
                                              hintText: 'Topic Name',
                                              border: InputBorder.none,
                                            ),
                                            onSaved: (value) {
                                              topicName = value;
                                            },
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Please enter valid Card Content';
                                              }
                                              if (value.length < 4) {
                                                return 'Please Enter Content greater than 4 characters';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  saveTopics();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Add Card',
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
                  },
                );
              }),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: allTopics.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CardsScreen(
                                  courseTopics: allTopics[index],
                                )));

                    print('result');
                    if (result == null) {
                      allTopics = [];
                      fetchAvailableTopics();
                    }
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(allTopics[index].topicId),
                            Text(allTopics[index].topicName),
                            Column(
                              children: [
                                Text(
                                    '   Total Cards =  ${allTopics[index].numberOfCards}'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
