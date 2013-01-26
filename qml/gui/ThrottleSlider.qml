import VPlay 1.0
import QtQuick 1.1
import "GUIScript.js" as GUIScript
import "UIConstants.js" as UI

Item {
  id: slider

  /*!
    The orientation property is used to set the alignment of the slider element. For horizontal usage \code Qt.Horizontal \endcode can be used and for vertical usage \code Qt.Vertical \endcode. The default value is \code Qt.Horizontal \endcode
  */
  property int orientation: Qt.Horizontal
  /*!
    The minimumValue alias is used to set minimum value which can be used for the slider element. It can be set to any qreal value. The default value is set to 0.0.
  */
  property alias minimumValue: range.minimumValue
  /*!
    The maximumValue alias is used to set maximum value which can be used for the slider element. It can be set to any qreal value. The default value is set to 1.0.
  */
  property alias maximumValue: range.maximumValue
  /*!
    The pressed alias is an out value to determine if the mouse are is pressed.
  */
  property alias pressed: mouseArea.pressed
  /*!
    The stepSize alias is used to set stepSize of the slider element. It can be set to any qreal value. The default value is set to 0.0.
  */
  property alias stepSize: range.stepSize
  /*!
    The platformMouseAnchors alias is used to get access to the MouseArea anchors of the sliderelement.
  */
  property alias platformMouseAnchors: mouseArea.anchors
  /*!
    The value alias is for in/out actions, the user can set it, create bindings to it, and at the same time the slider wants to update. There's no way in QML to do this kind
    of updates AND allow the user bind it (without a Binding object). That's the reason this is an alias to a C++ property in range model.

    But for bindings to the slider element own functions should be used i.e.: addBinding(), removeBinding() which make it easier to to use for multiple instance of objects which should be effected by users.
  */
  property alias value: range.value
  /*!
    The inverted alias can be used to invert the slider movement. The default value is set to false which correlates to a movement from the left (minimumValue) to the right (maximumValue) side. Setting the alias to true the movement is done from the right (minimumValue) to the left (maximumValue) side.
  */
  property alias inverted: range.inverted
  /*!
    The valueIndicatorVisible property defines if the value indicator which shows the current value when pressing the slider is visible or not. The default value is set to false.
  */
  property bool valueIndicatorVisible: false
  /*!
    The valueIndicatorMargin property defines the margin of the value indicator. The default value is set to 1.
  */
  property int valueIndicatorMargin: 1
  /*!
    The valueIndicatorPosition property defines the position of the value indicator. When using horizontal sliders the property is set to "Left" and in vertical mode it is set to "Top". It can also be set to "Bottom".
  */
  property string valueIndicatorPosition: __isVertical ? "Left" : "Top"
  /*!
    The defaultValue property defines the initial value of the slider. The default value of the slider should be set if resetting of the slider to the default value via a double click should be supported. The default value is set to 0.0.
  */
  property real defaultValue: 0.0

  /*!
    \internal
    Value indicator displays the current value near the slider
    if __valueIndicatorText == "", a default formating will be applied
    */
  property string __valueIndicatorText: formatValue(range.value)
  /*!
    \internal
    The default implementation for label hides decimals until it hits a floating point value at which point it keeps decimals
  */
  property bool __useDecimals: false
  /*!
    \internal
    The value provided gets formated to a fixed decimal value if decimal values should be visible.
  */
  function formatValue(v) {
    return __useDecimals ? (v.toFixed(2)) : v;
  }
  /*!
    \internal
    Defines if the slider is used horizontal or vertical.
  */
  property bool __isVertical: orientation == Qt.Vertical

  // set and retrieved outside the slider element
  width: handle.width
  height: handle.height
  // When the slider element was deactivated it should be displayed in another style
  opacity: enabled ? platformSkin.opacityEnabled : platformSkin.opacityDisabled

  Item {
    id: sliderStyle
    /*!
      The property textColor defines the text color of the Slider element. The default value is set to UI.COLOR_TEXT.
    */
    property color textColor: UI.COLOR_TEXT

    /*!
      The property trackColor defines the track color of the Slider element. The default value is set to UI.COLOR_SIGNAL.
    */
    property color trackColor: UI.COLOR_SIGNAL

    /*!
      The property grooveColor defines the groove color of the Slider element. The default value is set to UI.COLOR_SECONDARY_FOREGROUND.
    */
    property color grooveColor: UI.COLOR_SECONDARY_FOREGROUND

    /*!
      The property handleColor defines the handle color of the Slider element. The default value is set to UI.COLOR_FOREGROUND.
    */
    property color handleColor: UI.COLOR_FOREGROUND

    /*!
      The property indicatorColor defines the indicator color of the Slider element. The default value is set to #49729E.
    */
    property color indicatorColor:  "#49729E"

    /*!
      The property valueBackground defines the image of the value tooltip background. The default value is set to "img/slider-handle-value-background-sd.png".
    */
    property url valueBackground: "../img/slider-handle-value-background-sd.png"

    /*!
      The property labelArrowDown defines the image of the arrow down. The default value is set to "img/slider-handle-label-arrow-down.png".
    */
    property url labelArrowDown: "../img/slider-handle-label-arrow-down.png"

    /*!
      The property labelArrowUp defines the image of the arrow up. The default value is set to "img/slider-handle-label-arrow-up.png".
    */
    property url labelArrowUp: "../img/slider-handle-label-arrow-up.png"

    /*!
      The property labelArrowLeft defines the image of the arrow left. The default value is set to "img/slider-handle-label-arrow-left.png".
    */
    property url labelArrowLeft: "../img/slider-handle-label-arrow-left.png"

    /*!
      The property labelArrowRight defines the image of the arrow right. The default value is set to "img/slider-handle-label-arrow-right.png".
    */
    property url labelArrowRight: "../img/slider-handle-label-arrow-right.png"

    /*!
      The property handleBackground defines the image of the handle background. The default value is set to "img/slider-handle-sd.png".
    */
    property url handleBackground: "../img/slider-handle-sd.png"

    /*!
      The property grooveItemBackground defines the image of the groove item. The default value is set to "img/slider-background-sd.png".
    */
    property url grooveItemBackground: "../img/slider-background-sd.png"

    /*!
      The property handleHeight defines the height of the slider handle when no image is used. The default value is set to 35.
    */
    property int handleHeight: 35

    /*!
      The property handleWidth defines the width of the slider handle when no image is used. The default value is set to 35.
    */
    property int handleWidth: 35

    /*!
      The property trackHeight defines the height of the slider track when no image is used. The default value is set to 6.
    */
    property int trackHeight: 6

    /*!
      The property grooveHeight defines the height of the slider groove when no image is used. The default value is set to 8.
    */
    property int grooveHeight: 8

    /*!
      The property mouseMarginRight defines the right margin of the mouse area use for the slider handle. The default value is set to UI.MARGIN_DEFAULT.
    */
    property real mouseMarginRight: UI.MARGIN_DEFAULT

    /*!
      The property mouseMarginLeft defines the left margin of the mouse area use for the slider handle. The default value is set to UI.MARGIN_DEFAULT.
    */
    property real mouseMarginLeft: UI.MARGIN_DEFAULT

    /*!
      The property mouseMarginTop defines the top margin of the mouse area use for the slider handle. The default value is set to UI.MARGIN_DEFAULT.
    */
    property real mouseMarginTop: UI.MARGIN_DEFAULT

    /*!
      The property mouseMarginBottom defines the bottom margin of the mouse area use for the slider handle. The default value is set to UI.MARGIN_DEFAULT.
    */
    property real mouseMarginBottom: UI.MARGIN_DEFAULT
  }

  // Everything is encapsulated in a slider Item, so for the
  // vertical slider, we just swap the height/width, make it
  // horizontal, and then use rotation to make it vertical again.
  transformOrigin: Item.Center
  rotation: __isVertical ? -90 : 0

  // The 'range' does the calculations to map position to/from value,
  // it also serves as a data storage for both properties;
  RangeModel {
    id: range
    objectName: "slider_range"
    minimumValue: 0.0
    maximumValue: 1.0
    value: slider.defaultValue
    stepSize: 0.0
    onValueChanged: {
      var v = range.value
      if (parseInt(v) !== v) {
        __useDecimals = true;
      }
    }
    // the slider should appear at the edges wihout distance
    positionAtMinimum: handle.width/ 2
    positionAtMaximum: slider.width - handle.width / 2

    onMaximumChanged: __useDecimals = false
    onMinimumChanged: __useDecimals = false
    onStepSizeChanged: __useDecimals = false
  }

  // Value track is on below the goove item to displays the progress. Switches between inverted and not inverted mode.
  // The groove needs to be transparent or include holes to see the progress
  Item {
    id: valueTrack
    objectName: "slider_valueTrack"
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: groove.left
    anchors.right: handle.horizontalCenter
    anchors.rightMargin: handle.width / 3
    anchors.leftMargin: 2
    anchors.topMargin: handle.width / 3
    anchors.bottomMargin: handle.width / 3

    states: State {
      when: slider.inverted
      PropertyChanges {
        target: valueTrack
        anchors.rightMargin: 2
        anchors.leftMargin: -(handle.width -handle.width / 3)
      }
      AnchorChanges {
        target: valueTrack
        anchors.left: handle.horizontalCenter
        anchors.right: groove.right
      }
    }

    Rectangle {
      anchors.fill: parent
      color: sliderStyle.trackColor
    }
  }

  // Goove is the background item for the track which displays the non progress
  Item {
    id: groove
    objectName: "slider_groove"
    anchors.fill: parent

    Loader {
      id: __grooveItem
      objectName: "slider___grooveItem"
      // position the Loader in the center of the parent
      anchors.fill: parent

      sourceComponent: (sliderStyle.grooveItemBackground.toString() === "") ? rectGroove : imageGroove
    }

    // used if gui used without images
    Component {
      id: rectGroove
      Rectangle {
        objectName: "slider_rectGroove"
        height: sliderStyle.grooveHeight
        width:  sliderStyle.grooveHeight
        color: sliderStyle.grooveColor
      }
    }

    // used if gui used with images
    Component {
      id: imageGroove
      MultiResolutionImage {
        id: imageGrooveID
        contentWidth: parent.width/imageGrooveID.contentScaleFactor
        contentHeight: parent.height/imageGrooveID.contentScaleFactor
        objectName: "slider_imageGroove"
        source: sliderStyle.grooveItemBackground
      }
    }
  }

  // the real 'handle' it is the visual representation of the handle, that
  // just follows the 'fakeHandle' position.
  Item {
    id: handle
    objectName: "slider_handle"
    transform: Translate { x: - handle.width / 2 }

    anchors.verticalCenter: parent.verticalCenter

    // the visible handle should appear smaller than the mouse area therefore the real handle needs to be a little bit bigger
    width: __handleItem.width
    height: __handleItem.height

    x: fakeHandle.x
    Behavior on x {
      id: behavior
      objectName: "slider_behavior"
      enabled: !mouseArea.drag.active

      PropertyAnimation {
        duration: behavior.enabled ? 150 : 0
        easing.type: Easing.OutSine
      }
    }

    Loader {
      id: __handleItem
      objectName: "slider___handleItem"
      property bool useImages : (sliderStyle.handleBackground.toString() === "")

      // the visible handle should be smaller than the mouse area therefore the visible handle needs to be moved a little bit
      transform: Translate { x: (__handleItem.width-__handleItem.width)/2; y: (__handleItem.height-__handleItem.height)/2 }

      sourceComponent: useImages ? rectHandle : imageHandle
    }

    // used if gui used without images
    Component {
      id: rectHandle
      Rectangle {
        objectName: "slider_rectHandle"
        height: __isVertical ? sliderStyle.handleWidth : sliderStyle.handleHeight
        width: __isVertical ? sliderStyle.handleHeight : sliderStyle.handleWidth
        color: sliderStyle.handleColor
      }
    }

    // used if gui used with images, 2 MultiResolutionImages are neccessary because changing the source of MultiResolutionImage does not work (and would be slow)
    Component {
      id: imageHandle
      MultiResolutionImage {
        id: pressedImage
        objectName: "slider_pressedImage"
        source: sliderStyle.handleBackground
      }
    }
  }

  // the 'fakeHandle' is what the mouse area drags on the screen, it feeds
  // the 'range' position and also reads it when convenient;
  Item {
    id: fakeHandle
    objectName: "slider_fakeHandle"
    width: handle.width
    height: handle.height
    transform: Translate { x: - handle.width / 2 }
  }

  MultiTouchArea {
    id: mouseArea
    objectName: "slider_mouseArea"
    property real oldPosition: 0

    property bool pressed: false

    anchors {
      fill: parent
      rightMargin: sliderStyle.mouseMarginRight
      leftMargin: sliderStyle.mouseMarginLeft
      topMargin: sliderStyle.mouseMarginTop
      bottomMargin: sliderStyle.mouseMarginBottom
    }

    drag.target: fakeHandle
    drag.dragAxis: MultiTouch.XAxis
    drag.minimumX: range.positionAtMinimum
    drag.maximumX: range.positionAtMaximum

    onPressed: {
      pressed = true

      oldPosition = range.position;
      // Clamp the value
      var newX = Math.max(event.point1.x + anchors.leftMargin, drag.minimumX);
      newX = Math.min(newX, drag.maximumX);

      // Debounce the press: a press event inside the handler will not
      // change its position, the user needs to drag it.
      if (Math.abs(newX - fakeHandle.x) > handle.width / 2)
        range.position = newX;
    }

    onReleased: {
      pressed = false
    }
  }

  // value indicator can be displayed or not using the valueIndicatorVisible flag
  Item {
    id: valueIndicator
    objectName: "slider_valueIndicator"
    // The vertexZ property was added because the indicator should
    // be always on top so it is alway readable. i.e. the first
    // slider in the ItemEditor is not visible because the header
    // overlaps with the indicator and it would not be visible.
    property real vertexZ: 10 // be on the Top is unser Job!

    transform: Translate {
      x: - handle.width / 2;
      y: __isVertical? -(__valueIndicatorItem.width/2)+20 : y ;
    }

    rotation: __isVertical ? 90 : 0
    visible: valueIndicatorVisible

    width: __valueIndicatorItem.width
    height: __valueIndicatorItem.height

    state: {
      if (!__isVertical)
        return slider.valueIndicatorPosition;

      if (valueIndicatorPosition == "Right")
        return "Bottom";
      if (valueIndicatorPosition == "Top")
        return "Right";
      if (valueIndicatorPosition == "Bottom")
        return "Left";

      return "Top";
    }

    anchors.margins: valueIndicatorMargin

    states: [
      State {
        name: "Top"
        AnchorChanges {
          target: valueIndicator
          anchors.bottom: handle.top
          anchors.horizontalCenter: handle.horizontalCenter
        }
      },
      State {
        name: "Bottom"
        AnchorChanges {
          target: valueIndicator
          anchors.top: handle.bottom
          anchors.horizontalCenter: handle.horizontalCenter
        }
      },
      State {
        name: "Right"
        AnchorChanges {
          target: valueIndicator
          anchors.left: handle.right
          anchors.verticalCenter: handle.verticalCenter
        }
      },
      State {
        name: "Left"
        AnchorChanges {
          target: valueIndicator
          anchors.right: handle.left
          anchors.verticalCenter: handle.verticalCenter
        }
      }
    ]


    Loader {
      id: __valueIndicatorItem
      objectName: "slider___valueIndicatorItem"
      width: 20
      height: 40

      property url arrowSource: ""

      Loader {
        id: arrowLoader
        objectName: "slider_arrowLoader"
        sourceComponent: rectArrow
      }

      // used if gui used without images
      Component {
        id: rectArrow
        Rectangle {
          objectName: "slider_rectArrow"
          width: 2
          height: 2
          color: sliderStyle.indicatorColor
        }
      }

      // used if gui used with images
      Component {
        id: imageArrow
        Image {
          objectName: "slider_imageArrow"
          source: __valueIndicatorItem.arrowSource
        }
      }

      state: slider.valueIndicatorPosition
      states: [
        State {
          name: "Top"
          PropertyChanges {
            target: arrowLoader
            sourceComponent: (sliderStyle.labelArrowDown.toString() === "") ? rectArrow : imageArrow
          }
          AnchorChanges {
            target: arrowLoader
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
          }
          StateChangeScript {
            name: "TopScript"
            script: {
              __valueIndicatorItem.arrowSource = sliderStyle.labelArrowDown
            }
          }
        },
        State {
          name: "Bottom"
          PropertyChanges {
            target: arrowLoader
            sourceComponent: (sliderStyle.labelArrowUp.toString() === "") ? rectArrow : imageArrow
          }
          AnchorChanges {
            target: arrowLoader
            anchors.bottom: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
          }
          AnchorChanges {
            target: __valueIndicatorItem
          }
          StateChangeScript {
            name: "BottomScript"
            script: {
              __valueIndicatorItem.arrowSource = sliderStyle.labelArrowUp
            }
          }
        },
        State {
          name: "Left"
          PropertyChanges {
            target: arrowLoader
            sourceComponent: (sliderStyle.labelArrowLeft.toString() === "") ? rectArrow : imageArrow
          }
          AnchorChanges {
            target: arrowLoader
            anchors.left: parent.right
            anchors.verticalCenter: parent.verticalCenter
          }
          StateChangeScript {
            name: "LeftScript"
            script: {
              __valueIndicatorItem.arrowSource = sliderStyle.labelArrowRight
            }
          }
        },
        State {
          name: "Right"
          PropertyChanges {
            target: arrowLoader
            sourceComponent: (sliderStyle.labelArrowRight.toString() === "") ? rectArrow : imageArrow
          }
          AnchorChanges {
            target: arrowLoader
            anchors.right: parent.left
            anchors.verticalCenter: parent.verticalCenter
          }
          StateChangeScript {
            name: "RightScript"
            script: {
              __valueIndicatorItem.arrowSource = sliderStyle.labelArrowLeft
            }
          }
        }
      ]

      sourceComponent: (sliderStyle.valueBackground.toString() === "") ? rectValueIndicator : imageValueIndicator

      // Native libmeegotouch slider value indicator pops up 100ms after pressing
      // the handle... but hiding happens without delay.
      visible: slider.valueIndicatorVisible && slider.pressed
      Behavior on visible {
        enabled: !__valueIndicatorItem.visible
        PropertyAnimation {
          duration: 100
        }
      }
    }

    // used if gui used without images
    Component {
      id: rectValueIndicator
      Rectangle {
        objectName: "slider_rectValueIndicator"
        anchors.fill: parent
        color: sliderStyle.indicatorColor
      }
    }

    // used if gui used with images
    Component {
      id: imageValueIndicator
      MultiResolutionImage {
        id: imageValueIndicatorImage
        contentWidth: __valueIndicatorItem.width/imageValueIndicatorImage.contentScaleFactor
        contentHeight: __valueIndicatorItem.height/imageValueIndicatorImage.contentScaleFactor
        objectName: "slider_imageValueIndicator"
        source: sliderStyle.valueBackground
      }
    }
  }

  // when there is no mouse interaction, the handle's position binds to the value
  Binding {
    when: !mouseArea.drag.active
    target: fakeHandle
    property: "x"
    value: range.position
  }

  // when the slider is dragged, the value binds to the handle's position
  Binding {
    when: mouseArea.drag.active
    target: range
    property: "position"
    value: fakeHandle.x
  }

  /*!
    Binds the slider value to the given target and its property. This can be used to bind the slider value to many different objects and properties.
    \qml
    import QtQuick 1.1
    import VPlay 1.0

    GameWindow {
      id: window

      Rectangle {
        id: rectRed
        width: 10
        height: 10
      }

      Rectangle {
        id: rectGreen
        width: 10
        height: 10
      }

      Slider {
        width: 100
        minimumValue: 1
        maximumValue: 100
        Component.onCompleted: {
          addBinding(rectRed, "width")
          addBinding(rectRed, "x")
          addBinding(rectGreen, "width")
        }
        Component.onDestruction: {
          removeBinding(rectRed)
          removeBinding(rectGreen)
        }
      }

    }
    \endqml
    */
  function addBinding(target, toProp) {
    return GUIScript.addBinding(target, toProp, 'range.value')
  }

  /*!
    Removes the binding between this slider and the target object. Should be called when binding a object with addBinding().
    \qml
    import QtQuick 1.1
    import VPlay 1.0

    GameWindow {
      id: window

      Rectangle {
        id: rect
        width: 10
        height: 10
      }

      Slider {
        width: 100
        minimumValue: 1
        maximumValue: 100
        Component.onCompleted: {
          addBinding(rect, "width")
        }
        Component.onDestruction: {
          removeBinding(rect)
        }
      }

    }
    \endqml
  */
  function removeBinding(target) {
    return GUIScript.removeBinding(target)
  }
}
