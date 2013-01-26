import QtQuick 1.1
import VPlay 1.0

EntityBase {
  entityType: "trackSection"
  // there are 4 variationTypes: straight, up, down, and both directions
  // depending on which direction the switch has, the player will be moved to that direction
  property string variationTypes: "straight"
  // there are 3 variationSource: sender, receiver, none (straight)
  property string variationSource: "none"

  // this is important - a lot get removed and destroyed dynamically!
  poolingEnabled: true


  // In comparison to the variatonType the turnDirection property holds the logical direction in
  // which the track section is pointing to. This should be used for the resulting player path.
  // Valid values are "straight", "up" and "down"
  property string turnDirection: "straight"

  Rectangle {
    id: img
    width: scene.width/7
    height: scene.height/5
    anchors.centerIn: parent
    color: "grey"

    Rectangle {
      id: main
      width: parent.width
      height:  parent.height*0.5
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 1
      anchors.rightMargin: 1
      color: "brown"
    }
    Rectangle {      
      x: variationSource === "sender" ? 0 : main.width-height
      anchors.bottom: main.top
      width: 5
      height: 5
      color: variationSource === "sender" ? "green" : variationSource === "receiver" ? "red" : "white"
      visible: variationTypes === "up" || variationTypes === "both"
    }
    Rectangle {
      x: variationSource === "sender" ? 0 : main.width-height
      anchors.top: main.bottom
      width: 5
      height: 5
      color: variationSource === "sender" ? "green" : variationSource === "receiver" ? "red" : "white"
      visible: variationTypes === "down" || variationTypes === "both"
    }
  }

  BoxCollider {
    anchors.fill: img
    collisionTestingOnlyMode: true
    sensor: true
    active: variationSource == "sender"
  }

  MultiTouchArea {
    // Probably make a little bit higher than the actual track section item?
    anchors.fill: img

    // Straight types need no swipes
    enabled: variationTypes !== "straight"

    onSwipe: {
      // console.debug("angle is", angle)

      // Check for swipe direction, delta is 60 degrees
      if (angle  > 330 || angle < 30 || angle  > 150 && angle < 210) {
        // console.debug("Straight swipe...")
        turnDirection = "straight"
      }
      else if (angle  > 60 && angle < 120) {
        // console.debug("Swipe down...")
        if (variationTypes === "both" || variationTypes === "down")
          turnDirection = "down"
      }
      else if (angle  > 240 && angle < 300) {
        // console.debug("Swipe up...")
        if (variationTypes === "both" || variationTypes === "up")
          turnDirection = "up"
      }
    }
  }
}
