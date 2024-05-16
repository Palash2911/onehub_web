import 'package:flutter/material.dart';
import 'package:onehub_web/result_screen.dart';
import 'package:onehub_web/state.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'Pixel_Quiz_Screen.dart';
import 'answer_card.dart';
import 'next_button.dart';

class QuizQuestionScreen extends StatelessWidget {
  const QuizQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<DataState>(context);

    //  String str = questionIndex.toString();

    final screenWidth = MediaQuery.sizeOf(context).width;
    bool isLastQuestion =
        stateData.questionIndex == stateData.questions.length - 1;
    final question = stateData.questions[stateData.questionIndex];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 410,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Image.asset(
                      'assets/images/share1.png',
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 170,
                      height: 70,
                      padding: const EdgeInsets.all(19),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 3.93,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(''
                              'assets/images/timer.png'),
                          const SizedBox(width: 9.24),
                          Countdown(
                            seconds: stateData.countDownTime,
                            build: (BuildContext context, double time) {
                                          // Convert time to minutes and seconds
                              int seconds = time.floor() % 60;
                              String secondsStr = seconds.toString().padLeft(
                                  2, '0'); // Add leading zero if needed
                              return Text(
                                '00:$secondsStr',
                                style: const TextStyle(
                                  color: Color(0xFF3F3F3F),
                                  fontSize: 30,
                                  fontFamily: 'Google Sans',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              );
                            },
                            interval: const Duration(seconds: 1),
                            onFinished: () {
                              stateData.goToNextQuestion();
                              if (isLastQuestion) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => ResultScreen(
                                      score: stateData.score,
                                      questions: stateData.questions,
                                    ),
                                  ),
                                );
                              }
                                          // _controller.restart();
                            },
                            controller: stateData.controller,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text(
                  (stateData.questionIndex + 1).toString() + '/10',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Google Sans',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                const Spacer(),
                const Opacity(
                  opacity: 0.60,
                  child: Text(
                    '(10 points)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Google Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              question['question'],
              style: const TextStyle(
                color: Color(0xFF3E3E3E),
                fontSize: 30,
                fontFamily: 'GoogleSans',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: question['options'].length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: stateData.selectedAnswerIndex == null
                      ? () => stateData.pickAnswer(index)
                      : null,
                  child: AnswerCard(
                    currentIndex: index,
                    question: question['options'][index],
                    isSelected: stateData.selectedAnswerIndex == index,
                    selectedAnswerIndex: stateData.selectedAnswerIndex,
                    correctAnswerIndex: question['correctAnswerIndex'],
                  ),
                );
              },
            ),
// Next Button
            isLastQuestion
                ? RectangularButton(
                    onPressed: () {
                      stateData.pickAnswer(-1);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => ResultScreen(
                            score: stateData.score,
                            questions: stateData.questions,
                          ),
                        ),
                      );
                    },
                    label: 'Finish',
                  )
                : RectangularButton(
                    onPressed: stateData.selectedAnswerIndex == null
                        ? stateData.goToNextQuestion
                        : null,
                    label: 'Skip to next',
                  ),
          ],
        ),
      ),
    );
  }
}
