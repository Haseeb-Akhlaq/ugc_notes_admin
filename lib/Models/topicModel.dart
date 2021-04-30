class CourseTopics {
  String courseId;
  String unitId;
  String topicId;
  String topicName;
  String numberOfCards;

  CourseTopics(
      {this.numberOfCards,
      this.topicName,
      this.topicId,
      this.courseId,
      this.unitId});

  CourseTopics.fromMap(Map<dynamic, dynamic> map) {
    this.courseId = map['courseId'];
    this.unitId = map['unitId'] ?? '';
    this.topicId = map['topicId'] ?? '';
    this.numberOfCards = map['numberOfCards'] ?? '';
    this.topicName = map['topicName'] ?? '';
  }
}
