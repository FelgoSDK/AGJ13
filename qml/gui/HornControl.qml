import QtQuick 1.1
import VPlay 1.0

Item {
  id: hornItem

  width: 50
  height: 80

  property bool honking: chain.y >= -10

  onHonkingChanged: console.debug("HONNK", honking)

  Rectangle {
    id: chain

    color: "magenta"

    x: 20
    y: -20
    width: 10
    height: 80
  }

  MultiTouchArea {
    anchors.fill: hornItem
    multiTouch.target: chain

    multiTouch.dragAxis: MultiTouch.YAxis
    multiTouch.minimumY: -20
    multiTouch.maximumY: 0

    onReleased: {
      // Move Y back to initial value
      chain.y = -20
    }
  }
}
