import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/animation.dart' as flame_animation;
import 'package:super_nuvem_world/engine/collision_box.dart';
import 'package:super_nuvem_world/engine/game_object.dart';
import 'package:super_nuvem_world/nuvem_game.dart';

class Effect extends GameObject {
  
  Position velocity;

  String nameFile;
  int amountSequence;
  double textureWidth;
  double textureHeight;
  double stepTime;
  double gameTime;

  get effectTime => this.amountSequence * this.stepTime;

  bool visible;

  CollisionBox collisionBox;

  flame_animation.Animation animation;

  final double maxVelocity = 3;
  final NuvemGame game;

  Effect(this.game, this.nameFile, this.amountSequence, this.textureWidth, this.textureHeight, this.stepTime, double x, double y) : super(GameObjectType.effect) {
    this.x = x;
    this.y = y;
    this.gameTime = game.timePlaying;
    this.visible = true;

    animation = flame_animation.Animation.sequenced(
      nameFile, amountSequence,
      textureWidth: textureWidth, textureHeight: textureHeight, stepTime: stepTime);

    updateCollisionBox();
  }

  @override
  void render(Canvas c) {
    if(visible)
      animation.getSprite().renderPosition(c, this.toPosition());

    //super.render(c);

    //if(game.debugMode)
      //super.renderDebugMode(c);
  }

  @override
  void update(double t) {
    if(visible) {
      animation.update(t);

      updateCollisionBox();
      super.update(t);
    }
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