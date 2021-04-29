import 'package:flutter/material.dart';
import 'package:ugc_notes_admin/Models/cardModel.dart';
import 'package:ugc_notes_admin/Models/course.dart';
import 'package:ugc_notes_admin/Models/topicModel.dart';
import 'package:ugc_notes_admin/Models/unitModel.dart';

class AddNewCourseProvider extends ChangeNotifier {
  CourseUnits newUnit = CourseUnits(
      unitId: '1',
      numberOfCards: '3',
      numberOfTopics: '2',
      unitName: 'Default',
      allTopics: []);

  CourseTopics newTopic = CourseTopics(
    topicId: '1',
    topicName: 'default',
    numberOfCards: '2',
    topicCard: [],
  );

  CardModel newCard =
      CardModel(cardId: '1', cardContent: 'Hi This is Topic 1 and');

  Course newCourse = Course(
    courseId: '1',
    courseName: 'Default',
    daysLeftToExams: '10',
    numberOfCards: '21',
    numberOfTopics: '12',
    numberOfUnits: '21',
    allUnits: [],
  );

  List<CardModel> cards = [];

  setNewCourseNameAndId(String name, String id) {
    newCourse.courseName = name;
    newCourse.courseId = id;

    print(newCourse.courseId);
  }

  setNewUnitName(String name) {
    newUnit.unitId = (newCourse.allUnits.length + 1).toString();
    newUnit.unitName = name;
  }

  setNewTopicName(String name) {
    newTopic.topicName = name;
    newTopic.topicId = (newUnit.allTopics.length).toString();
  }

  addAllCards(List cards) {
    newTopic.topicCard = cards;
    newTopic.numberOfCards = cards.length.toString();
  }
}
