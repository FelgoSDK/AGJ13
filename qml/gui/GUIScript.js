// list of binding objects which have been created for this element
var _bindingObjects = {}

// returns the binding element if found, otherwhise 0
function hasObject(data) {
  //var h = target.toString()
  return _bindingObjects[data]
}

// inserts the binding element if not available and returns it
function insertObject(data) {

  var newBinding =  _bindingObjects[data]
  if (!newBinding) {
    newBinding = data
    _bindingObjects[data] = newBinding
  }

  return newBinding
}

// removes a binding element if available
function removeObject(data){
    var newBinding =  _bindingObjects[data]
    if (!newBinding) {
      return true;
    }
    _bindingObjects[data] = 0
    return true;
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
function addBinding(target, toProp, value) {
  var url = "import VPlay 1.0; import QtQuick 1.1; Binding { value: "+value+"; property:"+'"'+toProp+'"'+"; }"

  // uses a simple map to insert the binding for this element to a list
  if(!hasObject(target)) {
    var bindingObject = Qt.createQmlObject(url, target)
    bindingObject.target = target
    insertObject(bindingObject)
    return true
  }
  return false
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
  var bindingObject = hasObject(target)
  if(bindingObject) {
    removeObject(bindingObject)
    bindingObject.destroy();
    return true
  }
  return false
}
