import QtQuick 1.1
import VPlay 1.0

EntityBase {
  entityType: "trackSection"
  // there are 4 variationTypes: straight, up, down, and both directions
  // depending on which direction the switch has, the player will be moved to that direction
  property string variationTypes: "straight"

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
      anchors.horizontalCenter: main.horizontalCenter
      anchors.bottom: main.top
      width: 5
      height: 5
      color: "brown"
      visible: variationTypes === "up" || variationTypes === "both"
    }
    Rectangle {
      anchors.horizontalCenter: main.horizontalCenter
      anchors.top: main.bottom
      width: 5
      height: 5
      color: "brown"
      visible: variationTypes === "down" || variationTypes === "both"
    }
  }

  BoxCollider {
    anchors.fill: img
    collisionTestingOnlyMode: true
    sensor: true
  }

}
