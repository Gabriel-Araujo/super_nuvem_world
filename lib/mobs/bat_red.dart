import 'package:flame/position.dart';
import 'package:super_nuvem_world/mobs/mob.dart';
import 'package:super_nuvem_world/nuvem_game.dart';

class BatRed extends Mob {

  BatRed(NuvemGame game, double x, double y) : super(game, 'mob_bat_red.png', 3, 48, 64, 0.15, Position(x, y), 100);

  @override
  void update(double t) {

    if(game.random.nextInt(100) % 2 == 0) {
      if(game.player.position.x > position.x)
        position.x += 1;
      else if(game.player.position.x < position.x)
        position.x -= 1;
    }

    if(game.random.nextInt(100) % 3 == 0) {
      if(game.player.position.y > position.y)
        position.y += 1;
      else if(game.player.position.y < position.y)
        position.y -= 1;
    }
      
    super.update(t);
  }
}