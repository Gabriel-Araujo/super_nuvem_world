import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:super_nuvem_world/nuvem_game.dart';

void main() async {
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setLandscapeLeftOnly();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft
    ]).then((_) {
      NuvemGame game = NuvemGame();
      runApp(game.widget);
    }
  );
}