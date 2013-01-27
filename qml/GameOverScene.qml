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

  MultiResolutionImage {
    id: multires
    x: scene.gameWindowAnchorItem.x
    y: scene.gameWindowAnchorItem.y
    contentWidth: scene.gameWindowAnchorItem.width/multires.contentScaleFactor
    contentHeight: scene.gameWindowAnchorItem.height/multires.contentScaleFactor

    source: "img/background-snow2-sd.png"
    anchors.centerIn: parent
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
//    if(gameCenter.authenticated) {
//      if (grains >= 10)
//        gameCenter.reportAchievement("grains10", 100, true);
//      if (grains >= 25)
//        gameCenter.reportAchievement("grains25", 100, true);
//      if (grains >= 50)
//        gameCenter.reportAchievement("grains50", 100, true);

//      if (deaths >= 10)
//        gameCenter.reportAchievement("chickendead1", 100, true);
//    }

    console.log("Player's death count:", deaths);
  }

}
