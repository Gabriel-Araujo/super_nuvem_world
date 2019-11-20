import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:super_nuvem_world/engine/collision_box.dart';
import 'package:super_nuvem_world/engine/game_object.dart';
import 'package:super_nuvem_world/nuvem_game.dart';

class Plataform extends GameObject {

  Position position;
  Position velocity;

  String nameFile;
  int amountSequence;
  double textureWidth;
  double textureHeight;
  double stepTime;

  CollisionBox collisionBox;

  Sprite sprite;

  final double maxVelocity = 3;

  final NuvemGame game;

  Plataform(this.game, this.nameFile, this.textureWidth, this.textureHeight, this.position) : super(GameObjectType.platform) {
  
    sprite = Sprite(nameFile);

    updateCollisionBox();
  }

  @override
  void render(Canvas c) {
    sprite.renderPosition(c, position);

    super.render(c);

    if(game.debugMode)
      super.renderDebugMode(c);
  }

  @override
  void update(double t) {

    updateCollisionBox();
    super.update(t);
  }

  void updateCollisionBox() {
    collisionBox = CollisionBox(
      x: position.x + 1,
      y: position.y + 1,
      width: textureWidth - 1,
      height: textureHeight - 1,
    );
  }
}