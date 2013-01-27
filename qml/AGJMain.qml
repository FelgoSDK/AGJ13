import QtQuick 1.1
import VPlay 1.0

GameWindow {
  id: window

  width: 480*2//*1.5 // for testing on desktop with the highest res, use *1.5 so the -hd2 textures are used
  height: 320*2//*1.5


  property alias level: scene.level
  property alias player: scene.player // this works, when player is defined as alias in scene

  // for loading the stored highscore and displaying on GameOverScreen when a new highscore is reached
  // these get accessed from the MainScene and the ChickenOutbreakScene
  property int maximumHighscore: 0
  property int lastScore: 0

  displayFpsEnabled: true

  Component.onCompleted: {
    var storedScore = settings.getValue("maximumHighscore");
    // if first-time use, nothing can be loaded and storedScore is undefined
    if(storedScore)
      maximumHighscore = storedScore;

    // disable it, when you want no debug outputs in debug version
//    system.logOutputEnabled = false;
  }
  onMaximumHighscoreChanged: {
    var storedScore = settings.getValue("maximumHighscore");
    // if not stored anything yet, store the new value
    // or if a new highscore is reached, store that
    if(!storedScore || maximumHighscore > storedScore) {
      console.debug("stored improved highscore from", storedScore, "to", maximumHighscore);
      settings.setValue("maximumHighscore", maximumHighscore);
    }
  }

  // use BackgroundMusic for long-playing background sounds
  BackgroundMusic {
    id: backgroundMusic
    source: "snd/wind.wav"
    volume: 0.6
  }

  // Custom font loading of ttf fonts
  FontLoader {
    id: fontHUD
    source: "fonts/munro.ttf"
  }

  // this scene is set to visible when loaded initially, so its opacity value gets set to 1 in a PropertyChange below
  MainScene {
    id: mainScene
    opacity: 0
  }

  AGJScene {
    id: scene
    opacity: 0
  }

  GameOverScene {
    id: gameOverScene
    opacity: 0
  }

  CreditsScene {
    id: creditsScene
    opacity: 0
  }

  // for creating & removing entities
  EntityManager {
    id: entityManager
    entityContainer: scene.entityContainer    
    poolingEnabled: true
  }

  // this gets used for analytics, to know which state was ended before
  property string lastActiveState: ""

  onStateChanged: {
    if(state === "main")
      activeScene = mainScene;
    else if(state === "game")
      activeScene = scene;
    else if(state === "gameOver")
      activeScene = gameOverScene;
    else if(state === "credits")
      activeScene = creditsScene;

    lastActiveState = state;
  }

  // use state game for the beginning for debugging the game logic, as the game state gets entered in the beginning
  state: "main"
  // use one of the following states to start with another state when launching the game
//      state: "game"
  //state: "gameOver"

  // these states are switched when the play button is pressed in MainScene, when the game is lost and when the Continue button is pressed in GameOverScene
  states: [
    State {
      name: "main"
      // by switching the propery to 1, which is by default set to 0 above, the Behavior defined in SceneBase takes care of animating the opacity of the new Scene from 0 to 1, and the one of the old scene from 1 to 0
      PropertyChanges { target: mainScene; opacity: 1}

    },
    State {
      name: "game"
      PropertyChanges { target: scene; opacity: 1}
      StateChangeScript {
        script: {
          scene.enterScene();
        }
      }
    },
    State {
      name: "gameOver"
      PropertyChanges { target: gameOverScene; opacity: 1}
      StateChangeScript {
        script: {
          gameOverScene.enterScene();
        }
      }
    },
    State {
      name: "credits"
      PropertyChanges { target: creditsScene; opacity: 1}

    }
  ]
}
