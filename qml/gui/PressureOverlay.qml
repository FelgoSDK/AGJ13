import QtQuick 1.1
import VPlay 1.0

Item {
  id: hornItem

  width: bar.width
  height: bar.height

  // Pressure is between 0 and 200
  property real pressure: 100

  MultiResolutionImage {
    id: bar
    source: "../img/pressurebar-sd.png"
  }

  MultiResolutionImage {
    id: indicator

    y: bar.height - pressure / 200 * bar.height - indicator.height / 2

    source: "../img/pressureindicator-sd.png"

    Behavior on y {
      NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }
  }

}
