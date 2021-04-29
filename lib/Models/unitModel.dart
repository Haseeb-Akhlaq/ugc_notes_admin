import 'package:ugc_notes_admin/Models/topicModel.dart';

class CourseUnits {
  String unitId;
  String unitName;
  String numberOfTopics;
  String numberOfCards;
  List<CourseTopics> allTopics;

  CourseUnits(
      {this.numberOfTopics,
      this.numberOfCards,
      this.unitId,
      this.unitName,
      this.allTopics});

  Map<dynamic, dynamic> toJson() {
    return {
      'unitId': unitId,
      'unitName': unitName,
      'numberOfCards': numberOfCards,
      'numberOfTopics': numberOfTopics,
    };
  }
}
