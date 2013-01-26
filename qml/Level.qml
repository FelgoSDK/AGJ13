
import QtQuick 1.1
import Box2D 1.0
import VPlay 1.0
import "entities"
import "particles"
import "scripts/levelLogic.js" as LevelLogic

// the level gets moved in the negative y direction (so upwards) -> this has the effect that all entities in it are moving downwards!
// no Flickable is needed as root item, because it shouldnt be able to get pinched or moved by the user - instead the level gets moved downwards over time with increasing speed
//Flickable {
Item {
  id: level

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
  property real levelMovementSpeedMaximum: 800
  property real levelMovementSpeed: 50//levelMovementSpeedMinimum


  // with 9% probability, a roost will get created in a row for any column
  // if it gets set too low, the game will be unplayable because too few roosts are created, so balance this with care!
  property real platformCreationProbability: 0.09
  // probability of 30% to create a obstacle on top of the track, so in 3 of 10 tracks there will be a obstacle created
  property real obstacleCreationPropability: 0.3
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
  property real trackSectionHeight: scene.height/5


  // just as an abbreviation of typing, so instead of scene.gridSize just gridSize can be written in this file
  property real gridSize: trackSectionWidth//scene.gridSize

  // make some more, so it goes outside
  // 5 more is too few! otherwise the creation would not work well enough!
  property int numVisibleTracks: level.width/trackSectionWidth + 40 // for testing the creation and make it visible in the scene, set the additional amount to 0

  // the background images are moved up by this offset so on widescreen devices the full background is visible
  property real __xOffsetForWindow: scene.__xOffsetForAbsoluteWindowCoordinates


  // players collide with obstacles (game lost) and trackSections (if direction chan
  // borderRegion collides with obstacles and trackSections
  property int borderRegionColliderGroup: Box.Category1
  property int trackSectionColliderGroup: Box.Category2
  property int playerColliderGroup: Box.Category3
  property int obstacleColliderGroup: Box.Category4

  // TODO: test if pooling is SLOWER than re-creation!?
  // pooling doesnt work with variationTypes yet!
  property bool trackSectionPoolingEnabled: false

  EditableComponent {
      id: editableEditorComponent
      target: parent
      type: "Level"
      properties: {
        "railAmount":               {"minimum": 0, "maximum": 10,"stepsize": 1,  "default": 3},
        "playerRowActive":          {"minimum": 0, "maximum": railAmount,"stepsize": 1,  "default": 1},
        "trackSectionPoolingEnabled":          {"minimum": false, "maximum": true, "default": trackSectionPoolingEnabled},

        // Particle configuration properties
        "obstacleCreationPropability":               {"minimum": 0, "maximum": 1, "default": 0.3,"stepsize": 0.01, "label": "Obstacles" /*,"group": "level"*/},
        "levelMovementSpeed":                      {"minimum": 0, "maximum": 1000, "default": levelMovementSpeed,"stepsize": 1, /*"group": "level"*/},
        "levelMovementSpeedMinimum":               {"minimum": 0, "maximum": 1000, "default": levelMovementSpeedMinimum,"stepsize": 1, /*"group": "level"*/},
        "levelMovementSpeedMaximum":               {"minimum": 0, "maximum": 1000, "default": levelMovementSpeedMaximum,"stepsize": 1, /*"group": "level"*/},
      }
  }

  Component.onCompleted: {

    // this creates some roosts, coins and windows beforehand, so they dont need to be created at runtime
    preCreateEntityPool();

    // startGame() is called in ChickenOutbreakScene.enterScene()
  }

  function preCreateEntityPool() {
//    entityManager.createPooledEntitiesFromUrl(Qt.resolvedUrl("entities/TrackSection.qml"), 40);
    entityManager.createPooledEntitiesFromUrl(Qt.resolvedUrl("entities/Obstacle.qml"), 10);

  }


  function stopGame() {

    console.debug("stopGame")

    levelMovementAnimation.stop()

    // this function automatically pools all entities which have poolingEnabled set to true
    // and it ignores the entities that have preventFromRemovalFromEntityManager set to true
    entityManager.removeAllEntities();
    // from now on generate obstacles
    LevelLogic.generateObstacles = false

    // only use this for debugging, whena game should immediately be started after it was stopped
    //startGame();
  }

  // initialize level data - this function can be called multiple times, so every time a new game gets started
  // it is called from ChickenOutbreakScene.enterScene()
  function startGame() {
    console.debug("Level: startGame()");

    // it is important that lastY is set first, so the dy in onYChanged will be 0 and no new row is created
    currentRow = 0    

    level.x = 0 // set it to 10000 to test float inaccuracies
    lastX = level.x

    player.init()

    // start positioned on the window top
    levelBackground.x = -__xOffsetForWindow;
    levelBackground2.x = levelBackground.x+levelBackgroundWidth;

    console.debug("numVisibleTracks:", numVisibleTracks)
    for(var i=0; i<numVisibleTracks; i++) {
      LevelLogic.createRandomRowForRowNumber(i);
    }
    // from now on generate obstacles
    LevelLogic.generateObstacles = true


    // the minimum is still 0 here!?
//    levelMovementSpeed = -levelMovementSpeedMinimum
    //levelMovementAnimation.velocity = -levelMovementSpeedMinimum
    // levelMovementAnimation.velocity = -levelMovementSpeedMaximum // for performance testing with higher velocity
    levelMovementAnimation.start();

    console.debug("movementanimation.v:", levelMovementAnimation.velocity)
  }

  // this is the offset of the 2 backgrounds
  // make the offset a litte bit smaller, so no black background shines through when they are put below each other
  property real levelBackgroundWidth: levelBackground.width*levelBackground.scale-1

  MultiResolutionImage {
    //BackgroundImage { // dont use a BackgroundImage yet, because blending isnt working correclty! (overlapping regions appear lighter!)
    id:levelBackground
    source: "img/background-wood2-sd.png"

    // the logical width should be the scene size - this will change when the background image is bigger than the scene size to support multiple resolutions & aspect ratios
    // in that case, use a MultiResolutionImage with pixelFormat set to 3 and position it in the horizontal center
    // multiply width & height by 1.2, so it is still visible on 4:3 and 16:9 ratios!
    scale: 1.2

    // position horizontally centered
    anchors.verticalCenter: parent.verticalCenter

    // the windows have z=-1, all other objects have 0, so put behind the windows
    z:-2
  }

  MultiResolutionImage {
    //BackgroundImage { // dont use a BackgroundImage yet, because blending isnt working correclty! (overlapping regions appear lighter!)
    id:levelBackground2
    source: "img/background-wood2-sd.png"

    //opacity: 0.6 // for testing the second copy of the background
    scale: 1.2

    // position horizontally centered
    anchors.verticalCenter: parent.verticalCenter

    // the windows have z=-1, all other objects have 0, so put behind the windows
    z:-2
  }


  // start in the center of the scene, and a little bit below the top
  // the player will fall to the playerInitialBlock below at start
  Player {
    id: player

    x: -level.x + player.sprite.width/2
    // y will be initialized in init()

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

    SmokeParticle {
      id: chimneyParticle
      x: 30
      Component.onCompleted: {
        chimneyParticle.start()
      }
    }
    SmokeParticle {
      id: chimneyExplotionParticle
      x: 30
      sourcePositionVariance: Qt.point(7,7)
      duration: 0.1
      gravity: Qt.point(0,0)
      particleLifespan: 0.46
      particleLifespanVariance: 0.11
      angleVariance: 360
      radialAcceleration: -1000
      tangentialAcceleration: 4
      finishParticleSize: 0
      finishParticleSizeVariance: 0
      speed: 277
      speedVariance: 6.58
      startColor: Qt.rgba(1.0,0.18,0.0,0.90)
      finishColor: Qt.rgba(1.0,1.0,1.0,0.0)
    }
  }

  BorderRegion {
    x: -level.x - width - trackSectionWidth// + 5
    // for testing the functionality, put it inside the view not outside
    //x: -level.x
    y: scene.gameWindowAnchorItem.x
    height: scene.gameWindowAnchorItem.height// make bigger than the window, because the roost can stand out of the scene on the right side when the gridSize is not a multiple of the scene.width (which it currently is: 320/48=6.6) and thus if the player would stand on the right side no collision would be detected!
    width: 80 // make big enough, so they dont go through
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

  Timer {
    id: pressureTimer

    // Trigger every 0.5 sec, so the maximum steam power of 100 would be lost after 5sec on full acceleration
    interval: 500;
    // Can't use levelMovementSpeed cause it never gets adapt to acceleration influenced velocity changes
    // Instead we use -levelMovementAnimation.velocity directly
    running: levelMovementAnimation.acceleration < 0 && player.steamPressure > 0 && -levelMovementAnimation.velocity !== levelMovementSpeedMaximum || levelMovementAnimation.acceleration > 0 && -levelMovementAnimation.velocity !== levelMovementSpeedMinimum
    repeat: true
    onTriggered: {

      console.log("levelMovementSpeed", levelMovementSpeed, "levelMovementSpeedMinimum", levelMovementSpeedMinimum)

      // Acceleration is negative
      player.steamPressure += levelMovementAnimation.acceleration / 10

      if (player.steamPressure < 0) {
        player.steamPressure = 0
        // Stop acceleration if there is not enough pressure available
        levelMovementAnimation.acceleration = 0
      }
    }
  }

  Timer {
    id: pressureRegenerationTimer

    interval: 2500;
    running: !pressureTimer.running && player.steamPressure <= 100
    repeat: true
    onTriggered: {
      // Our steam pressure regenerates slowly while travelling uniformly
      player.steamPressure += 2
      if (player.steamPressure > 100) {
        player.steamPressure = 100
      }
    }
  }

  MovementAnimation {
    id: levelMovementAnimation
    property: "x"

    target: level
    // target: tracks probably wont work, because physics only takes the direct position!?

    // this is the movement in px per second, start with very slow movement, 10 px per second
    velocity: -levelMovementSpeed

    onVelocityChanged: {
      var colormult = velocity*(-1)/1000
      console.log("===="+colormult)
      if(colormult>0.75) {
        chimneyExplotionParticle.start()
        chimneyParticle.startColor = Qt.rgba(1.0,0.5,1-colormult,colormult)
      } else {
        chimneyParticle.startColor = Qt.rgba(1-colormult,1-colormult,1-colormult,colormult)
      }
      //console.debug("vel changed to:", velocity)
    }

    // running is set to false - call start() here
    // increase the velocity by this amount of pixels per second, so it lasts minVelocity/acceleration seconds until the maximum is reached!
    // i.e. -70/-2 = 45 seconds
    //90-20 = 70 / 30 = 2.5
    acceleration: 0 //-(levelMovementSpeedMaximum-levelMovementSpeedMinimum) / levelMovementDurationTillMaximum

    // limit the maximum v to 100 px per second - it must not be faster than the gravity! this is the absolute maximum, so the chicken falls almost as fast as the background moves by! so rather set it to -90, or increase the gravity
    minVelocity: -levelMovementSpeedMaximum
    // Use a certain minimum speed
    maxVelocity: -levelMovementSpeedMinimum
  }

  onXChanged: {
    // y gets more and more negative, so e.g. -40 - (-25) = -15
    var dx = x - lastX;
    //console.debug("level.dx:", -dx, "currentRow:", currentRow, ", x:", -x, ", lastX:", -lastX)
    if(-dx > gridSize) {

      var amountNewRows = (-dx/gridSize).toFixed();
      //console.debug(amountNewRows, "new rows are getting created...")

      if(amountNewRows>1) {
        console.debug("WARNING: the step difference was too big, more than 1 track got created!")
      }

      // if y changes a lot within the last frame, multiple rows might get created
      // this doesnt happen with fixed dt, but it could happen with varying dt where more than 1 row might need to be created because of such a big y delta
      for(var i=0; i<amountNewRows; i++) {        
        // this guarantees it is created outside of the visual screen
        LevelLogic.createRandomRowForRowNumber(currentRow+numVisibleTracks);
        currentRow++;
      }

      lastX = x;

    }

    // handles the repositioning of the backgrounds, if they are getting out of the scene
    // by tiling the 2 backgrounds vertically, it appears to the user as being one continuous background
    if(-x-__xOffsetForWindow > (levelBackground.x+levelBackgroundWidth)) {
      //console.debug("shift background1 down from", levelBackground.x, levelBackgroundWidth)
      levelBackground.x += 2*levelBackgroundWidth
      //console.debug("... to", levelBackground.x)
    }
    if(-x-__yOffsetForWindow > (levelBackground2.x+levelBackgroundWidth)) {
      //console.debug("shift background2 down from", levelBackground2.x, levelBackgroundWidth )
      levelBackground2.x += 2*levelBackgroundWidth
      //console.debug("... to", levelBackground2.x)
    }


    // TODO: use a bitmap font for text updating which is much faster -> this feature is not supported by V-Play yet, contact us if you would need it at team@v-play.net
    // for performance reasons, disable the score updating every frame, which is expensive with the text element because a texture is recreated every time the text changes!
    if(enableConstantScoreTextUpdating)
      player.score = -level.x.toFixed()
    else
      // divide by an arbitrary number, so the text doesnt get changed every frame which is bad for performance as it is no bitmap font yet!
      player.score = -(level.x/40).toFixed()

  }

  function accelerate(diff) {
    levelMovementAnimation.acceleration += diff

    console.debug("acceleration diff:", diff, "new acc:", levelMovementAnimation.acceleration)

  }

  function setAcceleration(acceleration) {
    // We can't accelerate if our steam pressure is 0
    if (player.steamPressure <= 0 && acceleration < 0)
      return;

    levelMovementAnimation.acceleration = acceleration * 10

    console.debug("New acceleration:", acceleration)
  }

  function moveFirstObstacleInCurrentTrack() {
    // Get obstacles of type cow
    var obstacles = entityManager.getEntityArrayByType("obstacle")

    var currentY = startYForFirstRail + playerRowActive * trackSectionHeight

    for (var i = 0; i < obstacles.length; i++) {
      var o = obstacles[i]

      // Use obstacle only if on current track and before the player
      if (o.y === currentY && o.x > player.x) {
        // Obstacle is on top
        if (playerRowActive == 0)
          o.y += trackSectionHeight
        // Obstacle is on bottom
        else if (playerRowActive === railAmount - 1)
          o.y -= trackSectionHeight
        // Obstacle is in between
        else {
          // Dirty random boolean
          var flag = !! Math.round(Math.random() * 1)
          if (flag)
            o.y += trackSectionHeight
          else
            o.y -= trackSectionHeight
        }
        return;
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
