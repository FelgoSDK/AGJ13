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
    console.debug("size of TrackSection:", multiresimg.width)
  }

  onUsedFromPool: {
    console.debug("Track got used from pool")
    //collider.active = (variationSource == "sender")

    touchEnabled = (variationSource == "sender")
  }

  MultiResolutionImage {
    id: multiresimg
    source:  (variationType==="straight") ? "../img/railstraight-sd.png" : ((variationType==="up" || variationType==="down" || variationType==="upreceiver" || variationType==="downreceiver") ? "../img/railcurve-sd.png" : "../img/raildoubled-sd.png")
    anchors.centerIn: parent
    mirrorY: (variationType==="down" || variationType==="downreceiver")
    mirrorX: (variationSource==="receiver")
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
    id: img
    // NOTE: this size is not valid any more!!!
    width: level.trackSectionWidth
    height: level.trackSectionHeight
    anchors.centerIn: parent
//    color: "grey"
    opacity: 0.8

    Item {
      id: main
      width: parent.width
      height:  parent.height*0.5
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 1
      anchors.rightMargin: 1
//      color: "brown"
    }
    Rectangle {
      id: rectTop
      x: variationSource === "sender" ? 0 : main.width-height
      anchors.bottom: main.top
      width: 5
      height: 5
      color: variationSource === "sender" ? "green" : variationSource === "receiver" ? "red" : "white"
      visible: variationType === "up" || variationType === "both"
    }
    Rectangle {
      x: 0
      anchors.bottom: rectTop.top
      width: 5
      height: 5
      color: "blue"
      visible: turnDirection === "up"
    }
    Rectangle {
      id: rectBottom
      x: variationSource === "sender" ? 0 : main.width-height
      anchors.top: main.bottom
      width: 5
      height: 5
      color: variationSource === "sender" ? "green" : variationSource === "receiver" ? "red" : "white"
      visible: variationType === "down" || variationType === "both"
    }
    Rectangle {
      x: 0
      anchors.top: rectBottom.bottom
      width: 5
      height: 5
      color: "blue"
      visible: turnDirection === "down"
    }
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
      }
    }
  }

  MultiTouchArea {
    // Probably make a little bit higher than the actual track section item?
    anchors.fill: multiresimg

    // Straight types need no swipes
    enabled: touchEnabled

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
