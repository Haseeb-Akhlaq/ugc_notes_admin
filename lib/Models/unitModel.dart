class CourseUnitModel {
  String unitId;
  String courseId;
  String unitName;
  String numberOfTopics;
  String numberOfCards;

  CourseUnitModel({
    this.numberOfTopics,
    this.courseId,
    this.numberOfCards,
    this.unitId,
    this.unitName,
  });

  CourseUnitModel.fromMap(Map<dynamic, dynamic> map) {
    this.courseId = map['courseId'];
    this.unitId = map['unitId'] ?? '';
    this.unitName = map['unitName'] ?? '';
    this.numberOfCards = map['numberOfCards'] ?? '';
    this.numberOfTopics = map['numberOfTopics'] ?? '';
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'unitId': unitId,
      'unitName': unitName,
      'numberOfCards': numberOfCards,
      'numberOfTopics': numberOfTopics,
    };
  }
}
