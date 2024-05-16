import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:timer_count_down/timer_controller.dart';

class DataState with ChangeNotifier {
  final contestCollection =
      FirebaseFirestore.instance.collection("test-contests");
  List<QueryDocumentSnapshot> contests = [];

  String? jsonLink;

  bool isQuestionsFetched = false;
  Future<void> fetchContests() async {
    try {
      final QuerySnapshot snapshot =
          await contestCollection.orderBy('order').get();
      contests = snapshot.docs;
      print(contests);

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
    // await fetchContests();
    // if (jsonLink == null) {
    //   return [];
    // }
    try {
      final response = await http.get(Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/tsm-ecf9e.appspot.com/o/contest-questions%2Fcontest1-questions.json?alt=media&token=48727f3c-4624-49b8-ae26-c1e97d829f33'));
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

  Future<void> fetchRewards(userPoints, cId, tId) async {
    try {
      final uri = Uri.parse(
              'https://gcptest.testexperience.site/getContestRewards_testing')
          .replace(
        queryParameters: {
          'contest_id': cId.toString(),
          'territory_id': tId.toString(),
          'user_points': userPoints.toString(),
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final value = jsonDecode(response.body);
        rewardImageUrl = value['url'] ?? '';
        print(value);
        rewardText = value['reward_text'] ?? '';
      } else {
        print('Failed to fetch JSON file. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching JSON file: $e');
    }
    notifyListeners();
  }

  List<dynamic> questions = [];
  String rewardImageUrl = '';
  String rewardText = '';

  int? selectedAnswerIndex;
  int questionIndex = 0;
  int score = 0;
  int countDownTime = 15;
  final CountdownController controller = CountdownController(autoStart: true);
  void pickAnswer(
    int value,
  ) {
    if (value != -1) {
      countDownTime = 4;
      controller.restart();
      selectedAnswerIndex = value;
      final questionCorrectIndex =
          questions[questionIndex]['correctAnswerIndex'];
      if (selectedAnswerIndex == questionCorrectIndex) {
        score++;
      }
    }

    if (questionIndex == (questions.length - 1)) {
      fetchRewards(score, 1, "NewYork, NY");
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
