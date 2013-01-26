// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import VPlay 1.0
import Box2D 1.0 // needed for Body.Static

EntityBase {
  entityType: "obstacle"

  poolingEnabled: true

  // put them before the track
  z:2

  /*Image {
    id: sprite
    source: "../img/corn.png"

    width: 7
    height: 10

    anchors.centerIn: parent
  }*/
  Rectangle {
    id: sprite
    width: 50
    height: 50
    color: "yellow"
    anchors.centerIn: parent
  }

  property alias collider: collider
  BoxCollider {
    id: collider
    bodyType: Body.Static

    anchors.fill: sprite
    //        anchors.centerIn: parent
    //        width: gridSize
    //        height: gridSize
    // it should not affect the movement of the player
    sensor: true

  }

}