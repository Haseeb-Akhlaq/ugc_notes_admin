class QuestionModel {
  String questionId;
  String questionTitle;
  String questionContent;

  String option1;
  String option2;
  String option3;
  String option4;

  String correctAnswer;

  QuestionModel(
      {this.correctAnswer,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.questionContent,
      this.questionId,
      this.questionTitle});

  QuestionModel.fromMap(Map<dynamic, dynamic> map) {
    this.questionId = map['questionId'];
    this.questionTitle = map['questionTitle'] ?? '';
    this.questionContent = map['questionContent'] ?? '';
    this.option1 = map['option1'] ?? '';
    this.option2 = map['option2'];
    this.option3 = map['option3'];
    this.option4 = map['option4'] ?? '';
    this.correctAnswer = map['correctAnswer'];
  }
}
