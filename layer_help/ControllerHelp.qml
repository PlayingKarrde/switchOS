import QtQuick 2.8
import QtGraphicalEffects 1.0

FocusScope {
  id: root
  property string buttonText1: showBack ? "Start" : "OK"
  property string controllerButton1: "A"
  property string buttonText2: "Back"
  property string controllerButton2: "B"

  property bool showBack: true

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

    //opacity: (stateMenu || stateVideoPreview) ? 0 : 1
    Behavior on opacity { NumberAnimation { duration: 200 } }

    Item {
        id: buttonContainer
        width: parent.width
        height: vpx(20)
        anchors {
          bottom: parent.bottom
          bottomMargin: vpx(18)
        }

        Image {
          id: button1
          height: vpx(24)
          width: height
          source: "../assets/images/controller/"+ processButtonArt(api.keys.accept) + ".png"
          sourceSize.width: vpx(32)
          sourceSize.height: vpx(32)
          anchors {
            right: button1Txt.left
            rightMargin: vpx(5)
          }
        }//button1

        ColorOverlay {
            anchors.fill: button1
            source: button1
            color: theme.text
            cached: true
        }

        Item {
          id: button1Txt
          width: txt1.width
          height: parent.height
          Text {
            id: txt1
            text: buttonText1
            color: theme.text
            font.pixelSize: vpx(18)
            font.family: titleFont.name
            font.bold: true
          }
          anchors {
            right: parent.right
            rightMargin: vpx(25)
          }
        }//buttonBack

        Image {
          id: button2
          height: vpx(24)
          width: height
          source: "../assets/images/controller/"+ processButtonArt(api.keys.cancel) + ".png"
          sourceSize.width: vpx(32)
          sourceSize.height: vpx(32)
          anchors {
            right: button2Txt.left
            rightMargin: vpx(5)
          }
          visible: showBack
        }//button2

        ColorOverlay {
            anchors.fill: button2
            source: button2
            color: theme.text
            cached: true
            visible: showBack
        }

        Item {
          id: button2Txt
          width: txt2.width
          height: parent.height
          Text {
            id: txt2
            text: buttonText2
            color: theme.text
            font.pixelSize: vpx(18)
            font.family: titleFont.name
            font.bold: true
          }
          anchors {
            right: button1.left
            rightMargin: vpx(20)
          }
          visible: showBack
        }
        
      }//buttonContainer
  }//background
}//root
