import QtQuick 1.1
import Box2D 1.0
import VPlay 1.0

EntityBase {
  id: entity
  entityType: "borderRegion"

  signal borderCollision

  // these only exist once and should not be pooled
  preventFromRemovalFromEntityManager: true

  BoxCollider {
    id: boxCollider
    // the body must be of type dynamic, otherwise no collisions between the other static bodies (roosts & coins) would be possible!
    bodyType: Body.Dynamic
    // this is required, because the position should not be modified from the physics system, but from the QML positioning!
    // if only sensor would be set to true it would not be enough, because then the body would fall down based on gravity!
    collisionTestingOnlyMode: true
    categories: level.borderRegionColliderGroup
    collidesWith: level.obstacleColliderGroup | level.trackSectionColliderGroup

    fixture.onBeginContact: {

      var fixture = other;
      var body = other.parent;
      var component = other.parent.parent;
      var collidedEntity = component.owningEntity;
      var collidedEntityType = collidedEntity.entityType;

      console.debug("BorderRegion: collided with entity type:", collidedEntityType);


      // collision with another entity, so either a block gotten out of range, or a coin, which should be removed now (it uses pooling though!)
      collidedEntity.removeEntity();

    }
  }


  Rectangle {
    anchors.fill: boxCollider
    color: "brown"
    opacity: 0.5
    visible: debugVisuals
  }
}
