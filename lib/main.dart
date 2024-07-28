import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey,
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<List<String>> _board;
  late bool _isPlayerX;
  late bool _gameStarted;
  late String _winner;
  TextEditingController _playerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    _board = List.generate(3, (_) => List.filled(3, ''));
    _isPlayerX = true;
    _gameStarted = false;
    _winner = '';
  }

  bool _checkForWin(String player) {
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == player && _board[i][1] == player && _board[i][2] == player) {
        return true;
      }
      if (_board[0][i] == player && _board[1][i] == player && _board[2][i] == player) {
        return true;
      }
    }
    if (_board[0][0] == player && _board[1][1] == player && _board[2][2] == player) {
      return true;
    }
    if (_board[0][2] == player && _board[1][1] == player && _board[2][0] == player) {
      return true;
    }
    return false;


  }

  bool _checkForDraw() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          return false;
        }
      }
    }
    return true;
  }

  void _makeMove(int row, int col) {
    if (_gameStarted && _board[row][col] == '' && _winner.isEmpty) {
      setState(() {
        _board[row][col] = 'X';
        if (_checkForWin('X')) {
          _winner = 'Player X';
        } else if (_checkForDraw()) {
          _winner = 'Draw';
        } else {
          _aiMove();
          if (_checkForWin('O')) {
            _winner = 'Player O';
          } else if (_checkForDraw()) {
            _winner = 'Draw';
          }
        }
      });
    }
  }

  void _aiMove() {
    List<int> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          emptyCells.add(i * 3 + j);
        }
      }

    }
    if (emptyCells.isNotEmpty) {
      int randomIndex = Random().nextInt(emptyCells.length);
      int cellIndex = emptyCells[randomIndex];
      int row = cellIndex ~/ 3;
      int col = cellIndex % 3;
      _board[row][col] = 'O';
    }
  }

  void _startGame(String playerName) {
    if (playerName.isNotEmpty) {
      setState(() {
        _gameStarted = true;
        _playerNameController.text = playerName;
      });
    }
  }

  void _resetBoard() {
    setState(() {
      _initializeBoard();
      _playerNameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_gameStarted)
              Column(
                children: [
                  TextField(
                    controller: _playerNameController,
                    decoration: InputDecoration(labelText: 'Your Name'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _startGame(_playerNameController.text),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child: Text('Start Game'),
                  ),
                ],
              ),
            if (_gameStarted)
              Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      int row = index ~/ 3;
                      int col = index % 3;
                      return GestureDetector(
                        onTap: () => _makeMove(row, col),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: Text(
                              _board[row][col],
                              style: TextStyle(fontSize: 40.0, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  if (_winner.isNotEmpty)
                    Text(
                      '$_winner wins!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ElevatedButton(
                    onPressed: _resetBoard,
                    child: Text('Reset Board'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
