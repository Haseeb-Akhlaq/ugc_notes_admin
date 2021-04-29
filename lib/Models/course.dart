import 'package:ugc_notes_admin/Models/unitModel.dart';

class Course {
  String courseId;
  String courseName;
  String numberOfUnits;
  String numberOfTopics;
  String numberOfCards;
  String daysLeftToExams;
  List<CourseUnits> allUnits;

  Course(
      {this.courseId,
      this.courseName,
      this.daysLeftToExams,
      this.numberOfCards,
      this.numberOfTopics,
      this.numberOfUnits,
      this.allUnits});

  Map<dynamic, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'daysLeftToExams': daysLeftToExams,
      'numberOfCards': numberOfCards,
      'numberOfTopics': numberOfTopics,
      'numberOfUnits': numberOfUnits,
    };
  }
}
