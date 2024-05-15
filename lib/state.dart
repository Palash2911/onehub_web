import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:timer_count_down/timer_controller.dart';

class DataState with ChangeNotifier {
  final contestCollection =
      FirebaseFirestore.instance.collection('test-contests');
  List<QueryDocumentSnapshot> contests = [];

  String? jsonLink;

  bool isQuestionsFetched = false;
  Future<void> fetchContests() async {
    try {
      final QuerySnapshot snapshot =
          await contestCollection.orderBy('order').get();
      contests = snapshot.docs;
      print(contests);

      // Get the jsonLink from the first document
      final jsonLinkDoc =
          snapshot.docs.firstWhere((doc) => doc.get('jsonLink') != null);
      jsonLink = jsonLinkDoc.get('jsonLink');

      print(jsonLink);
      // Trigger a rebuild after fetching data
      notifyListeners();
    } catch (error) {
      print('Error fetching image URLs: $error');
    }
  }

  // fetch questions from json to a list
  Future<List<dynamic>> fetchQuestionsFromJsonLink() async {
    await fetchContests();
    if (jsonLink == null) {
      return [];
    }

    try {
      final response = await http.get(Uri.parse(jsonLink!));
      if (response.statusCode == 200) {
        final value = jsonDecode(response.body);

        questions = value;
        isQuestionsFetched = true;
        return value;
      } else {
        print('Failed to fetch JSON file. Error: ${response.statusCode}');
        questions = [];
        return [];
      }
    } catch (e) {
      print('Error fetching JSON file: $e');
      questions = [];
      return [];
    }
  }

  List<dynamic> questions = [];

  int? selectedAnswerIndex;
  int questionIndex = 0;
  int score = 0;
  int countDownTime = 15;
  final CountdownController controller = CountdownController(autoStart: true);
  void pickAnswer(
    int value,
  ) {
    countDownTime = 4;
    controller.restart();
    selectedAnswerIndex = value;
    final question = questions[questionIndex];
    if (selectedAnswerIndex == question) {
      score++;
    }

    notifyListeners();
  }

  void goToNextQuestion() {
    if (questionIndex < questions.length - 1) {
      questionIndex++;
      selectedAnswerIndex = null;
      countDownTime = 15;
      controller.restart();
    }
    notifyListeners();
  }
}
