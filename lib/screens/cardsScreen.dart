import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ugc_notes_admin/Models/cardModel.dart';
import 'package:ugc_notes_admin/Models/topicModel.dart';

class CardsScreen extends StatefulWidget {
  final CourseTopics courseTopics;

  const CardsScreen({this.courseTopics});
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  bool isLoading = false;
  List<CardModel> allCards = [];

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

  saveCards(
    String cardPic,
    String cardHeading1,
    String cardContent1,
    String cardHeading2,
    String cardContent2,
  ) async {
    CardModel cardModel = CardModel(
      cardId: (allCards.length + 1).toString(),
    );

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
      'topicId': widget.courseTopics.topicId,
      'cardId': cardModel.cardId,
      'imageUrl': cardPic,
      'cardHeading1': cardHeading1,
      'cardContent1': cardContent1,
      'cardHeading2': cardHeading2,
      'cardContent2': cardContent2,
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
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.add),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => EnterCardData(
        //               saveData: saveCards,
        //             ),
        //           ),
        //         );
        //       }),
        // ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 15);
                  },
                  itemCount: allCards.length,
                  itemBuilder: (context, index) {
                    final htmlData = allCards[index].cardContent;
                    return GestureDetector(
                      onTap: () {},
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
                                Html(
                                  data: htmlData,
                                  onLinkTap: (url) {
                                    print("Opening $url...");
                                  },
                                  onImageTap: (src) {
                                    print(src);
                                  },
                                  onImageError: (exception, stackTrace) {
                                    print(exception);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
