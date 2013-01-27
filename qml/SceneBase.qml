import QtQuick 1.1
import VPlay 1.0
import "particles"

// base component for all 3 scenes in the game
Scene {
  id: sceneBase
  width: 480
  height: 320

  // this is an important performance improvement, as renderer can skip invisible items (and all its children)
  // also, the focus-property for key handling relies on the visible-property
  visible: opacity>0


  // handle this signal in each Scene
  signal backPressed

  // this fades in and out automatically, when the opacity gets changed from 0 to 1 in ChickenOutbreakMain
  Behavior on opacity {
    // the cross-fade animation should last 350ms
    NumberAnimation { duration: 350 }
  }

  // NOTE: setting the focus to activeScene === squabySceneBase is not sufficient when the scene gets loaded dynamically!
  // reason is, that only the Scene (which is a child of the Loader) gets focus, but not the Loader itself! so the MainMenuScene still has focus, but not the child scene here!
  // thus forceActiveFocus() must be called whenever the activeScene changes, which is done in GameWindow automatically!
  // only when focus is true the key will be handled in this scene
  // so only handle the key press in the active (visible) scene
  //focus: activeScene === squabySceneBase

  Keys.onPressed: {
    // only simulate on desktop platforms!
    if(event.key === Qt.Key_Backspace && system.desktopPlatform) {
      console.debug("backspace key pressed - simulate a back key pressed on desktop platforms for debugging the user flow of Android on windows!")
      backPressed()
    }

    // accepted is false by default - this allows that the derived scenes handle the key press as well!
    //event.accepted = false;
  }

  Keys.onBackPressed: {
    backPressed()
  }

  Snowing {
    id: snowing
    Component.onCompleted: {
      snowing.start()
    }
  }

}
