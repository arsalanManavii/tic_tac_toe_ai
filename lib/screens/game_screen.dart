import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe_ai_version/constants/colors.dart';

class GameScreen extends StatefulWidget {
  GameScreen({super.key, this.XorO, this.player});
  String? XorO;
  String? player;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? XorO = '';
  String? player;
  List<String> board = ['', '', '', '', '', '', '', '', ''];

  bool? isXTurn;
  bool gameHasResult = false;
  String winnerTitle = '';
  String whoIsWon = '';
  int scoreX = 0;
  int scoreO = 0;
  int draws = 0;
  int filledBox = 0;

  @override
  void initState() {
    super.initState();
    XorO = widget.XorO;
    player = widget.player;
    isXTurn = _xOroFunction(XorO!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _getTopRow(),
            _getGridLayout(),
            _getScoreBoard(),
            SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }

  Widget _getTopRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Text(
                'x',
                style: GoogleFonts.signikaNegative(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 50.0,
                  ),
                ),
              ),
              SizedBox(width: 3.0),
              Text(
                'o',
                style: GoogleFonts.signikaNegative(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                    fontSize: 50.0,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            height: 40.0,
            width: 80.0,
            decoration: BoxDecoration(
              color: blueGrey800,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isXTurn! ? 'x' : 'o',
                  style: GoogleFonts.signikaNegative(
                    textStyle: TextStyle(
                      color: grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ),
                SizedBox(width: 4.0),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(
                    'TURN',
                    style: GoogleFonts.signikaNegative(
                      textStyle: TextStyle(
                        color: grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _clearBoard(),
            child: Container(
              margin: EdgeInsets.only(top: 9.0),
              height: 45.0,
              width: 45.0,
              decoration: BoxDecoration(
                color: blueGrey200,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.refresh,
                  color: blueGrey800,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getGridLayout() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
        child: GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 15, crossAxisSpacing: 15),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (player == 'Ply') {
                  if (board[index] == '' && !gameHasResult) {
                    setState(
                      () {
                        if (isXTurn!) {
                          board[index] = 'X';
                          isXTurn = !isXTurn!;
                        } else {
                          board[index] = 'O';
                          isXTurn = !isXTurn!;
                        }

                        filledBox++;
                        _checkWinner();
                      },
                    );
                  }
                } else if (player == 'Cpu') {
                  if (board[index] == '' && !gameHasResult) {
                    setState(() {
                      if (isXTurn!) {
                        board[index] = 'X';
                        isXTurn = !isXTurn!;
                      } else {
                        board[index] = 'O';
                        isXTurn = !isXTurn!;
                      }

                      filledBox++;
                      _checkWinner();
                      //ai move
                      if (!gameHasResult &&
                          isXTurn! &&
                          !board.every((element) => element != '')) {
                        int bestMove = _findBestMove();
                        if (bestMove != -1) {
                          board[bestMove] = 'X'; //needs change(x or o)
                          isXTurn = !isXTurn!;
                          filledBox++;
                          _checkWinner();
                        }
                      } else if (!gameHasResult &&
                          !isXTurn! &&
                          !board.every((element) => element != '')) {
                        int bestMove = _findBestMove();
                        if (bestMove != -1) {
                          board[bestMove] = 'O';
                          isXTurn = !isXTurn!;
                          filledBox++;
                          _checkWinner();
                        }
                      }
                    });
                  }
                }

                if (gameHasResult) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return WillPopScope(
                        onWillPop: () {
                          throw ();
                        },
                        child: _getWinnerDialog(),
                      );
                    },
                  );
                } else {
                  return;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[800],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Center(
                    child: Text(
                  board[index],
                  style: GoogleFonts.signikaNegative(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getColor(index),
                        fontSize: 50.0),
                  ),
                )),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getScoreBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 100.0,
          height: 75.0,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                XorO == 'X' ? 'X (You)' : 'X ($player)',
                style: GoogleFonts.signikaNegative(
                  textStyle: TextStyle(
                    color: darkGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Text(
                '$scoreX',
                style: TextStyle(
                  color: darkGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 100.0,
          height: 75.0,
          decoration: BoxDecoration(
            color: blueGrey200,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Draws',
                style: GoogleFonts.signikaNegative(
                  textStyle: TextStyle(
                    color: darkGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Text(
                '$draws',
                style: TextStyle(
                  color: darkGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 100.0,
          height: 75.0,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                XorO == 'X' ? 'O ($player)' : 'O (You)',
                style: GoogleFonts.signikaNegative(
                  textStyle: TextStyle(
                    color: darkGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Text(
                '$scoreO',
                style: TextStyle(
                  color: darkGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Color _getColor(int index) {
    if (board[index] == 'X') {
      return primaryColor;
    } else {
      return secondaryColor;
    }
  }

  void _clearBoard() {
    setState(
      () {
        for (var i = 0; i <= 8; i++) {
          board[i] = '';
        }
        gameHasResult = false;
        filledBox = 0;
        isXTurn = _xOroFunction(XorO!);
      },
    );
  }

  void _checkWinner() {
    if (board[0] == board[1] && board[0] == board[2] && board[0] != '') {
      _resultGame(board[0]);
      return;
    }
    if (board[3] == board[4] && board[3] == board[5] && board[3] != '') {
      _resultGame(board[3]);
      return;
    }
    if (board[6] == board[7] && board[6] == board[8] && board[6] != '') {
      _resultGame(board[6]);
      return;
    }
    if (board[0] == board[3] && board[0] == board[6] && board[0] != '') {
      _resultGame(board[0]);
      return;
    }
    if (board[1] == board[4] && board[1] == board[7] && board[1] != '') {
      _resultGame(board[1]);
      return;
    }
    if (board[2] == board[5] && board[2] == board[8] && board[2] != '') {
      _resultGame(board[2]);
      return;
    }
    if (board[0] == board[4] && board[0] == board[8] && board[0] != '') {
      _resultGame(board[0]);
      return;
    }
    if (board[2] == board[4] && board[2] == board[6] && board[2] != '') {
      _resultGame(board[2]);
      return;
    }

    if (filledBox == 9) {
      _resultGame('Nobody');
    }
  }

  Widget _getWinnerDialog() {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 260.0,
        color: blueGrey800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$whoIsWon WON !',
              style: GoogleFonts.signikaNegative(
                textStyle: TextStyle(
                  color: blueGrey200,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '$winnerTitle TAKES THE ROUND',
              style: GoogleFonts.signikaNegative(
                textStyle: TextStyle(
                  color: winnerTitle == 'X' ? primaryColor : secondaryColor,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _getDesicionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _getDesicionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            SystemNavigator.pop();
          },
          child: Container(
            width: 100.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: blueGrey200,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: greyShadow,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'QUIT',
                style: GoogleFonts.signikaNegative(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _clearBoard();
            Navigator.pop(context);
          },
          child: Container(
            width: 200.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: winnerTitle == 'X' ? secondaryColor : primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                    color: winnerTitle == 'X' ? yelloshadow : blueshadow,
                    offset: Offset(0, 3))
              ],
            ),
            child: Center(
              child: Text(
                'NEXT ROUND',
                style: GoogleFonts.signikaNegative(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _resultGame(String winner) {
    setState(
      () {
        gameHasResult = true;
        winnerTitle = winner;
        if (winnerTitle == XorO) {
          whoIsWon = 'YOU';
        } else if (winnerTitle == 'Nobody') {
          whoIsWon = 'NOBODY';
        } else if (winnerTitle != XorO && player == 'Ply') {
          whoIsWon = 'PLAYER';
        } else if (winnerTitle != XorO && player == 'Cpu') {
          whoIsWon = 'CPU';
        }

        if (winnerTitle == 'X') {
          scoreX++;
        } else if (winnerTitle == 'O') {
          scoreO++;
        } else {
          draws++;
        }
      },
    );
  }

  int _evaluate() {
    for (int i = 0; i < 3; i++) {
      //checking rows
      if (board[i * 3] != '' &&
          board[i * 3] == board[i * 3 + 1] &&
          board[i * 3] == board[i * 3 + 2]) {
        if (board[i * 3] == XorO && XorO == 'O') {
          return -1;
        } else if (board[i * 3] == XorO && XorO == 'X') {
          return -1;
        } else {
          return 1;
        }
      }
      //checking columns
      if (board[i] != '' &&
          board[i] == board[i + 3] &&
          board[i] == board[i + 6]) {
        if (board[i] == XorO && XorO == 'O') {
          return -1;
        } else if (board[i] == XorO && XorO == 'X') {
          return -1;
        } else {
          return 1;
        }
      }
    }

    //checking diagonals
    if (board[0] != '' && board[0] == board[4] && board[0] == board[8]) {
      if (board[0] == XorO && XorO == 'O') {
        return -1;
      } else if (board[0] == XorO && XorO == 'X') {
        return -1;
      } else {
        return 1;
      }
    }

    if (board[2] != '' && board[2] == board[4] && board[2] == board[6]) {
      if (board[2] == XorO && XorO == 'O') {
        return -1;
      } else if (board[2] == XorO && XorO == 'X') {
        return -1;
      } else {
        return 1;
      }
    }

    //draw
    return 0;
  }

  int _minimaxAlgorithm(int depth, bool isMaximizing) {
    int score = _evaluate();

    if (score == 1 || score == -1) {
      return score;
    }

    //if all tile of board was full,then its a draw
    if (board.every((element) => element != '')) {
      return 0;
    }

    int bestScore = isMaximizing ? -1000 : 1000;
    for (var i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = _isMax(isMaximizing);
        int moveScore = _minimaxAlgorithm(depth + 1, !isMaximizing);
        board[i] = '';

        if (isMaximizing) {
          bestScore = max(bestScore, moveScore);
        } else {
          bestScore = min(bestScore, moveScore);
        }
      }
    }
    return bestScore;
  }

  int _findBestMove() {
    int bestVal = -1000;
    int bestMove = -1;

    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = _xOroFunction(XorO!) ? 'O' : 'X';
        int moveVal = _minimaxAlgorithm(0, false);
        board[i] = '';

        if (moveVal > bestVal) {
          bestMove = i;
          bestVal = moveVal;
        }
      }
    }

    return bestMove;
  }

  bool _xOroFunction(String XorO) {
    if (XorO == 'X') {
      return true;
    }
    return false;
  }

  String _isMax(bool maximizing) {
    if (maximizing && XorO == 'X') {
      return 'O';
    } else if (maximizing && XorO == 'O') {
      return 'X';
    } else if (!maximizing && XorO == 'X') {
      return 'X';
    } else {
      return 'O';
    }
  }
}
