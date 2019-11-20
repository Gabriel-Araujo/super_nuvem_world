import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/animation.dart' as flame_animation;
import 'package:super_nuvem_world/engine/collision_box.dart';
import 'package:super_nuvem_world/engine/game_object.dart';

class Effect extends GameObject {
  
  Position velocity;

  String nameFile;
  int amountSequence;
  double textureWidth;
  double textureHeight;
  double stepTime;
  double gameTime;

  CollisionBox collisionBox;

  flame_animation.Animation animation;

  final double maxVelocity = 3;

  Effect(this.gameTime, this.nameFile, this.amountSequence, this.textureWidth, this.textureHeight, this.stepTime, double x, double y) : super(GameObjectType.effect) {
    this.x = x;
    this.y = y;

    animation = flame_animation.Animation.sequenced(
      nameFile, amountSequence,
      textureWidth: textureWidth, textureHeight: textureHeight, stepTime: stepTime);

    updateCollisionBox();
  }

  @override
  void render(Canvas c) {
    animation.getSprite().renderPosition(c, this.toPosition());

    //super.render(c);

    //if(game.debugMode)
      //super.renderDebugMode(c);
  }

  @override
  void update(double t) {
    animation.update(t);

    updateCollisionBox();
    super.update(t);
  }

  void updateCollisionBox() {
    collisionBox = CollisionBox(
      x: this.x + 1,
      y: this.y + 1,
      width: textureWidth - 1,
      height: textureHeight - 1,
    );
  }
}