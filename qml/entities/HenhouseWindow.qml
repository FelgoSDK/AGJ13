// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import VPlay 1.0
import Box2D 1.0 // needed for Body.Static

EntityBase {
  entityType: "henhouseWindow"

  poolingEnabled: true

  Image {
    id: sprite
    source: "../img/window3.png"

    // the size should not be bound to the grid as it is only a visual effect, but it gets set to the image size
    width: 64//2*gridSize
    height: 60

    // dont anchor! use the top left as anchor point!
    //anchors.centerIn: parent
  }

  property alias collider: collider
  BoxCollider {
    id: collider
    bodyType: Body.Static

    anchors.fill: sprite
    sensor: true

  }

}
