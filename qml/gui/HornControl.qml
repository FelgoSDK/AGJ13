import QtQuick 1.1
import VPlay 1.0

Item {
  id: hornItem

  width: 50
  height: 80

  property bool honking: chain.y >= -10

  onHonkingChanged: console.debug("HONNK", honking)

  MultiResolutionImage {
    id: chain
    source: "../img/steamhandle-sd.png"
    x: 20
    y: -20
  }

  MultiTouchArea {
    anchors.fill: hornItem
    multiTouch.target: chain

    multiTouch.dragAxis: MultiTouch.YAxis
    multiTouch.minimumY: -20
    multiTouch.maximumY: 0

    Rectangle{
      anchors.fill: parent
      visible: level.showTouchAreas
      opacity: 0.5
    }

    onReleased: {
      // Move Y back to initial value
      chain.y = -20
    }
  }
}
