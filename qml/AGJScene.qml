import QtQuick 1.1
import VPlay 1.0
import "entities"
import "gui"

SceneBase {
  id: scene

  property alias level: level
  property alias player: level.player
  property alias entityContainer: level
  //property alias itemEditor: itemEditor

  // make 1 grid (so 1 block and the player size) 48 logical px - a roost has this size, so 320/48= 6.6 can be displayed in one scene
  gridSize: 96//48//32

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

  Keys.onReleased: {
    if(event.key === Qt.Key_Plus)
      // the level is moved faster, when the accel is increased in its negative direction
      level.accelerate(-40)
    else if(event.key === Qt.Key_Minus)
      level.accelerate(+40)
    else if(event.key === Qt.Key_R)
      level.restartGame()
  }


  Text {
    id: scoreText

    // place it on top of the window, not on top of the logical scene
    anchors.top: scene.gameWindowAnchorItem.top
    anchors.horizontalCenter: scene.horizontalCenter
    anchors.topMargin: 5

    text: "Score: " + Math.round(player.totalScore)// + " Lives:" + player.lives + " Speed:" + -Math.round(level.levelMovementSpeedCurrent)
    font.family: fontHUD.name
    font.pixelSize: 22
    color: "blue"
  }

  // gets called by Main when this scene gets active
  // starts a game again - stopGame() was called before so it is save to call that here
  function enterScene() {
    level.startGame();
  }


  // ------------------- debugging-only code ------------------- //

  // this button is only for testing and only visible in debug mode
  // it shows the ingameMenu to quickly restart the game and test different performance options
  /*SimpleButton {
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
  }*/
  Image {
    source: "img/pausebutton.png"
    width: 64
    height: 32
    anchors.top: scene.gameWindowAnchorItem.top
    anchors.right: scene.gameWindowAnchorItem.right
    anchors.rightMargin: -5

    MultiTouchArea {
      anchors.fill: parent
      onClicked: {
        // this activates the ingameMenu state, which will show the IngameMenu item
        if(scene.state == "") {
          scene.state = "ingameMenu"
        } else {
          scene.state = ""
        }
      }
    }

  }


  // this gets only displayed when the menu button is pressed, which is only allowed in debug builds
  IngameMenu {
    id: ingameMenu
    // in the default state, this should be invisible!
    visible: false
    anchors.centerIn: parent
  }

  PressureOverlay {
    id: pressureOverlay

    pressure: player.steamPressure

    anchors.bottom: scene.gameWindowAnchorItem.bottom
    anchors.left: scene.gameWindowAnchorItem.left
    anchors.leftMargin: 10
    anchors.bottomMargin: 10
  }

  HornControl {
    anchors.top: scene.gameWindowAnchorItem.top
    anchors.left: scene.gameWindowAnchorItem.left
    anchors.leftMargin: 4

    onHonkingChanged: {
      // Honking is only possible if we have more than 20% steam
      if (honking && player.steamPressure >= player.steamPressureDeltaForHonking) {
        hornSound.play()
        player.steamParticle.start()
        player.steamParticle2.start()
        level.moveFirstObstacleInCurrentTrack()
        player.steamPressure -= player.steamPressureDeltaForHonking
      } else {
        player.steamParticle.stop()
        player.steamParticle2.stop()
      }
    }

    Sound {
      id: hornSound
      source: "snd/horn.wav"
    }
  }

  ThrottleControl {
    anchors.right: scene.gameWindowAnchorItem.right
    anchors.bottom: scene.gameWindowAnchorItem.bottom
    anchors.rightMargin: 10

    onBrakeChanged: {
      if (brake) {
        level.setAcceleration(20);
      }
      else {
        level.setAcceleration(0)
      }
    }

    onAccelerationChanged: {
      level.setAcceleration(-acceleration)
    }
  }

  Row {
    id: row
    anchors.bottom: scene.gameWindowAnchorItem.bottom
    anchors.horizontalCenter: scene.horizontalCenter
    spacing: 10

    Repeater {
      model: player.lives

      onModelChanged: {
        loadItemWithCocos(row)
      }

      Image {
        source: "img/moose-sd.png"
        width: 32
        height: 32
      }
    }
  }

  /*
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
  */

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
      StateChangeScript {
        script: {
          level.pauseGame();
        }
      }
    }

  ]
}
