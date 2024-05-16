import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onehub_web/Pixel_Quiz_Screen.dart';
import 'package:onehub_web/answer_card.dart';
import 'package:onehub_web/next_button.dart';
import 'package:onehub_web/quiz_questions.dart';

import 'package:onehub_web/result_screen.dart';
import 'package:onehub_web/state.dart';
import 'package:provider/provider.dart';

import 'package:timer_count_down/timer_count_down.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<DataState>(context, listen: false);

    //  String str = questionIndex.toString();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Pixel Quiz',
            style: TextStyle(
              color: Color(0xFF212326),
              fontSize: 25,
              fontFamily: 'Google Sans',
              fontWeight: FontWeight.w500,
              height: 0.02,
              letterSpacing: -0.96,
            ),
          ),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: stateData.fetchQuestionsFromJsonLink(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return QuizQuestionScreen();
            }
          },
        ));
  }
}
