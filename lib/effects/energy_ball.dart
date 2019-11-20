import 'package:super_nuvem_world/effects/effect.dart';
import 'package:flame/animation.dart' as flame_animation;


class EnergyBall extends Effect {

  bool goingRight; 
  flame_animation.Animation animationRight;
  flame_animation.Animation animationLeft;

  EnergyBall(double gameTime, double x, double y, this.goingRight) : 
    super(gameTime, (goingRight) ? 'effect_energy_ball_right.png' : 'effect_energy_ball_left.png', 11, 32, 32, 0.15, x, y);

  @override
  void update(double t) {
    this.x = (goingRight) ? x + 3 : x - 3;
    this.renderFlipX = true;
    super.update(t);
  }

}