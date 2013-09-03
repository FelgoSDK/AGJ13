import QtQuick 1.1
import VPlay 1.0

EntityBase {
  entityType: "trackSection"
  // there are 4 variationType: straight, up, upreceiver, down, downreceiver, and both, bothreceiver directions
  // depending on which direction the switch has, the player will be moved to that direction
  variationType: "straight"
  //variationTypes: "straight"
  // there are 3 variationSource: sender, receiver, none (straight)
  property string variationSource: "none"

  // this is important - a lot get removed and destroyed dynamically!
//  poolingEnabled: true
  poolingEnabled: level.trackSectionPoolingEnabled


  // In comparison to the variatonType the turnDirection property holds the logical direction in
  // which the track section is pointing to. This should be used for the resulting player path.
  // Valid values are "straight", "up" and "down"
  property string turnDirection: "straight"

  property bool touchEnabled: variationSource == "sender"


  Component.onCompleted:  {
    //console.debug("size of TrackSection:", multiresimg.width)
    console.debug("NEW TRACKSECTION with id", entityId, "variationType:", variationType)
  }

  onVisibleChanged: {
    //console.debug("TRACKSECTION visible changed to", visible, "with id", entityId, ", type:", entityType)
  }

  onMovedToPool: {
//    collider.active = false
  }

  onUsedFromPool: {
    console.debug("Track got used from pool")
    //collider.active = (variationSource == "sender")

    touchEnabled = (variationSource == "sender")

    //console.debug("use pooled TRACKSECTION with id", entityId, "visible:", visible)

    //collider.active = true
  }

  MultiResolutionImage {
    id: multiresimg
    //contentWidth: img.width/multiresimg.contentScaleFactor+1
    //contentHeight: img.height/multiresimg.contentScaleFactor
    source:  (variationType==="straight") ? "../img/rails-sd.png" :
             ((variationType==="up" || variationType==="upreceiver") ? "../img/cross_ccw-sd.png" :
               ((variationType==="down" || variationType==="downreceiver") ? "../img/cross_ccw-sd.png" :
                                                                                 "../img/cross-sd.png")) // is used when variationtype is both
    anchors.centerIn: parent
    mirrorY: (variationType==="down" || variationType==="downreceiver")
    mirrorX: (variationSource==="receiver")
  }

  MultiResolutionImage {
    id: sign
    x: img.x-sign.width/2
    z: parent.z+5
    //anchors.left: img.left
    anchors.verticalCenter: img.verticalCenter

    visible: !(variationType==="straight") && (variationSource==="sender")
    source:  "../img/switchbutton-sd.png"
    rotation: (turnDirection === "straight") ? 90 : ((turnDirection == "up") ? 45 : -45)
  }
  // for debugging the sizes of trackSectionWidth and image width
//  Rectangle {
//    anchors.fill: multiresimg
//    opacity: 0.5
//    color: "blue"
//  }

//  Rectangle {
//    anchors.fill: img
//    opacity: 0.3
//    color: "green"
//  }

  Item {
//  Rectangle {
    id: img
    // NOTE: this size is not valid any more!!!
    width: level.trackSectionWidth
    height: level.trackSectionHeight
    anchors.centerIn: parent
//    color: "grey"
    opacity: 0.8

    Item {
//    Rectangle {
      id: main
      width: parent.width
      height:  parent.height*0.5
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 1
      anchors.rightMargin: 1
    }
  }

  Rectangle {
    anchors.fill: collider
    color: "green"
    opacity: 0.5
    visible: debugVisuals
  }

  BoxCollider {
    id: collider
    anchors.fill: multiresimg
    collisionTestingOnlyMode: true
    categories: level.trackSectionColliderGroup
    collidesWith: level.playerColliderGroup | level.borderRegionColliderGroup
    sensor: true
    // do not deactivate if straight, because when player collides with a straight section, and the switch would be set afterwards, then it would switch track although player is further behind
    //active: variationSource == "sender" //&& turnDirection != "straight"

    Rectangle {
      anchors.fill: parent
      visible: level.showCollision && (variationSource === "sender" )
      opacity: 0.6
      color: "red"
    }

    fixture.onBeginContact: {
      var fixture = other;
      var body = fixture.parent;
      var component = body.parent;
      var collidedEntity = component.owningEntity;
      var collidedEntityType = collidedEntity.entityType;

      console.debug("collision in TrackSection with", collidedEntityType)
      //collider.active = false

      if(collidedEntityType === "player") {
        touchEnabled = false
        if(turnDirection !== "straight")
          player.collisionWithTrackSection(turnDirection)
      } else {
        // in this case, the track collided with the borderregion and will be destroyed now
        // with the old solution of VPlay without updating the position of mBody, without this there was a recreation error!
        //collider.active = false
      }
    }
  }

  MultiTouchArea {
    // Probably make a little bit higher than the actual track section item?
    //anchors.fill: multiresimg
    //anchors.left: multiresimg.left
    x: multiresimg.x-multiresimg.width/4
    y: multiresimg.y-multiresimg.height*2/2
    height: multiresimg.height*3
    width: multiresimg.width

    // Straight types need no swipes
    enabled: touchEnabled

    Rectangle {
      anchors.fill: parent
      visible: level.showTouchAreas && (variationSource === "sender")
      opacity: 0.5
    }

    onClicked: {
      console.debug("LOG",variationSource,variationType)
    }

    onSwipe: {
      // console.debug("angle is", angle)

      // Check for swipe direction, delta is 60 degrees
      if (angle  > 330 || angle < 30 || angle  > 150 && angle < 210) {
        // console.debug("Straight swipe...")
        turnDirection = "straight"
      }
      else if (angle  > 60 && angle < 120) {
        // console.debug("Swipe down...")
        if (variationType === "both" || variationType === "down")
          turnDirection = "down"
      }
      else if (angle  > 240 && angle < 300) {
        // console.debug("Swipe up...")
        if (variationType === "both" || variationType === "up")
          turnDirection = "up"
      }
    }
  }
}
