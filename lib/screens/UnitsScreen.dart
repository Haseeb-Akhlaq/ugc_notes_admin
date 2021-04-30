import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ugc_notes_admin/Models/unitModel.dart';
import 'package:ugc_notes_admin/screens/topicsScreen.dart';

class UnitsScreen extends StatefulWidget {
  final String courseId;

  const UnitsScreen({this.courseId});

  @override
  _UnitsScreenState createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  List<CourseUnitModel> allUnits = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String unitName = '';

  bool isLoading = false;

  incrementUnitInCourse() async {
    final unitData = await FirebaseFirestore.instance
        .collection('AllCourses')
        .doc(widget.courseId)
        .get();

    int currentUnits = int.parse(unitData.data()['totalUnits']);

    await FirebaseFirestore.instance
        .collection('AllCourses')
        .doc(widget.courseId)
        .update({
      'totalUnits': (currentUnits + 1).toString(),
    });
  }

  saveUnits() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    CourseUnitModel courseUnitModel = CourseUnitModel(
        unitId: (allUnits.length + 1).toString(),
        unitName: unitName,
        courseId: widget.courseId);

    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('CourseUnitsContent')
        .doc(widget.courseId)
        .collection('AllUnitsContent')
        .doc(courseUnitModel.unitId)
        .set({
      'unitId': courseUnitModel.unitId,
      'courseId': courseUnitModel.courseId,
      'unitName': courseUnitModel.unitName,
      'numberOfTopics': '0',
      'numberOfCards': '0',
    });
    await incrementUnitInCourse();
    allUnits = [];
    fetchAvailableUnits();
    setState(() {
      isLoading = false;
    });
  }

  fetchAvailableUnits() async {
    setState(() {
      isLoading = true;
    });
    final unitData = await FirebaseFirestore.instance
        .collection('CourseUnitsContent')
        .doc(widget.courseId)
        .collection('AllUnitsContent')
        .get();

    if (unitData.docs.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    unitData.docs.forEach((element) {
      allUnits.add(CourseUnitModel.fromMap(element.data()));
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAvailableUnits();
  }

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
                                      Text('Enter New Unit'),
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
                                              hintText: 'Unit Name',
                                              border: InputBorder.none,
                                            ),
                                            onSaved: (value) {
                                              unitName = value;
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
                                  saveUnits();
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
              })
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: allUnits.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopicsScreen(
                                  courseUnitModel: allUnits[index],
                                )));

                    print('result');
                    if (result == null) {
                      allUnits = [];
                      fetchAvailableUnits();
                    }
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(allUnits[index].unitId),
                            Text(allUnits[index].unitName),
                            Column(
                              children: [
                                Text(
                                    '   Total Topics =  ${allUnits[index].numberOfTopics}'),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    'Total Cards = ${allUnits[index].numberOfCards}'),
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
