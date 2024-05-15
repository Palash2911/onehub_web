import 'package:flutter/material.dart';

class PixelQuiz extends StatefulWidget {
  const PixelQuiz({Key? key}) : super(key: key);

  @override
  State<PixelQuiz> createState() => _PixelQuizState();
}

class _PixelQuizState extends State<PixelQuiz> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _showBottomSheet(
          context); // Call _showBottomSheet after the first frame is built
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          height: 350,
          width: double.infinity,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Row(
                children: [
                  Image(
                    image: AssetImage("assets/images/google_logo.png"),
                  ),
                  Text("Pixel Quiz", style: TextStyle(fontSize: 30)),
                ],
              ),
              SizedBox(height: 20.0),
              Text("+70 Points", style: TextStyle(fontSize: 40)),
              Text("You earned 70 points, redeem them in store",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 30.0),
              Center(
                child: Image(
                  height: 100,
                  width: 300,
                  image: AssetImage("assets/images/home_btn.png"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Image(
            height: 150,
            width: 150,
            fit: BoxFit.cover,
            image: AssetImage("assets/images/signout_btn.png"),
          ),
        ],
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.grey,
          ),
        ),
        title: IconButton(
          onPressed: () {
            _showBottomSheet(context);
          },
          icon: const Text(
            "Pixel Quiz",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        child: const Column(
          children: [
            Image(
              image: AssetImage("assets/images/Congo-Card.png"),
            ),
          ],
        ),
      ),
    );
  }
}
