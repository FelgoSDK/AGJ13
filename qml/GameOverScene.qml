import QtQuick 1.1
import VPlay 1.0

// gets displayed when the game is lost, and shows the reached score and if there was a new highscore reached
SceneBase {

  onBackPressed: {
    window.state = "main"
  }

  // this allows faster navigation through the scenes by pressing the Enter(=Return) key
  Keys.onReturnPressed: {
    window.state = "main"
  }

  ParallaxScrollingBackground {
    x: scene.gameWindowAnchorItem.x
    sourceImage: "img/background-snow1-sd.png"
    sourceImage2: "img/background-snow2-sd.png"
    movementVelocity: Qt.point(-80,0)
  }

  MenuText {
    y: 40
    text: "Game Over"
    font.pixelSize: 35
  }

  MenuText {
    id: scoreText
    y: 300
    text: "Your score: " + lastScore
  }

  MenuText {
    id: newMaximumHighscore
    text: "New highscore!!!"
    font.pixelSize: 14
    // font.bold: true
    color: "#8f2727"
    visible: true
    anchors.top: scoreText.bottom
    anchors.topMargin: 10
    //visible: false gets set in enterScene
  }

  MenuButton {
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 30
    text: "Continue"
    onClicked: window.state = "main"
  }

  function enterScene() {

    if(lastScore > maximumHighscore) {
      maximumHighscore = lastScore;
      newMaximumHighscore.visible = true;
    } else
      newMaximumHighscore.visible = false;

    // Check achievements
    var grains = player.bonusScore;
    var deaths = player.deaths;

    console.log("Collected grains:", grains);

    console.log("Player's death count:", deaths);
  }

}
