import 'package:flame/position.dart';
import 'package:super_nuvem_world/nuvem_game.dart';
import 'package:super_nuvem_world/plataforms/plataform.dart';

class TileV1 extends Plataform {

  TileV1(NuvemGame game, double x, double y) : super(game, 'tile_v1.png', 32, 37, Position(x, y));

}