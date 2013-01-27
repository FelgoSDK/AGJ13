// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import VPlay 1.0
import Box2D 1.0 // needed for Body.Static
import "../particles"

EntityBase {
  id: obstacle
  entityType: "obstacle"

  poolingEnabled: true

  // put them before the track
  z:2

  // drive curves with locomotive
  property variant endPoint : 0
  property bool followingPath: false
  property real velocity: 200

  property real offset: 20

  property bool directionUp: true

  onMovedToPool: {
    anim.stop()
  }

  Component.onCompleted: {
    //console.debug("NEW Obstacle created")
    var propability = Math.random()
     if(propability < 0.5) {
       obstacle.directionUp = true
     } else {
       obstacle.directionUp = false
     }
  }

  onUsedFromPool: {
    //console.debug("obstacle used from pool")
    var propability = Math.random()
     if(propability < 0.5) {
       obstacle.directionUp = true
     } else {
       obstacle.directionUp = false
     }
  }

  MultiResolutionImage {
    id: sprite
    source: "../img/moose-sd.png"

//    width: 7
//    height: 10

    anchors.centerIn: parent
    rotation: directionUp ? 0 : 180
  }
//  Rectangle {
//    id: sprite
//    width: 50
//    height: 50
//    color: "yellow"
//    anchors.centerIn: parent
//  }

  property alias collider: collider
  BoxCollider {
    id: collider
    bodyType: Body.Static

    categories: level.obstacleColliderGroup

    anchors.fill: sprite
    //        anchors.centerIn: parent
    //        width: gridSize
    //        height: gridSize
    // it should not affect the movement of the player
    sensor: true

    //categories: level.
    fixture.onBeginContact: {
      var fixture = other;
      var body = fixture.parent;
      var component = body.parent;
      var collidedEntity = component.owningEntity;
      var collidedEntityType = collidedEntity.entityType;
      if(collidedEntityType === "player") {
        level.splatterParticle.x = obstacle.x
        level.splatterParticle.y = obstacle.y
        level.splatterParticle.start()
      }
    }
  }

  NumberAnimation on y {
   id: anim
   duration: 150
  }

  function jump() {
    console.debug("JUMP!!!")

    var point = Qt.point(0, 0)
    if(directionUp) {      
      //point.x = obstacle.x
      point.y = obstacle.y-level.trackSectionHeight
//      anim.to = point
    } else {
      //point.x = obstacle.x
      point.y = obstacle.y+level.trackSectionHeight
//      anim.to = point
    }


    // do not set it directly, but use an animation
    //obstacle.y = point.y

    anim.to = point.y
    anim.start()

    moveSound.play()
  }

  SoundEffect {
    id: moveSound
    source: "../snd/elkmoves.wav"
  }
}
