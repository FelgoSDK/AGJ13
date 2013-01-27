import QtQuick 1.1
import Box2D 1.0
import VPlay 1.0
import "../particles"

EntityBase {
  entityType: "player"

  property alias sprite: sprite
  property alias steamParticle: steamParticle
  property alias steamParticle2: steamParticle2

  signal died
  signal collisionWithTrackSection(string direction)

  signal collision
  // Currently not used
  signal coalScooped

  // gets increased over time - it has the same value as the y value of the level
  property int score: 0
  // gets increased when a coin is collected
  property int bonusScore: 0
  // the total score is the one that gets displayed
  property int totalScore: score + (bonusScore * bonusScoreForCoin)
  // the total count of deaths within this gaming session
  property int deaths: 0

  // Gets decreased while accelerating and honking, increases while acceleration is 0
  property int steamPressure: 100
  property int steamPressureDeltaForHonking: 20
  property int steamPressureIncreaseWithScooping: 4

  property int initialLives: 100

  property int lives: initialLives

  // this gets added to bonusScore every time the player catches a coin
  property int bonusScoreForCoin: 300

  // set the default pos to the respawnPosition
  //pos: respawnPosition

  // by setting this to true, the removeAllEntities() does not affect this entity, which is called from Level.stopGame()
  preventFromRemovalFromEntityManager: true


  // gets increased when a collision with a block occurs in onBeginContact, and decreased in onEndContact
  // when no blockCollisions happened, the fly-state is active!
  property int blockCollisions: 0

  // drive curves with locomotive
  property variant endPoint : 0
  property bool followingPath: false
  property real velocity: 200

  property real offset: 20
  MultiResolutionImage {
    id: sprite
    source:  "../img/train-sd.png"
    anchors.centerIn: parent
    onHeightChanged: collider.height = sprite.height-offset*2
    onWidthChanged: collider.width = sprite.width-offset*2
  }

  MultiTouchArea {
    anchors.left: sprite.left
    anchors.verticalCenter: sprite.verticalCenter
    width: sprite.width / 2
    height: sprite.height

    enabled: level.multiplayer

    onSwipe: {
      // Swipe to the right
      if (angle  > 330 || angle < 30) {
        steamPressure += steamPressureIncreaseWithScooping
        coalScooped()
      }
    }
  }

  // Used for velocity-based sound effect
  Repeater {
    id: soundRepeater
    model: 4

    Sound {
      source: "../snd/trainspeed" + index + ".wav"
      loops: SoundEffect.Infinite
    }
  }

  property int __currentSoundIndex: 0

  onVelocityChanged: {
    // Stop sound on velocity = 0
    if (velocity === 0) {
      soundRepeater.itemAt(__currentSoundIndex).stop()
      return
    }

    // Change sound sample according to speed
    var newSound = __currentSoundIndex

    if (-velocity < level.levelMovementSpeedMaximum / 8)
      newSound = 0
    else if (-velocity < level.levelMovementSpeedMaximum / 2)
      newSound = 1
    else if (-velocity < level.levelMovementSpeedMaximum / 4 * 3)
      newSound = 2
    else
      newSound = 3

    if (__currentSoundIndex !== newSound) {
      soundRepeater.itemAt(__currentSoundIndex).stop()
      __currentSoundIndex = newSound
      console.log("CURRRENT SOUND INEX:::::::::", __currentSoundIndex)
      soundRepeater.itemAt(__currentSoundIndex).play()
    }
  }

  BoxCollider {
    id: collider
    x: sprite.x+offset*2
    y: sprite.y+offset

    collisionTestingOnlyMode: true
    sensor: true

    Rectangle {
      anchors.fill: parent
      opacity: 0.6
      color: "red"
      visible: level.showCollision
    }

    categories: level.playerColliderGroup


    fixture.onBeginContact: {
      var fixture = other;
      var body = fixture.parent;
      var component = body.parent;
      var collidedEntity = component.owningEntity;
      var collidedEntityType = collidedEntity.entityType;
      if(collidedEntityType === "obstacle") {
        // the obstacle is pooled for better performance
        collidedEntity.removeEntity();

        lives--

        collision()

        if(lives <= 0)
          died()
      }
    }
  }

  function init() {
    lives = initialLives

    y = level.height/2

    console.debug("initialized player to level center:", x, y)
  }

  function trackChangeTo(point) {
    var sign = player.y - point.y
    var xdiff = Math.abs(player.x - point.x)
    var xoffset = player.x+player.sprite.width/2
    var ydiff = (sign > 0) ? (-1)*(player.y - point.y) : Math.abs(player.y - point.y)
    var yoffset =  player.y

    pathMovement.waypoints = [
          { x: player.x, y: player.y},
          { x: xoffset, y: yoffset  },
          { x: xoffset+xdiff/9*1, y: yoffset+ydiff/5*1},
          { x: xoffset+xdiff/9*3, y: yoffset+ydiff/5*3 },
          { x: xoffset+xdiff/9*5, y: yoffset+ydiff/5*4 },
          { x: xoffset+xdiff/9*9, y: yoffset+ydiff/5*5 }
        ]
    pathMovement.running = true
    followingPath = true
  }

  PathMovement {
    id: pathMovement
    enabled: false
    running: false
    velocity: player.velocity*(-1)+5
    rotationAnimationEnabled: true
    rotationAnimationDuration: player.velocity*(-1)/10


    onPathCompleted: {
      player.followingPath = false
      player.rotation = 0
    }
    Component.onCompleted: {
      player.x = -level.x + player.sprite.width/2
    }
  }

  SteamParticle {
    id: steamParticle
    x: 50
    y: 30
    rotation: 210
    Component.onCompleted: {
      steamParticle.stop()
    }
  }
  SteamParticle {
    id: steamParticle2
    x: 50
    y: -30
    rotation: -30
    Component.onCompleted: {
      steamParticle2.stop()
    }
  }
}
