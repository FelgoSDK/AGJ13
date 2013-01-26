import QtQuick 1.1
import VPlay 1.0

EntityBase {
  entityType: "trackSection"
  // there are 4 variationTypes: straight, up, down, and both directions
  // depending on which direction the switch has, the player will be moved to that direction
  //var

  Rectangle {
    id: img
    width: scene.width/7
    height: scene.height/5
    anchors.centerIn: parent
    color: "grey"

    Rectangle {
      width: parent.width*0.8
      height: parent.height*0.8
      anchors.centerIn: parent
      color: "brown"
    }
  }

  BoxCollider {
    anchors.fill: img
    collisionTestingOnlyMode: true
    sensor: true
  }

}
