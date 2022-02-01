import 'package:flutter/material.dart';
import 'package:tic_tac_game/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = 'No one';
  Game game = Game();

  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
          children: [
            ...firstBlock(),
            buildExpanded(context),
            ...lastBlock(),
          ],
        ) : Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...firstBlock(),
                  ...lastBlock(),
                ],
              ),
            ),
            buildExpanded(context),
          ],
        ),
      ),
    );
  }
  List<Widget> firstBlock(){
    return [
      SwitchListTile.adaptive(
        title: const Text(
          'Turn on/off tow player',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        value: isSwitch,
        inactiveTrackColor: Colors.grey,
        onChanged: (bool newValue) {
          setState(() {
            isSwitch = newValue;
          });
        },
      ),
      Text(
        "It's $activePlayer turn".toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }
List<Widget> lastBlock(){
    return [
      Text(
        result,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
        ),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            gameOver = false;
            turn = 0;
            result = 'No one';
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text('Repeat th game'),
      ),
    ];
}
  Expanded buildExpanded(BuildContext context) {
    return Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1.0,
              crossAxisCount: 3,
              children: List.generate(
                9,
                (index) => InkWell(
                  onTap: gameOver ? null : () => _onTap(index),
                  //splashColor: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(
                      Player.playerX.contains(index)
                          ? 'X'
                          : (Player.playerO.contains(index) ? 'O' : ''),
                      style: TextStyle(
                        color: Player.playerX.contains(index)
                            ? Colors.blue
                            : Colors.pink,
                        fontSize: 50,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();

      if (!isSwitch && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is the winner';
      } else if (!gameOver && turn == 9) {
        result = 'It\'s Draw';
      }
    });
  }
}
