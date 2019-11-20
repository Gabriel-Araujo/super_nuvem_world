import 'package:super_nuvem_world/engine/collision_box.dart';

bool boxCompare(CollisionBox primaryBox, CollisionBox obstacleBox) {
  final double obstacleX = obstacleBox.x;
  final double obstacleY = obstacleBox.y;

  return primaryBox.x < obstacleX + obstacleBox.width &&
      primaryBox.x + primaryBox.width > obstacleX &&
      primaryBox.y < obstacleBox.y + obstacleBox.height &&
      primaryBox.height + primaryBox.y > obstacleY;
}

CollisionBox createAdjustedCollisionBox(CollisionBox box, CollisionBox adjustment) {
  return CollisionBox(
    x: box.x + adjustment.x,
    y: box.y + adjustment.y,
    width: box.width,
    height: box.height,
  );
}