import 'dart:ui';

import 'package:flame/position.dart';

import 'package:flame/animation.dart' as flame_animation;
import 'package:super_nuvem_world/engine/collision_box.dart';
import 'package:super_nuvem_world/engine/game_object.dart';
import 'package:super_nuvem_world/mobs/mob_state.dart';
import 'package:super_nuvem_world/nuvem_game.dart';

class Mob extends GameObject {

  MobState state;
  Position position;
  Position velocity;

  String nameFile;
  int amountSequence;
  double textureWidth = 48;
  double textureHeight = 64;
  double stepTime;

  CollisionBox collisionBox;

  flame_animation.Animation animation;

  final double maxVelocity = 3;

  final NuvemGame game;

  int scoreValue;

  Mob(this.game, this.nameFile, this.amountSequence, this.textureWidth, this.textureHeight, this.stepTime, this.position, this.scoreValue) : super(GameObjectType.mob) {
  
    animation = flame_animation.Animation.sequenced(
      nameFile, amountSequence,
      textureWidth: textureWidth, textureHeight: textureHeight, stepTime: stepTime);

    updateCollisionBox();
  }

  @override
  void render(Canvas c) {
    animation.getSprite().renderPosition(c, position);

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
      x: position.x + 12,
      y: position.y + 12,
      width: textureWidth - 12,
      height: textureHeight - 12,
    );
  }
}