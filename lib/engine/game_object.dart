import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flutter/material.dart';

import 'collision_box.dart';

class GameObject extends SpriteComponent with Resizable {

  CollisionBox collisionBox;
  GameObjectType type;

  GameObject(this.type);

  @override
  void render(Canvas c) {
    super.render(c);
  }

  @override
  void renderDebugMode(Canvas c){
    super.renderDebugMode(c);
  }

  @override
  void update(double t) {
  } 

}

enum GameObjectType {
  player,
  mob,
  item,
  projectile,
  platform,
  effect,
  hud
}