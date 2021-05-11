class CardModel {
  String cardId;
  String topicId;
  String unitId;
  String courseId;
  String cardContent;

  CardModel({
    this.unitId,
    this.topicId,
    this.courseId,
    this.cardContent,
    this.cardId,
  });

  CardModel.fromMap(Map<dynamic, dynamic> map) {
    this.courseId = map['courseId'];
    this.unitId = map['unitId'] ?? '';
    this.topicId = map['topicId'] ?? '';
    this.cardContent = map['CARD'] ?? '';
    this.cardId = map['cardId'];
  }
}
