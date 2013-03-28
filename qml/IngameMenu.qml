import QtQuick 1.1

Column {
  spacing: 2
  anchors.centerIn: parent


  MenuButton {
    text: "Resume"
    onClicked: scene.state = "" // reset to default state, so hide this menu
  }

  MenuButton {
    text: "Restart"
    onClicked: {
      level.restartGame();
      scene.state = "" // reset to default state, so hide this menu
    }
  }
//  MenuButton {
//    text: "Tweak"
//    visible: system.debugBuild
//    onClicked: {
//      itemEditor.visible = !itemEditor.visible
//    }
//  }
  MenuButton {
    text: "Toggle Sound"
    onClicked: {
      rootGameWindow.settings.soundEnabled = !rootGameWindow.settings.soundEnabled
    }
  }
  MenuButton {
    text: "Main Menu"
    onClicked: {
      scene.state = "" // reset to default state, so hide this menu
      window.state = "main"
    }
  }
}
