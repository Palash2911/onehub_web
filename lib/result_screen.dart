import 'package:flutter/material.dart';
import 'package:onehub_web/state.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  List<dynamic> questions;
  ResultScreen({super.key, required this.score, required this.questions});

  final int score;

  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<DataState>(context, listen: false);
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              stateData.rewardImageUrl.isNotEmpty
                  ? Image.network(stateData.rewardImageUrl)
                  : const SizedBox(width: 1),
              const Text(
                'Your Score: ',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      value: score / 9,
                      color: Colors.green,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        score.toString(),
                        style: const TextStyle(fontSize: 80),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),
                      Text(
                        '${(score / questions.length * 100).round()}%',
                        style: const TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                stateData.rewardText.isNotEmpty ? stateData.rewardText : '',
                style: const TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
