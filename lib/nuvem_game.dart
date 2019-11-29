import 'dart:ui';
import 'dart:math';
import 'package:flame/anchor.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/gestures.dart';
import 'package:super_nuvem_world/effects/effect.dart';
import 'package:super_nuvem_world/mobs/bat.dart';
import 'package:super_nuvem_world/mobs/bat_red.dart';
import 'package:super_nuvem_world/mobs/mob.dart';
import 'package:super_nuvem_world/mobs/mob_state.dart';
import 'package:super_nuvem_world/plataforms/plataform.dart';
import 'package:super_nuvem_world/plataforms/tile_h1.dart';
import 'package:super_nuvem_world/plataforms/tile_v1.dart';
import 'package:super_nuvem_world/player.dart';

class NuvemGame extends Game with TapDetector, SecondaryTapDetector, PanDetector {
  
  Random random = Random();

  bool gameOver;
  bool playing;
  double timePlaying;
  double lastMobSpawn;

  Size screenSize;
  double tileSize;
  int score;
  int bestScore;

  List<Plataform> plataforms;
  List<Mob> mobs;
  List<Effect> effects;

  Player player;

  Sprite padLeft = Sprite('pad_left.png');
  Sprite padRight = Sprite('pad_right.png');
  Sprite padJump = Sprite('pad_jump.png');
  Sprite padAction = Sprite('pad_action.png');

  TextConfig regularTextConfig; 
  TextConfig gameOverTextConfig;

  TextComponent scoreText;
  TextComponent gameOverText;

  NuvemGame() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    regularTextConfig = TextConfig(color: BasicPalette.white.color, fontFamily: 'Impact', textAlign: TextAlign.right);
    gameOverTextConfig = TextConfig(color: BasicPalette.white.color, fontSize: 50, fontFamily: 'Impact', textAlign: TextAlign.center);
    
    score = 0;
    bestScore = 0;

    

    restart();
  }

  void spawnBats() {
    if(lastMobSpawn > 2 && mobs.length <= 12) {
      lastMobSpawn = 0;

      var r = random.nextInt(100);
      bool newMob = (timePlaying > 5) ? true : r % 2 == 0;
      
      if(newMob) {
        if(r < 50)
          mobs.add(Bat(this, screenSize.width - random.nextInt(234), -10));
        else 
          mobs.add(Bat(this, random.nextInt(234).toDouble(), -10));

        if(timePlaying.round() % 2 == 0 && random.nextInt(101) % 2 == 0)
          mobs.add(BatRed(this, screenSize.width/2, 0));
      }
    }
  }

  void spawnPlataforms() {
    int index = 0;
    double tileH1x = 78;
    double tileV1y = 37;

    while(tileH1x * index < screenSize.width) {
      plataforms.add(TileH1(this, tileH1x * index, 264));
      index++;
    }
    
    index = 0;
    while(tileV1y * index < screenSize.height) {
      plataforms.add(TileV1(this, 0, tileV1y * index));
      plataforms.add(TileV1(this, screenSize.width - 32, tileV1y * index));
      index++;
    }
  }
  
  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff013354);
    canvas.drawRect(bgRect, bgPaint);

    plataforms.forEach((Plataform p) => p.render(canvas));
    mobs.forEach((Mob m) => m.render(canvas));

    player.render(canvas);
    effects.forEach((Effect e) => e.render(canvas));

    padLeft.renderPosition(canvas, new Position(25, screenSize.height - 125));
    padRight.renderPosition(canvas, new Position(150, screenSize.height - 125));
    padJump.renderPosition(canvas, new Position(screenSize.width - 250, screenSize.height - 125));
    padAction.renderPosition(canvas, new Position(screenSize.width - 150, screenSize.height - 225));

    if(gameOver) {
      Rect bgRect = Rect.fromLTWH(
        screenSize.width/3 - 100, screenSize.height/3 - 100, 
        screenSize.width/2 + 50, screenSize.height/3 + 100);
      Paint bgPaint = Paint();
      bgPaint.color = Color(0xFF000000);
      canvas.drawRect(bgRect, bgPaint);
      gameOverText.render(canvas);
    } else {
      scoreText.render(canvas);
    }
  }

  void update(double t) {
    if(gameOver) return;

    if (playing) {
      timePlaying += t;
      lastMobSpawn += t;

      player.update(t);

      mobs.forEach((Mob m) => m.update(t));
      mobs.removeWhere((Mob m) => m.state == MobState.dead);

      effects.forEach((Effect e) => e.update(t));
      effects.removeWhere((Effect e) => !e.visible || this.timePlaying > e.gameTime + e.effectTime);

      scoreText.text = 'SCORE ${timePlaying.round() * 100 + score}\nRECORD $bestScore';
      scoreText.update(t);

      gameOverText.text = 'GAME OVER \nFINAL SCORE ${timePlaying.round() * 100 + score}';
      gameOverText.update(t);
      
      if (player.state == PlayerState.dead) {
        doGameOver();
      } else {
        spawnBats();
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

    var finalScore = timePlaying.round() * 100 + score;
    print('finalscore = $finalScore');
    bestScore = (finalScore > bestScore) ? finalScore : bestScore;
  }

  void restart() {
    gameOver = false;
    playing = true;
    timePlaying = 0.0;
    lastMobSpawn = 0.0;
    
    score = 0;

    player = Player(this, 321, 1);

    plataforms = List<Plataform>();
    mobs = List<Mob>();
    effects = List<Effect>();

    spawnPlataforms();

    scoreText = TextComponent('000', config: regularTextConfig)
      ..anchor = Anchor.topCenter
      ..x = screenSize.width / 2
      ..y = screenSize.height - 97.0;

    gameOverText = TextComponent('GAME OVER', config: gameOverTextConfig)
      ..anchor = Anchor.topCenter
      ..x = screenSize.width / 2
      ..y = (screenSize.height / 2) - 97.0;
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

    if(playing) {
      if(globalPosition.dx <= 125 && globalPosition.dy >= screenSize.height - 200)
        tapLeft(pressing);
      else if(globalPosition.dx >= 125 && globalPosition.dx <= 250 && globalPosition.dy >= screenSize.height - 200)
        tapRight(pressing);
      else if(globalPosition.dx >= screenSize.width - 250 && globalPosition.dx <= screenSize.width - 150 && globalPosition.dy >= screenSize.height - 125)
        tapJump();
      else if(globalPosition.dx >= screenSize.width - 150 && globalPosition.dy >= screenSize.height - 250 && globalPosition.dy <= screenSize.height - 100)
        tapAction();
    } else if(gameOver && 
        globalPosition.dx >= screenSize.width/3 - 100 && globalPosition.dx <= screenSize.width - 250 &&
        globalPosition.dy >= 50 && globalPosition.dy <= screenSize.height - 150) {
      restart();
    } else {
      print(globalPosition);
    }
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
  }
}