class CardModel {
  String courseId;
  String unitId;
  String topicId;
  String cardId;
  String cardContent;

  CardModel(
      {this.cardId,
      this.cardContent,
      this.topicId,
      this.unitId,
      this.courseId});

  CardModel.fromMap(Map<dynamic, dynamic> map) {
    this.courseId = map['courseId'];
    this.unitId = map['unitId'] ?? '';
    this.topicId = map['topicId'] ?? '';
    this.cardId = map['cardId'] ?? '';
    this.cardContent = map['cardContent'] ?? '';
  }
}
