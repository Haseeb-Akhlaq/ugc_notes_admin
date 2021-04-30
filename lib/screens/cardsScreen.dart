import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ugc_notes_admin/Models/cardModel.dart';
import 'package:ugc_notes_admin/Models/topicModel.dart';

class CardsScreen extends StatefulWidget {
  final CourseTopics courseTopics;

  const CardsScreen({this.courseTopics});
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cardContent;
  List<CardModel> allCards = [];
  bool isLoading = false;

  incrementCardsInCourse() async {
    final unitData = await FirebaseFirestore.instance
        .collection('AllCourses')
        .doc(widget.courseTopics.courseId)
        .get();

    int currentCards = int.parse(unitData.data()['totalCards']);

    await FirebaseFirestore.instance
        .collection('AllCourses')
        .doc(widget.courseTopics.courseId)
        .update({
      'totalCards': (currentCards + 1).toString(),
    });
  }

  incrementCardsInUnits() async {
    final unitData = await FirebaseFirestore.instance
        .collection('CourseUnitsContent')
        .doc(widget.courseTopics.courseId)
        .collection('AllUnitsContent')
        .doc(widget.courseTopics.unitId)
        .get();

    int currentCards = int.parse(unitData.data()['numberOfCards']);

    await FirebaseFirestore.instance
        .collection('CourseUnitsContent')
        .doc(widget.courseTopics.courseId)
        .collection('AllUnitsContent')
        .doc(widget.courseTopics.unitId)
        .update({
      'numberOfCards': (currentCards + 1).toString(),
    });
  }

  saveCards() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    CardModel cardModel = CardModel(
      cardId: (allCards.length + 1).toString(),
      cardContent: cardContent,
    );

    print('ddddddddddddddddddddddddddddddddddddd');

    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('CourseCardsContent')
        .doc(widget.courseTopics.courseId)
        .collection('CardsByUnits')
        .doc(widget.courseTopics.unitId)
        .collection('CardsByTopic')
        .doc(widget.courseTopics.topicId)
        .collection('AllCards')
        .doc(cardModel.cardId)
        .set({
      'unitId': widget.courseTopics.unitId,
      'courseId': widget.courseTopics.courseId,
      'cardId': cardModel.cardId,
      'cardContent': cardModel.cardContent,
    });

    await incrementCardsInUnits();
    await incrementCardsInCourse();

    allCards = [];
    fetchAvailableCards();
    setState(() {
      isLoading = false;
    });
  }

  fetchAvailableCards() async {
    setState(() {
      isLoading = true;
    });
    final cardData = await FirebaseFirestore.instance
        .collection('CourseCardsContent')
        .doc(widget.courseTopics.courseId)
        .collection('CardsByUnits')
        .doc(widget.courseTopics.unitId)
        .collection('CardsByTopic')
        .doc(widget.courseTopics.topicId)
        .collection('AllCards')
        .get();

    if (cardData.docs.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    cardData.docs.forEach((element) {
      allCards.add(CardModel.fromMap(element.data()));
    });

    await FirebaseFirestore.instance
        .collection('CourseTopicsContent')
        .doc(widget.courseTopics.courseId)
        .collection('TopicsByunits')
        .doc(widget.courseTopics.unitId)
        .collection('allTopics')
        .doc(widget.courseTopics.topicId)
        .update({
      'numberOfCards': allCards.length.toString(),
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAvailableCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards For ${widget.courseTopics.topicName}'),
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
                                      Text('Enter Card Content'),
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
                                              hintText: 'Card Content',
                                              border: InputBorder.none,
                                            ),
                                            onSaved: (value) {
                                              cardContent = value;
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
                                  saveCards();
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
              itemCount: allCards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CardsScreen(
                    //           courseTopics:allTopics[index],
                    //         )));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Card No:   ${allCards[index].cardId}'),
                            SizedBox(
                              height: 20,
                            ),
                            Text(allCards[index].cardContent),
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
