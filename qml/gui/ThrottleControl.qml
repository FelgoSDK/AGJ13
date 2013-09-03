import QtQuick 1.1
import VPlay 1.0

Item {
  width: throttleSlider.height
  height: throttleSlider.width

  Rectangle {
    anchors.fill: parent
    color: "red"
    opacity: 0.5
  }

  // Indicates if the control is currently in brake mode
  property bool brake
  // Indicates the current acceleration of the control, 0 if in brake mode
  // acceleration is between 0 and 10
  property real acceleration

  ThrottleSlider {
    id: throttleSlider

    // Width is height with vertical orientation
    width: 100

    orientation: Qt.Vertical

    x: height/2-width/2
    y: width/2-height/2

    minimumValue: 0
    maximumValue: 13
    defaultValue: 3
    stepSize: 1

    onPressedChanged: {
      // Set back to default value if user releases the slider
      if (!pressed)
        value = defaultValue
    }

    onValueChanged: {
      // We only want acceleration valus between 0 and 10
      acceleration = Math.max(0, value - defaultValue)

      if (value < defaultValue)
        brake = true
      else
        brake = false
    }
  }
}
