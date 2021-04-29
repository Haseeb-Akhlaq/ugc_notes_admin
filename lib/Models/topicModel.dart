import 'package:ugc_notes_admin/Models/cardModel.dart';

class CourseTopics {
  String topicId;
  String topicName;
  String numberOfCards;
  List<CardModel> topicCard;

  CourseTopics(
      {this.numberOfCards, this.topicName, this.topicId, this.topicCard});
}
