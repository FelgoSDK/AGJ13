
import QtQuick 1.1
import Box2D 1.0
import VPlay 1.0
import "entities"
import "TrackLogic.js" as TrackLogic
import "scripts/levelLogic.js" as LevelLogic

// the level gets moved in the negative y direction (so upwards) -> this has the effect that all entities in it are moving downwards!
// no Flickable is needed as root item, because it shouldnt be able to get pinched or moved by the user - instead the level gets moved downwards over time with increasing speed
//Flickable {
Item {
  id: level

  // just as an abbreviation of typing, so instead of scene.gridSize just gridSize can be written in this file
  property real gridSize: trackSectionWidth//scene.gridSize

  // available columns for creating roosts - the current logical scene width is 320, gridSize is 48, so 6 and a half roosts can be displayed horizontally
  property int roostColumns: width/gridSize

  // gets used to measure how much the level was moved downwards in the last frame - if this is bigger than gridSize, a new row will be created in onYChanged
  property real lastX: 0

  // how many new rows were created, it starts with 0 if the level has y position 0, and then gets increased with every gridSize
  // gets initialized in onCompleted
  property real currentRow: 0

  // the player starts in the middle track 0, and then moves upwards or downwards
  property int playerRow: 1
  // the player track which is currently active which does not influent the startYForFirstRail.
  property int playerRowActive: 1

  property int railAmount: 3

  property real startYForFirstRail: level.height/2 - (railAmount-playerRow)/2 * trackSectionHeight

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
  // probability of 30% to create a obstacle on top of the track, so in 3 of 10 tracks there will be a obstacle created
  property real obstacleCreationPropability: 0.1
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

  property real trackSectionWidth: scene.width/7
  property real trackSectionHeight: scene.width/5

  property real numVisibleTracks: level.width/trackSectionWidth

  // players collide with obstacles (game lost) and trackSections (if direction chan
  // borderRegion collides with obstacles and trackSections
  property int borderRegionColliderGroup: Box.Category1
  property int trackSectionColliderGroup: Box.Category2
  property int playerColliderGroup: Box.Category3

  Component.onCompleted: {

    // this creates some roosts, coins and windows beforehand, so they dont need to be created at runtime
    preCreateEntityPool();

    // startGame() is called in ChickenOutbreakScene.enterScene()
  }

  function preCreateEntityPool() {

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
    currentRow = 0
    lastX = 0

    level.x = 0

//    player.x = scene.width/2;
//    player.y = 2*gridSize;

    player.score = 0;
    player.bonusScore = 0;

    // this is required, otherwise after the game the chicken would still navigate left or right if no mouse release happened before, or when coming from the main scene it might still have the old direction
    player.controller.xAxis = 0;


    TrackLogic.initTrack()



    console.debug("numVisibleTracks:", numVisibleTracks)
    for(var i=0; i<numVisibleTracks; i++) {
      LevelLogic.createRandomRowForRowNumber(i);
    }

    levelMovementAnimation.velocity = -levelMovementSpeedMinimum;
    levelMovementAnimation.start();
  }

  // start in the center of the scene, and a little bit below the top
  // the player will fall to the playerInitialBlock below at start
  Player {
    id: player

    x: -level.x + 50
    y: level.height/2

    // this guarantees the player is in front of the henhouseWindows
    z: 1
    onDied: {
      console.debug("PLAYER COLLIDED WITH obstacle, level.y:", level.y, ", player.y:", player.y)
      // emit the gameLost signal, which is handled in MainScene
      gameLost();
    }
    onCollisionWithTrackSection: {
      console.debug("PLAYER COLLIDED WITH trackelement, variation:",direction)
      if(direction === "up") {
        playerRowActive--
        if(playerRowActive<0)
          playerRowActive = 0
      } else if(direction === "down") {
        playerRowActive++
        if(playerRowActive>railAmount-1)
          playerRowActive = railAmount-1
      }
      player.y = startYForFirstRail+(playerRowActive)*trackSectionHeight
    }
  }

  BorderRegion {
    //x: -level.x - width - trackSectionWidth
    // for testing the functionality, put it inside the view not outside
    x: -level.x
    y: scene.gameWindowAnchorItem.x
    height: scene.gameWindowAnchorItem.height// make bigger than the window, because the roost can stand out of the scene on the right side when the gridSize is not a multiple of the scene.width (which it currently is: 320/48=6.6) and thus if the player would stand on the right side no collision would be detected!
    width: 20
  }

  /* TODO: does it work with physics, when the tracks are moved, and not the whole world? i guess not, because the positions are not mapped to world when the parent changes!
  Item {
    id: tracks
    TrackSection {
    }

    TrackSection {
      x: 100
      y: scene.height/2
    }
  }
  */

  MovementAnimation {
    id: levelMovementAnimation
    property: "x"

    target: level
    // target: tracks probably wont work, because physics only takes the direct position!?

    // this is the movement in px per second, start with very slow movement, 10 px per second
    velocity: -levelMovementSpeedMinimum
    // running is set to false - call start() here
    // increase the velocity by this amount of pixels per second, so it lasts minVelocity/acceleration seconds until the maximum is reached!
    // i.e. -90/-2 = 45 seconds
    acceleration: -(levelMovementSpeedMaximum-levelMovementSpeedMinimum) / levelMovementDurationTillMaximum

    // limit the maximum v to 100 px per second - it must not be faster than the gravity! this is the absolute maximum, so the chicken falls almost as fast as the background moves by! so rather set it to -90, or increase the gravity
    minVelocity: -levelMovementSpeedMaximum

    //onVelocityChanged: console.debug("velocity changed to:", velocity)
  }




  /*
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
  } */

  onXChanged: {
    // y gets more and more negative, so e.g. -40 - (-25) = -15
    var dx = x - lastX;
    //console.debug("level.dx:", -dx, "currentRow:", currentRow, ", x:", -x, ", lastX:", -lastX)
    if(-dx > gridSize) {

      var amountNewRows = (-dx/gridSize).toFixed();
      //console.debug(amountNewRows, "new rows are getting created...")

      // if y changes a lot within the last frame, multiple rows might get created
      // this doesnt happen with fixed dt, but it could happen with varying dt where more than 1 row might need to be created because of such a big y delta
      for(var i=0; i<amountNewRows; i++) {
        currentRow++;
        // this guarantees it is created outside of the visual screen
        LevelLogic.createRandomRowForRowNumber(currentRow+numVisibleTracks-1);
      }

      lastX = x;

    }

    // handles the repositioning of the backgrounds, if they are getting out of the scene
    // by tiling the 2 backgrounds vertically, it appears to the user as being one continuous background
//    if(-x-__yOffsetForWindow > (levelBackground.y+levelBackgroundHeight)) {
//      console.debug("shift background1 down from", levelBackground.y)
//      levelBackground.y += 2*levelBackgroundHeight;
//      console.debug("... to", levelBackground.y)
//    }
//    if(-y-__yOffsetForWindow > (levelBackground2.y+levelBackgroundHeight)) {
//      console.debug("shift background2 down from", levelBackground2.y)
//      levelBackground2.y += 2*levelBackgroundHeight;
//      console.debug("... to", levelBackground2.y)
//    }


    // TODO: use a bitmap font for text updating which is much faster -> this feature is not supported by V-Play yet, contact us if you would need it at team@v-play.net
    // for performance reasons, disable the score updating every frame, which is expensive with the text element because a texture is recreated every time the text changes!
    if(enableConstantScoreTextUpdating)
      player.score = -level.x.toFixed()
    else
      // divide by an arbitrary number, so the text doesnt get changed every frame which is bad for performance as it is no bitmap font yet!
      player.score = -(level.x/40).toFixed()

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
