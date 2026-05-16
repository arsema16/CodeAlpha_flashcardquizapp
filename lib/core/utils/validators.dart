import '../constants/app_constants.dart';

class Validators {
  static String? validateQuestion(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a question';
    }
    if (value.length > AppConstants.maxQuestionLength) {
      return 'Question too long (max ${AppConstants.maxQuestionLength} chars)';
    }
    return null;
  }

  static String? validateAnswer(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an answer';
    }
    if (value.length > AppConstants.maxAnswerLength) {
      return 'Answer too long (max ${AppConstants.maxAnswerLength} chars)';
    }
    return null;
  }
}