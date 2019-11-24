import 'package:super_nuvem_world/effects/effect.dart';
import 'package:super_nuvem_world/nuvem_game.dart';

class Explosion extends Effect {

  Explosion(NuvemGame game, double x, double y) : 
    super(game, 'effect_explosion.png', 6, 32, 32, 0.15, x, y);

  @override
  void update(double t) {
    super.update(t);
  }

}