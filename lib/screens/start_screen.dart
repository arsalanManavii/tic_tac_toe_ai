import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe_ai_version/constants/colors.dart';
import 'package:tic_tac_toe_ai_version/screens/game_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool isXselected = false;
  bool isOselected = true;

  double left = 195.0;
  double right = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getXOSymbol(),
            Container(
              width: 365.0,
              height: 220.0,
              decoration: BoxDecoration(
                color: blueGrey800,
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 5),
                      blurRadius: 1.0,
                      spreadRadius: 1.0),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'PICK PLAYER 1\'S MARK',
                    style: GoogleFonts.signikaNegative(
                      textStyle: TextStyle(
                          color: blueGrey200,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 340.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 200),
                          top: 7.0,
                          left: left,
                          right: right,
                          bottom: 7.0,
                          child: Container(
                            width: 120.0,
                            height: 75.0,
                            decoration: BoxDecoration(
                              color: blueGrey200,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(
                                  () {
                                    isXselected = true;
                                    isOselected = false;
                                    left = 20;
                                    right = 195;
                                  },
                                );
                              },
                              child: Text(
                                'X',
                                style: GoogleFonts.signikaNegative(
                                  textStyle: TextStyle(
                                    color:
                                        isXselected ? blueGrey800 : blueGrey300,
                                    fontSize: 70.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(
                                  () {
                                    isOselected = true;
                                    isXselected = false;
                                    left = 195;
                                    right = 20;
                                  },
                                );
                              },
                              child: Text(
                                'O',
                                style: GoogleFonts.signikaNegative(
                                  textStyle: TextStyle(
                                    color:
                                        isOselected ? blueGrey800 : blueGrey300,
                                    fontSize: 70.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 50.0),
            _getPlayContainer(secondaryColor, yelloshadow, 'CPU'),
            SizedBox(height: 20.0),
            _getPlayContainer(primaryColor, blueshadow, 'PLAYER'),
          ],
        ),
      ),
    );
  }

  Widget _getXOSymbol() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'x',
          style: GoogleFonts.signikaNegative(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 80.0),
          ),
        ),
        SizedBox(width: 10.0),
        Text(
          'o',
          style: GoogleFonts.signikaNegative(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: secondaryColor,
                fontSize: 80.0),
          ),
        ),
      ],
    );
  }

  Widget _getPlayContainer(var color, var shadowColor, var oponent) {
    return InkWell(
      onTap: () {
        if (oponent == 'PLAYER') {
          if (isXselected) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GameScreen(
                    XorO: 'X',
                    player: 'Ply',
                  );
                },
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GameScreen(
                    XorO: 'O',
                    player: 'Ply',
                  );
                },
              ),
            );
          }
        } else if (oponent == 'CPU') {
          if (isXselected) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GameScreen(
                    XorO: 'X',
                    player: 'Cpu',
                  );
                },
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GameScreen(
                    XorO: 'O',
                    player: 'Cpu',
                  );
                },
              ),
            );
          }
        }
      },
      child: Container(
        width: 360.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Center(
          child: Text(
            'NEW GAME (VS $oponent)',
            style: GoogleFonts.signikaNegative(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
