import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'brain.dart';

QBrain qBrain = QBrain();
void main() {
  runApp(Quizzler());
}

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> score = [];
  bool checker = true;
  int correctAns = 0;
  int totalQues = 0;

  void check(bool user) {
    bool correct = qBrain.getAns();
    setState(
      () {
        if (qBrain.finished() == true) {
          correctAns += user == correct ? 1 : 0;
          totalQues += 1;
          Alert(
            style: AlertStyle(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.9,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
            context: context,
            title: 'FINISHED!',
            desc: 'You scored $correctAns/$totalQues',
            buttons: [
              DialogButton(
                child: Text(
                  'DONE',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ).show();
          qBrain.reset();
          correctAns = 0;
          totalQues = 0;
          score = [];
          checker = true;
        } else {
          if (user == correct) {
            totalQues++;
            correctAns++;
            score.add(
              Icon(
                Icons.check,
                color: Colors.green,
                size: MediaQuery.of(context).size.width * 0.07,
              ),
            );
          } else {
            totalQues++;
            score.add(
              Icon(
                Icons.close,
                color: Colors.red,
                size: MediaQuery.of(context).size.width * 0.07,
              ),
            );
          }

          qBrain.next();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void adjustBottomRowHeight() {
      score.add(
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.07,
        ),
      );
    }

    adjustBottomRowHeight();

    if (checker) {
      qBrain.shuffleQuestions();
      checker = false;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                qBrain.getText(),
                style: TextStyle(color: Colors.white, fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.green,
              textColor: Colors.white70,
              onPressed: () {
                check(true);
              },
              child: Text(
                'True',
                style: TextStyle(color: Colors.white70, fontSize: 25.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              textColor: Colors.white70,
              onPressed: () {
                check(false);
              },
              child: Text(
                'False',
                style: TextStyle(color: Colors.white70, fontSize: 25.0),
              ),
            ),
          ),
        ),
        Row(
          children: score,
        )
      ],
    );
  }
}
