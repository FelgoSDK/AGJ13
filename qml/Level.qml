
import QtQuick 1.1
import Box2D 1.0
import VPlay 1.0
import "entities"


// the level gets moved in the negative y direction (so upwards) -> this has the effect that all entities in it are moving downwards!
// no Flickable is needed as root item, because it shouldnt be able to get pinched or moved by the user - instead the level gets moved downwards over time with increasing speed
//Flickable {
Item {
  id: level

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
