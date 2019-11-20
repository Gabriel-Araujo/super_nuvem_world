import 'package:flame/position.dart';
import 'package:super_nuvem_world/nuvem_game.dart';
import 'package:super_nuvem_world/plataforms/plataform.dart';

class TileH1 extends Plataform {

  TileH1(NuvemGame game, double x, double y) : super(game, 'tile_h1.png', 78, 25, Position(x, y));

}