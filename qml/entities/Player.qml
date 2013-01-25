// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Box2D 1.0
import VPlay 1.0

EntityBase {
  entityType: "player"

  // the key-pressed-signals get emitted from the scene when key presses are detected
  // key pressed cant be detected here, because this item has no size
  signal leftPressed(variant event)
  signal rightPressed(variant event)
  signal upPressed(variant event)
  signal downPressed(variant event)

  signal died

  // gets increased over time - it has the same value as the y value of the level
  property int score: 0
  // gets increased when a coin is collected
  property int bonusScore: 0
  // the total score is the one that gets displayed
  property int totalScore: score + (bonusScore * bonusScoreForCoin)
  // the total count of deaths within this gaming session
  property int deaths: 0

  // this gets added to bonusScore every time the player catches a coin
  property int bonusScoreForCoin: 300

  property alias controller: twoAxisController

  // these are the settings for balancing!
  property real upValue: 550
  property real downValue: 5
  property real rightValue: 250
  property real leftValue: -rightValue

  //    property variant respawnPosition: Qt.point(50,100)

  property bool __isJumping: true
  // cant be initialized with null
  property date lastJumpTime: new Date

  // this is needed internally to find out if the image should be inverted
  property bool __isLookingRight: true


  // set the default pos to the respawnPosition
  //pos: respawnPosition

  // by setting this to true, the removeAllEntities() does not affect this entity, which is called from Level.stopGame()
  preventFromRemovalFromEntityManager: true


  // gets increased when a collision with a block occurs in onBeginContact, and decreased in onEndContact
  // when no blockCollisions happened, the fly-state is active!
  property int blockCollisions: 0


  TwoAxisController {
    id: twoAxisController

    onXAxisChanged: {
      console.debug("xAxis changed to", xAxis)
      if(xAxis>0)
        __isLookingRight = true;
      else if(xAxis<0)
        __isLookingRight = false;
    }
  }

  Rectangle {
    width: 40
    height: 40
    anchors.centerIn: parent
    color: "red"
  }

}
