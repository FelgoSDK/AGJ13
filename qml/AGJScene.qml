import QtQuick 1.1
import VPlay 1.0
import "entities"
import "gui"

SceneBase {
  id: scene

  property alias level: level
  property alias player: level.player
  property alias entityContainer: level
  property alias itemEditor: itemEditor

  // make 1 grid (so 1 block and the player size) 48 logical px - a roost has this size, so 320/48= 6.6 can be displayed in one scene
  gridSize: 96//48//32

  // place it on bottom, because otherwise it would be unfair compared to different devices because the player would see more to the bottom playfield!
  //sceneAlignmentY: "bottom"

  // place it on right, because otherwise it would be unfair compared to different devices because the player would see more to the bottom playfield!
  //sceneAlignmentX: "right"

  // put it left, so the train is always on the very left side - in the end, it should be put right! does not matter if train reaches further right
  sceneAlignmentX: "left"

  // for performance-testing, if the score should updated every frame with the y value of the level
  // it is set to false, because updating a static text every frame is very poor for performance, because a texture is generated every frame!
  // thus, if this flag is set to false the score is only updated every 10th frame which speeds things up
  property bool enableConstantScoreTextUpdating: false

  onBackPressed: {
    // TODO: instead of navigating to main without any warning, show an pause screen to avoid unintended exit of the game
    // it is important to call stopGame() here, because otherwise the entities would not be deleted!
    level.stopGame();
    window.state = "main"
  }

  // allows collision detection between the entities, so if the player collides with roosts or the corn, and for removal of the out-of-scene entities
  PhysicsWorld {
    // this id gets used in Level, to test if a new roost or window can be built on the new position or if there is an entity already
    id: physicsWorld
    // this puts it on top of all other items for the physics debug renderer
    z: 1

    // for physics-based games, this should be set to 60!
    updatesPerSecondForPhysics: 60

    // this should be increased so it looks good, by default it is set to 1 to save performance
    velocityIterations: 5
    positionIterations: 5

    //y: level.y // uncomment this, if you want the physics world move with the level - this is only for testing the debugDraw, and has no effect on the game logic ans the physics positions are not mapped back to the physicsWorld!
  }

  Level {
    id: level

    width: scene.width
    height: scene.height


    onGameLost: {
      level.stopGame();
      // lastScore is used in GameOverScreen to check if a new highscore is reached
      lastScore = player.totalScore;
      // Increment the player's death count
      player.deaths++;
      // change to state gameOver showing the GameOverScene - in the SceneBase a crossfade effect is implemented
      window.state = "gameOver"
    }
  }

  // this allows usage of the left and right keys on desktop systems or mobiles with physical keyboards
  // focus must be set to visible, not just to true, because when the scene gets invisible, it looses focus and would never get set to true again!  
  // forward the input to the controller of the player
  //Keys.forwardTo: player.controller

  Keys.onReleased: {
    if(event.key === Qt.Key_Plus)
      // the level is moved faster, when the accel is increased in its negative direction
      level.accelerate(-40)
    if(event.key === Qt.Key_Minus)
      level.accelerate(+40)
  }


//  MouseArea {
//    // use the full window as control item, press anywhere on the left half for steering left, on the right half for steering right
//    anchors.fill: scene.gameWindowAnchorItem
//    onPressed: {
//      if(mouseX > scene.gameWindowAnchorItem.width/2)
//        player.controller.xAxis = 1;
//      else
//        player.controller.xAxis = -1;
//    }
//    onPositionChanged: {
//      if(mouseX > scene.gameWindowAnchorItem.width/2)
//        player.controller.xAxis = 1;
//      else
//        player.controller.xAxis = -1;
//    }
//    onReleased: player.controller.xAxis = 0
//  }

  Text {
    id: scoreText

    // place it on top of the window, not on top of the logical scene
    anchors.top: scene.gameWindowAnchorItem.top
    anchors.horizontalCenter: scene.gameWindowAnchorItem.horizontalCenter
    anchors.topMargin: 5

    text: /*"Score: " + player.totalScore + */" Lives:" + player.lives + " Speed:" + level.levelMovementSpeed
    font.family: fontHUD.name
    font.pixelSize: 22
    color: "white"
  }

  Text {
    // place it on top of the window, not on top of the logical scene
    anchors.top: scoreText.bottom
    anchors.horizontalCenter: scoreText.horizontalCenter

    text: "Pressure: " + player.steamPressure + "%"
    font.family: fontHUD.name
    font.pixelSize: 18
    color: "white"
  }

  // gets called by Main when this scene gets active
  // starts a game again - stopGame() was called before so it is save to call that here
  function enterScene() {
    level.startGame();
  }


  // ------------------- debugging-only code ------------------- //

  // this button is only for testing and only visible in debug mode
  // it shows the ingameMenu to quickly restart the game and test different performance options
  SimpleButton {
    id: hud
    width: 64
    height: 64
    // place it on top of the window, not on top of the logical scene
    anchors.top: scene.gameWindowAnchorItem.top
    anchors.right: scene.gameWindowAnchorItem.right
    visible: true//system.debugBuild // only display in debug mode - the menu button for ingame testing should not be visible in retail builds for the store (and also not in release builds)
    text: "Menu"
    onClicked: {
      // this activates the ingameMenu state, which will show the IngameMenu item
      scene.state = "ingameMenu"

      //window.state = "gameOver" // uncommment this for testing the state-changes when pressing the menu button
    }
  }
  // this gets only displayed when the menu button is pressed, which is only allowed in debug builds
  IngameMenu {
    id: ingameMenu
    // in the default state, this should be invisible!
    visible: false
    anchors.centerIn: parent
  }

  HornControl {
    anchors.top: gameWindowAnchorItem.top
    anchors.left: gameWindowAnchorItem.left
    anchors.leftMargin: 10

    onHonkingChanged: {
      // Honking is only possible if we have more than 20% steam
      if (honking && player.steamPressure >= player.steamPressureDeltaForHonking) {
        hornSound.play();
        level.moveFirstObstacleInCurrentTrack()
        player.steamPressure -= player.steamPressureDeltaForHonking
      }
    }

    Sound {
      id: hornSound
      source: "snd/horn.wav"
    }
  }

  ThrottleControl {
    // Can't use anchors here because of rotation
    // anchors.right: gameWindowAnchorItem.right
    // anchors.bottom: gameWindowAnchorItem.bottom
    x: gameWindowAnchorItem.x + gameWindowAnchorItem.width - width/2 - height
    y: gameWindowAnchorItem.y + gameWindowAnchorItem.height - width/2 - height

    onBrakeChanged: {
      if (brake) {
        console.log("Train in brake mode!")
        level.setAcceleration(20);
      }
      else {
        console.log("Brakes released")
        level.setAcceleration(0)
      }
    }

    onAccelerationChanged: {
      console.log("Train's acceleration value", acceleration)
      level.setAcceleration(-acceleration)
    }
  }

  ItemEditor {
    id: itemEditor
    //width: 200
    //height: scene.height
    //anchors.left: scene.left
    // anchor it right, so we are not below the HornControl
    anchors.right: scene.right

    groupAnchor: "top"
    z:2 // the editor is NOT on top of the MultiTouchArea in the Horn! z issue in MultiTouchArea!

    // Add all particles here which should be available
    filterGroups: [
      "Level",
    ]

    // Add all particles textures here which should be available for a particle
    imageSources: [
    ]

    filterSelection: "Level"

    visible: false

    opacity: 0.4
  }

  states: [
    State {
      name: ""
      StateChangeScript {
        script: {
          level.resumeGame();
        }
      }
    },
    State {
      name: "ingameMenu"
      PropertyChanges { target: ingameMenu; visible: true}
      PropertyChanges { target: hud; visible: false}
      StateChangeScript {
        script: {
          level.pauseGame();
        }
      }
    }

  ]
}
