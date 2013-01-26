import QtQuick 1.1
import VPlay 1.0

Item {
  width: throttleSlider.width
  height: throttleSlider.height

  // Indicates if the control is currently in brake mode
  property bool brake
  // Indicates the current acceleration of the control, 0 if in brake mode
  // acceleration is between 0 and 10
  property real acceleration

  // Rotate the item here instead of using orientation: Qt.Vertical on the slider
  rotation: -90

  ThrottleSlider {
    id: throttleSlider

    // Width is height with vertical orientation
    width: 100

    x: 0
    y: 0

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
