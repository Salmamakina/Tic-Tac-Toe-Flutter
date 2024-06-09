import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool oTurn = true;
  List<String> gridList = ['', '', '', '', '', '', '', '', ''];
  String result = '';
  int xscore = 0;
  int oscore = 0;
  int filledBoxes = 0;
  bool winnerFound = false;
  Timer? timer;
  static const maxSeconds = 30;
  int seconds = maxSeconds;
  int attemps = 0;
  List <int> matchedIndex= [];

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );
  void StartTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          StopTimer();
        }
      });
    });
  }

  void StopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() {
    seconds = maxSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[100],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Player O',
                          style: customFontWhite,
                        ),
                        Text(
                          oscore.toString(),
                          style: customFontWhite,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Player X',
                          style: customFontWhite,
                        ),
                        Text(
                          xscore.toString(),
                          style: customFontWhite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: GridView.builder(
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _tapped(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 5,
                              color: Color.fromARGB(255, 255, 204, 188),
                            ),
                            color:matchedIndex.contains(index)? Colors.amber[200]: Colors.deepPurple[100],
                          ),
                          child: Center(
                            child: Text(
                              gridList[index],
                              style: GoogleFonts.coiny(
                                textStyle: TextStyle(
                                    fontSize: 64,
                                    color: Colors.deepOrange[100]),
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      result,
                      style: customFontWhite,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildTimer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer() {
    final isRunnig = timer == null ? false : timer!.isActive;
    return isRunnig
        ? SizedBox(
          height:100 ,
          width: 100,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1 - seconds/maxSeconds,
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 8,
                backgroundColor: Colors.red[300],
              ),
              Center(
                child: Text('$seconds', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 40),),
              )
            ],
          ),
        )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange[200],
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 17)),
            onPressed: () {
              StartTimer();
              _clearBoard();
              attemps++;
            },
            child: Text(
              attemps == 0 ? 'Start':
              'Play Again!',
              style: TextStyle(
                fontSize: 23,
                color: Colors.deepPurple[300],
              ),
            ),
          );
  }

  void _tapped(int index) {
    final isRunnig = timer == null ? false : timer!.isActive;
    if(isRunnig){
    setState(() {
      if (oTurn && gridList[index] == '') {
        gridList[index] = '0';
        filledBoxes++;
      } else if (!oTurn && gridList[index] == '') {
        gridList[index] = 'X';
        filledBoxes++;
      }
      oTurn = !oTurn;
      _checkwinner();
    });}
  }

  void _checkwinner() {
    //  1st row
    if (gridList[0] == gridList[1] &&
        gridList[0] == gridList[2] &&
        gridList[0] != '') {
      setState(() {
        result = 'Player ' + gridList[0] + ' Wins!';
        matchedIndex.addAll([0,1,2]);
        StopTimer();
        _updatedScore(gridList[0]);
      });
    }
    // 2nd row
    if (gridList[3] == gridList[4] &&
        gridList[3] == gridList[5] &&
        gridList[3] != '') {
      setState(() {
        result = 'Player ' + gridList[3] + ' Wins!';
        matchedIndex.addAll([3,4,5]);
        StopTimer();
        _updatedScore(gridList[3]);
      });
    }
    // 3rd row
    if (gridList[6] == gridList[7] &&
        gridList[6] == gridList[8] &&
        gridList[6] != '') {
      setState(() {
        result = 'Player ' + gridList[6] + ' Wins!';
        matchedIndex.addAll([6,7,8]);
        StopTimer();
        _updatedScore(gridList[6]);
      });
    }
    //  1st column
    if (gridList[0] == gridList[3] &&
        gridList[0] == gridList[6] &&
        gridList[0] != '') {
      setState(() {
        result = 'Player ' + gridList[0] + ' Wins!';
        matchedIndex.addAll([0,3,6]);
        StopTimer();
        _updatedScore(gridList[0]);
      });
    }
    // 2nd column
    if (gridList[1] == gridList[4] &&
        gridList[1] == gridList[7] &&
        gridList[1] != '') {
      setState(() {
        result = 'Player ' + gridList[1] + ' Wins!';
        matchedIndex.addAll([1,4,7]);
        StopTimer();
        _updatedScore(gridList[1]);
      });
    }

    // 3rd column
    if (gridList[2] == gridList[5] &&
        gridList[2] == gridList[8] &&
        gridList[2] != '') {
      setState(() {
        result = 'Player ' + gridList[2] + ' Wins!';
        matchedIndex.addAll([5,8,2]);
        StopTimer();
        _updatedScore(gridList[2]);
      });
    }
    //1st diagonal
    if (gridList[0] == gridList[4] &&
        gridList[0] == gridList[8] &&
        gridList[0] != '') {
      setState(() {
        result = 'Player ' + gridList[0] + ' Wins!';
        matchedIndex.addAll([0,4,8]);
        StopTimer();
        _updatedScore(gridList[0]);
      });
    }
    // 2nd diagonal
    if (gridList[2] == gridList[4] &&
        gridList[2] == gridList[6] &&
        gridList[2] != '') {
      setState(() {
        result = 'Player ' + gridList[2] + ' Wins!';
        matchedIndex.addAll([4,6,2]);
        StopTimer();
        _updatedScore(gridList[2]);
      });
    }
    if (!winnerFound && filledBoxes == 9) {
      setState(() {
        result = 'Nobody Wins!';
      });
    }
  }

  void _updatedScore(String winner) {
    if (winner == '0') {
      oscore++;
    } else if (winner == 'X') {
      xscore++;
    }
    winnerFound = true;

  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        gridList[i] = '';
      }
      result = '';
    });
    filledBoxes = 0;
  }
}
