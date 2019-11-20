import 'dart:ui';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:super_nuvem_world/effects/effect.dart';
import 'package:super_nuvem_world/mobs/bat.dart';
import 'package:super_nuvem_world/mobs/bat_red.dart';
import 'package:super_nuvem_world/mobs/mob.dart';
import 'package:super_nuvem_world/plataforms/plataform.dart';
import 'package:super_nuvem_world/plataforms/tile_h1.dart';
import 'package:super_nuvem_world/player.dart';


class NuvemGame extends Game with TapDetector, SecondaryTapDetector, PanDetector {
  
  bool debugMode;
  bool gameOver;
  bool playing;
  double timePlaying;
  Random random = Random();

  Size screenSize;
  double tileSize;

  List<Plataform> plataforms;
  List<Mob> mobs;
  List<Effect> effects;

  Player player;

  Sprite padLeft = Sprite('pad_left.png');
  Sprite padRight = Sprite('pad_right.png');
  Sprite padJump = Sprite('pad_jump.png');
  Sprite padAction = Sprite('pad_action.png');

  TileH1 tile;

  NuvemGame() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    debugMode = false;
    gameOver = false;
    playing = true;
    timePlaying = 0.0;

    tile = TileH1(this, 300, 210);
    player = Player(this, 321, 1);

    plataforms = List<Plataform>();
    mobs = List<Mob>();
    effects = List<Effect>();

    spawnBats();
    spawnPlataforms();
  }

  void spawnBats() {
    mobs.add(Bat(this, random.nextInt(600).toDouble(), 100));
    mobs.add(BatRed(this, random.nextInt(600).toDouble(), 100));
    mobs.add(Bat(this, random.nextInt(600).toDouble(), 100));
    mobs.add(BatRed(this, random.nextInt(600).toDouble(), 100));
  }

  void spawnPlataforms() {

    int index = 0;
    double tile = 78;
    while(index < 15){
      plataforms.add(TileH1(this, tile * index, 264));
      index++;
    }
  }
  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff413354);
    canvas.drawRect(bgRect, bgPaint);

    plataforms.forEach((Plataform p) => p.render(canvas));
    mobs.forEach((Mob m) => m.render(canvas));

    player.render(canvas);
    effects.forEach((Effect e) => e.render(canvas));

    padLeft.renderPosition(canvas, new Position(25, screenSize.height - 125));
    padRight.renderPosition(canvas, new Position(150, screenSize.height - 125));
    padJump.renderPosition(canvas, new Position(screenSize.width - 250, screenSize.height - 125));
    padAction.renderPosition(canvas, new Position(screenSize.width - 150, screenSize.height - 225));
  }

  void update(double t) {
    if(gameOver) return;

    if (playing) {
      timePlaying += t;
      player.update(t);

      mobs.forEach((Mob m) => m.update(t));

      effects.removeWhere((Effect e) => this.timePlaying > e.gameTime + 1.65);
      effects.forEach((Effect e) => e.update(t));
      
      if (player.state == PlayerState.dead) {
        doGameOver();
      }
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void doGameOver() {
    stop();
  }

  void stop() {
    playing = false;
    gameOver = true;
  }

  void restart() {
    playing = true;
    gameOver = false;
    timePlaying = 0.0;
    player = Player(this, 321, 1);
  }

  @override
  void onTapDown(TapDownDetails details) {
    tap(details.globalPosition, true);
  }

  @override
  void onTapUp(TapUpDetails details) {
    tap(details.globalPosition, false);
  }

  @override
  void onTapCancel() {
    print("Cancel tap");
    player.tapCancel();
  }

  @override
  void onSecondaryTapDown(TapDownDetails details) {
    tap(details.globalPosition, true);
  }

  @override
  void onSecondaryTapUp(TapUpDetails details) {
    tap(details.globalPosition, false);
  }

  @override
  void onSecondaryTapCancel() {
    print("Cancel tap Secondary");
    player.tapCancel();
  }

  @override
  void onPanDown(DragDownDetails details) {
    tap(details.globalPosition, true);
  }

  @override
  void onPanStart(DragStartDetails details) {
    tap(details.globalPosition, true);
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    tap(details.globalPosition, true);
  }

  void onPanEnd(DragEndDetails details) {
    print("End Pan");
    player.tapCancel();
  }

  @override
  void onPanCancel() {
    print("Cancel Pan");
    player.tapCancel();
  }

  void tap(Offset globalPosition, bool pressing){
    if(globalPosition.dx <= 125 && globalPosition.dy >= screenSize.height - 200)
      tapLeft(pressing);
    else if(globalPosition.dx >= 125 && globalPosition.dx <= 250 && globalPosition.dy >= screenSize.height - 200)
      tapRight(pressing);
    else if(globalPosition.dx >= screenSize.width - 250 && globalPosition.dx <= screenSize.width - 150 && globalPosition.dy >= screenSize.height - 125)
      tapJump();
    else if(globalPosition.dx >= screenSize.width - 150 && globalPosition.dy >= screenSize.height - 250 && globalPosition.dy <= screenSize.height - 100)
      tapAction();
  }

  void tapLeft(bool pressing){
    print("left");
    player.move(pressing, -1);
  }

  void tapRight(bool pressing){
    print("right");
    player.move(pressing, 1);
  }

  void tapJump(){
    print("jump");
    player.jump();
  }

  void tapAction(){
    print("action");

    player.action();

    if(gameOver)
      restart();
  }
}