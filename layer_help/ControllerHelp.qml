import QtQuick 2.8
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0

FocusScope {
  id: root
  property bool showBack: true
  property bool showCollControls: true

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

    Behavior on opacity { NumberAnimation { duration: 200 } }

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
        Layout.minimumWidth: vpx(60)

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
        Layout.minimumWidth: vpx(175)

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
        Layout.minimumWidth: vpx(160)

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

    

  }//background
}//root
