import QtQuick 2.8
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0
import "../utils.js" as Utils

FocusScope {
  id: root
  property bool showBack: true
  property bool showCollControls: true
  property var gameData: softwareList[sortByIndex].currentGame(currentScreenID)
  property string collectionShortName: {
    if (currentCollection == -1)
      Utils.processPlatformName(currentGame.collections.get(0).shortName)
    else
      Utils.processPlatformName(api.collections.get(currentCollection).shortName)
  }

  function processButtonArt(buttonModel) {
    var i;
    for (i = 0; buttonModel.length; i++) {
      if (buttonModel[i].name().includes("Gamepad")) {
        var buttonValue = buttonModel[i].key.toString(16)
        return buttonValue.substring(buttonValue.length-1, buttonValue.length);
      }
    }
  }

  Item {
    id: background

    width: parent.width
    height: parent.height

    Behavior on opacity { NumberAnimation { duration: 200 }}

    Image {
      id: controllerIcon
      width: vpx(80)
      height: vpx(70)
      horizontalAlignment: Image.AlignLeft
      fillMode: Image.PreserveAspectFit
      source: "../assets/images/controllers/" + collectionShortName + ".svg"
      visible: false

      anchors {
        verticalCenter: parent.verticalCenter
        left: parent.left
        leftMargin: vpx(25)
      }
    }

    ColorOverlay {
      anchors.fill: controllerIcon
      source: controllerIcon
      color: theme.text
      smooth: true
      cached: true
    }

    RowLayout {
      anchors {
        verticalCenter: parent.verticalCenter
        right: parent.right
        rightMargin: vpx(25)
      }
      spacing: vpx(15)
      layoutDirection: Qt.RightToLeft

      ControllerHelpButton {
        id: buttonOK
        button: processButtonArt(api.keys.accept)
        label: 'OK'
        Layout.fillWidth: true
        Layout.minimumWidth: vpx(65)

        //onClicked: {console.log("OK Clicked!")}

      }

      ControllerHelpButton {
        id: buttonBack
        button: processButtonArt(api.keys.cancel)
        label: 'Back'
        Layout.fillWidth: true
        Layout.minimumWidth: vpx(75)

        onClicked: { showHomeScreen(); }

        visible: showBack
      }

      ControllerHelpButton {
        id: buttonNext
        button: processButtonArt(api.keys.nextPage)
        label: 'Next Collection'
        Layout.fillWidth: true
        Layout.minimumWidth: vpx(185)

        onClicked: {
          turnOnSfx.play();
          if (currentCollection < api.collections.count-1) {
              nextCollection++;
          } else {
              nextCollection = -1;
          }
        }

        visible: showCollControls
      }

      //Previous Collection Button
      ControllerHelpButton {
        id: buttonPrev
        button: processButtonArt(api.keys.prevPage)
        label: 'Prev Collection'
        Layout.fillWidth: true
        Layout.minimumWidth: vpx(170)

        onClicked: {
          turnOffSfx.play();
          if (currentCollection == -1) {
            nextCollection = api.collections.count-1;
          } else{ 
            nextCollection--;
          }
        }

        visible: showCollControls
      }

    }

    // Image{
    //   id: profileIcon
    //   anchors
    //   {
    //       top: parent.top;
    //       left: parent.left;
    //   }
    //   width: Math.round(screenheight * 0.0833)
    //   height: width
    //   source: "../assets/images/logos/Nintendo - Switch.png"
    //   sourceSize { width: 128; height:128 }
    //   smooth: true
    //   antialiasing: true
    //   layer.enabled: enableDropShadows
    //   layer.effect: DropShadow {
    //       transparentBorder: true
    //       horizontalOffset: 0
    //       verticalOffset: 0
    //       color: "#1F000000"
    //       radius: 3.0
    //       samples: 6
    //       z: -2
    //   }
    // }

    

  }//background
}//root
