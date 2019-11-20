import 'package:flame/position.dart';

import 'package:super_nuvem_world/mobs/mob.dart';
import 'package:super_nuvem_world/nuvem_game.dart';

class Bat extends Mob {

  Bat(NuvemGame game, double x, double y) : super(game, 'mob_bat.png', 3, 48, 64, 0.15, Position(x, y));

}