import 'dart:ui';
import 'dart:math';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:super_nuvem_world/effects/energy_ball.dart';
import 'package:super_nuvem_world/engine/collision_box.dart';
import 'package:super_nuvem_world/engine/game_object.dart';
import 'package:super_nuvem_world/nuvem_game.dart';
import 'package:super_nuvem_world/engine/collision_utils.dart';

class Player extends GameObject {
  PlayerSkin skin;

  Sprite spriteIdleLeft;
  Sprite spriteIdleRight;

  PlayerState state;
  Position position;
  Position velocity;
  bool goingRight;

  double textureWidth = 23;
  double textureHeight = 50;

  double positionYJump = 0;
  double timeLastAction = 0;

  CollisionBox collisionBox;

  final double maxVelocity = 3;
  final NuvemGame game;

  Player(this.game, double x, double y) : super(GameObjectType.player) {
    skin = PlayerSkin.values[new Random().nextInt(PlayerSkin.values.length - 1)];

    print('skin_${skin.toString().split('.').last}_idle_right.png');
    spriteIdleLeft = Sprite('skin_${skin.toString().split('.').last}_idle_left.png');
    spriteIdleRight = Sprite('skin_${skin.toString().split('.').last}_idle_right.png');

    sprite = spriteIdleRight;
    goingRight = true;

    position = Position(x, y);
    velocity = Position(0, 0);

    state = PlayerState.falling;

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
    if(state == PlayerState.attacked && state == PlayerState.idle && state == PlayerState.dead)
      velocity = Position(0,0);

    if(state == PlayerState.jumping){
      velocity.add(Position(0, -1));
      if(velocity.y > maxVelocity * -1)
        velocity = Position(velocity.x, maxVelocity * -1);

      if(position.y <= positionYJump - (textureWidth * 2.5))
        state = PlayerState.falling;
    }

    if(state == PlayerState.falling){
      velocity.add(Position(0, 1));
      if(velocity.y > maxVelocity * 2)
        velocity = Position(velocity.x, maxVelocity);

      print('falling $velocity');
    }

    position.add(velocity);

    updateCollisionBox();
    checkForCollision();
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

  void tapCancel() {
    if(state == PlayerState.walking)
      state = PlayerState.idle;
    
    velocity = Position(0, 0);
  }

  void move(bool pressing, double value) {
    if(pressing){
      if(state == PlayerState.idle)
        state = PlayerState.walking;

      if((value < 0 && velocity.x > 0) || (value > 0 && velocity.x < 0))
        velocity = Position(value, velocity.y);
      else
        velocity.add(Position(value, 0));

      if(velocity.x > maxVelocity || velocity.x < maxVelocity * -1)
        velocity = Position(maxVelocity * value, velocity.y);

    } else { //if(state != PlayerState.idle) {
      state = PlayerState.falling;
      velocity = Position(0, velocity.y);
    }

    if(velocity.x < 0){
      sprite = spriteIdleLeft;
      goingRight = false;
    } else if(velocity.x > 0) {
      sprite = spriteIdleRight;
      goingRight = true;
    }

    print(state);
  }

  void checkForCollision(){
    
    for (var mob in game.mobs) {
      if(boxCompare(this.collisionBox, mob.collisionBox)){
        game.doGameOver();
      }
    }
    
    for (var plataform in game.plataforms) {
      if(boxCompare(this.collisionBox, plataform.collisionBox)){
        print("i found a plataform" + DateTime.now().toString() );
        
        position.y -= 1;
        velocity = Position(0, 0);
        state = PlayerState.idle;
      }
    }
  }

  void jump() {
    print('trying jumping ... $state');
    if(state == PlayerState.idle || state == PlayerState.walking){
      state = PlayerState.jumping;
      positionYJump = position.y;
    }

    print(state);
  }

  void action() {
    print('action!');

    if(this.game.effects.length == 0)
      this.game.effects.add(new EnergyBall(this.game.timePlaying, goingRight ? position.x + 12 : position.x - 22, position.y + 12, goingRight));
  }
}

enum PlayerState {
  idle,
  walking,
  jumping,
  falling,
  attacking,
  attacked,
  dying,
  dead,
}

enum PlayerSkin {
  baby,
  gabriel,
  jossan,
  //luan,
  //piccin,
  //ronan,
  //vh,
  //willian,
}