import 'package:flutter/material.dart';
import 'package:game_template/games/audio_memory/controllers/numbers_memory_controller.dart';
import 'package:get/get.dart';
import '/helpers/colors.dart';
import '/helpers/phone_properties.dart';
import '/helpers/timer.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ShowAudioNumber extends StatefulWidget {
  ShowAudioNumber({Key? key}) : super(key: key);

  @override
  _ShowAudioNumberState createState() => _ShowAudioNumberState();
}

class _ShowAudioNumberState extends State<ShowAudioNumber> {
  late AudioMemoryController c;

  late BuildContext context;

  initializeValues() {
    c = Get.find();
    c.onShowNumberPage = true;
  }

  @override
  void dispose() {
    c.onShowNumberPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    context = buildContext;
    initializeValues();
    startLevel();
    return Scaffold(
      backgroundColor: MyColors.myBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Phone.width(context) / 3),
              child: buildProgressBar(),
            ),
          ],
        ),
      ),
    );
  }

  startLevel() {
    c.valueController.numberGenerator();
    MyTimer.startTimer(
      milliseconds: c.valueController.levelSecond,
      onFinished: () => c.selectAskNumberPage(),
    );
  }

  Widget buildProgressBar() {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(180 / 360),
      child: LinearPercentIndicator(
        width: Phone.width(context) / 3,
        lineHeight: 5,
        animation: true,
        animationDuration: c.valueController.levelSecond,
        percent: 1,
        linearStrokeCap: LinearStrokeCap.butt,
        backgroundColor: Colors.white,
        progressColor: Colors.grey,
      ),
    );
  }
}