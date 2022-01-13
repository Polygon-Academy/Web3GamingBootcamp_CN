import 'package:flame/components.dart';

import '../components/ball.dart';
import '../components/dead_line.dart';
import '../game/game_life.dart';
import '../game/game_state.dart';
import '../game/my_game.dart';
import '../tools/size_tool.dart';

class UpdateDeadLine extends Component with HasGameRef<MyGame> {
  @override
  void update(double t) {
    if (gameRef.hide) return;
    if (GameState.gameStatus != GameStatus.start) return;

    final almostDeads = gameRef.components.where((e) {
      if (e is Ball) {
        print(e.position.y);
        print(DeadLine.showTop);
      }
      return e is Ball && e.landed && e.position.y < DeadLine.showTop;
    });
    if (almostDeads.isNotEmpty) {
      DeadLine.show = true;
    } else {
      DeadLine.show = false;
    }
    if (gameRef.components.any(
        (e) => e is Ball && e.landed && e.position.y < DeadLine.marginTop)) {
      GameLife(gameRef).dead();
    }
  }
}
