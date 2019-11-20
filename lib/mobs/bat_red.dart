import 'package:flame/position.dart';
import 'package:super_nuvem_world/mobs/mob.dart';
import 'package:super_nuvem_world/nuvem_game.dart';

class BatRed extends Mob {

  BatRed(NuvemGame game, double x, double y) : super(game, 'mob_bat_red.png', 3, 48, 64, 0.15, Position(x, y));

}