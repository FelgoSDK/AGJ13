
import QtQuick 1.1
import Box2D 1.0
import VPlay 1.0
import "entities"
import "TrackLogic.js" as TrackLogic

// the level gets moved in the negative y direction (so upwards) -> this has the effect that all entities in it are moving downwards!
// no Flickable is needed as root item, because it shouldnt be able to get pinched or moved by the user - instead the level gets moved downwards over time with increasing speed
//Flickable {
Item {
  id: level
<<<<<<< HEAD
=======
  // use the logical size as the level size
  width: scene.width
  height: scene.height
>>>>>>> 3af59a51204d8f50fb4b34596a1e772e2e99a6e3

  // just as an abbreviation of typing, so instead of scene.gridSize just gridSize can be written in this file
  property real gridSize: scene.gridSize

  // available columns for creating roosts - the current logical scene width is 320, gridSize is 48, so 6 and a half roosts can be displayed horizontally
  property int roostColumns: width/gridSize

  // gets used to measure how much the level was moved downwards in the last frame - if this is bigger than gridSize, a new row will be created in onYChanged
  property real lastY: 0

  // how many new rows were created, it starts with 0 if the level has y position 0, and then gets increased with every gridSize
  // gets initialized in onCompleted
  property real currentRow: 0

  // this is needed so an alias can be created from the main window!
  property alias player: player

  // specifies the px/second how much the level moves
  property real levelMovementSpeedMinimum: 20
  property real levelMovementSpeedMaximum: 90
  // after 30seconds, the maximum speed will be reached - if you set this too high, also increase the gravity so the chicken falls faster than the level moves
  property int levelMovementDurationTillMaximum: 30

  // with 9% probability, a roost will get created in a row for any column
  // if it gets set too low, the game will be unplayable because too few roosts are created, so balance this with care!
  property real platformCreationProbability: 0.09
  // probability of 30% to create a corn on top of the roost, so in 3 of 10 roosts there will be a corn created
  property real coinCreationPropability: 0.3
  // windows get created randomly as well - they only have visual effect, but dont set too high because then it looks boring
  property real windowCreationProbability: 0.05
  // this avoids creating too many windows, so not possible to have more than 2 on a scene with this code!
  property real minimumWindowHeightDifference: 300

  // is needed internally to avoid creating too many windows close to each other
  property int lastWindowY: 0

  // the background images are moved up by this offset so on widescreen devices the full background is visible
  property real __yOffsetForWindow: scene.__yOffsetForAbsoluteWindowCoordinates

  // gets emitted when a BorderRegion.onPlayerCollision() is received
  signal gameLost

  Component.onCompleted: {

    // this creates some roosts, coins and windows beforehand, so they dont need to be created at runtime
    preCreateEntityPool();

    // startGame() is called in ChickenOutbreakScene.enterScene()
  }

  function preCreateEntityPool() {

    // dont pool entities on Sym & meego - creation takes very long on these platforms
    if(system.isPlatform(System.Meego) || system.isPlatform(System.Symbian))
      return;

  }


  function stopGame() {

    // this function automatically pools all entities which have poolingEnabled set to true
    // and it ignores the entities that have preventFromRemovalFromEntityManager set to true
    entityManager.removeAllEntities();

    // only use this for debugging, whena game should immediately be started after it was stopped
    //startGame();
  }

  // initialize level data - this function can be called multiple times, so every time a new game gets started
  // it is called from ChickenOutbreakScene.enterScene()
  function startGame() {
    console.debug("Level: startGame()");

    // it is important that lastY is set first, so the dy in onYChanged will be 0 and no new row is created
    currentRow = 0;
    lastY = 0;

    level.y = 0;    

//    player.x = scene.width/2;
//    player.y = 2*gridSize;

    player.score = 0;
    player.bonusScore = 0;

    // this is required, otherwise after the game the chicken would still navigate left or right if no mouse release happened before, or when coming from the main scene it might still have the old direction
    player.controller.xAxis = 0;

<<<<<<< HEAD
=======
    // start positioned on the window top
    levelBackground.y = -__yOffsetForWindow;
    levelBackground2.y = levelBackground.y+levelBackgroundHeight;

    // this must be set BEFORE createRandomRowForRowNumber() is called!
    lastWindowY = 0;

    TrackLogic.initTrack()
  }

  // this is the offset of the 2 backgrounds
  // make the offset a litte bit smaller, so no black background shines through when they are put below each other
  property real levelBackgroundHeight: levelBackground.height*levelBackground.scale-1

  MultiResolutionImage {
    //BackgroundImage { // dont use a BackgroundImage yet, because blending isnt working correclty! (overlapping regions appear lighter!)
    id:levelBackground
    source: "img/background-wood2-sd.png"

    // the logical width should be the scene size - this will change when the background image is bigger than the scene size to support multiple resolutions & aspect ratios
    // in that case, use a MultiResolutionImage with pixelFormat set to 3 and position it in the horizontal center
    // multiply width & height by 1.2, so it is still visible on 4:3 and 16:9 ratios!
    scale: 1.2

    // position horizontally centered
    anchors.horizontalCenter: parent.horizontalCenter

    // the windows have z=-1, all other objects have 0, so put behind the windows
    z:-2

    // the y value gets modified in onYChanged, to always position 2 background images below each other
  }

  MultiResolutionImage {
    //BackgroundImage { // dont use a BackgroundImage yet, because blending isnt working correclty! (overlapping regions appear lighter!)
    id:levelBackground2
    source: "img/background-wood2-sd.png"

    //opacity: 0.6 // for testing the second copy of the background
    scale: 1.2

    // position horizontally centered
    anchors.horizontalCenter: parent.horizontalCenter

    // the windows have z=-1, all other objects have 0, so put behind the windows
    z:-2

    // the y value gets modified in onYChanged, to always position 2 background images below each other
    //y: scene.height // initially move down, and increase its size so the 2 backgrounds overlap
>>>>>>> 3af59a51204d8f50fb4b34596a1e772e2e99a6e3
  }

  // start in the center of the scene, and a little bit below the top
  // the player will fall to the playerInitialBlock below at start
  Player {
    id: player

    x: 0
    y: level.height/2

    // this guarantees the player is in front of the henhouseWindows
    z: 1
  }

  Row {
    height: level.height
    Repeater {
      model: 5
      Column {
        x: level.width/5*index
        width: level.width/5
        opacity: index%2 ? 0.5 : 1
        Rectangle {
          width: level.width/5
          height: level.height/7
          color: "green"
        }
        Rectangle {
          width: level.width/5
          height: level.height/7/5
          color: "green"
        }
        Rectangle {
          width: level.width/5
          height: level.height/7
          color: "grey"
        }
        Rectangle {
          width: level.width/5
          height: level.height/7/5
          color: "green"
        }
        Rectangle {
          width: level.width/5
          height: level.height/7
          color: "grey"
        }
        Rectangle {
          width: level.width/5
          height: level.height/7/5
          color: "green"
        }
        Rectangle {
          width: level.width/5
          height: level.height/7
          color: "grey"
        }
        Rectangle {
          width: level.width/5
          height: level.height/7/5
          color: "green"
        }
        Rectangle {
          width: level.width/5
          height: level.height/7
          color: "grey"
        }
        Rectangle {
          width: level.width/5
          height: level.height/7/5
          color: "green"
        }
        Rectangle {
          width: level.width/5
          height: level.height/7
          color: "green"
        }
      }
    }
  }


  // ------------------- for debugging only ------------------- //
  function pauseGame() {
    console.debug("pauseGame()")
  }
  function resumeGame() {
    console.debug("resumeGame()")
  }

  function restartGame() {
    console.debug("restartGame()")
    stopGame();
    startGame();
  }
}
