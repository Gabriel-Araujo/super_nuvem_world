import 'package:super_nuvem_world/effects/effect.dart';
import 'package:flame/animation.dart' as flame_animation;
import 'package:super_nuvem_world/effects/explosion.dart';
import 'package:super_nuvem_world/engine/collision_utils.dart';
import 'package:super_nuvem_world/mobs/mob_state.dart';
import 'package:super_nuvem_world/nuvem_game.dart';

class EnergyBall extends Effect {

  bool goingRight; 
  flame_animation.Animation animationRight;
  flame_animation.Animation animationLeft;

  EnergyBall(NuvemGame game, double x, double y, this.goingRight) : 
    super(game, (goingRight) ? 'effect_energy_ball_right.png' : 'effect_energy_ball_left.png', 11, 32, 32, 0.15, x, y);

  @override
  void update(double t) {
    this.x = (goingRight) ? x + 3 : x - 3;
    
    updateCollisionBox();
    checkForCollision();
    super.update(t);
  }

  void checkForCollision() {
    
    for (var mob in game.mobs) {
      if(boxCompare(this.collisionBox, mob.collisionBox)) {
        visible = false;
        mob.state = MobState.dead;
        game.effects.add(Explosion(game, mob.position.x + 5, mob.position.y + 15));
        game.score += mob.scoreValue;
      }
    }
    
    for (var plataform in game.plataforms) {
      if(boxCompare(this.collisionBox, plataform.collisionBox)){
        visible = false;
      }
    }
  }

}