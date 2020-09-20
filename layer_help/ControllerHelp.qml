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
      
    Behavior on opacity { NumberAnimation { duration: 200 } }
    
    Image {
      id: button1
      width: Math.round(screenheight*0.04)
      height: width
      source: "../assets/images/controller/"+ processButtonArt(api.keys.accept) + ".png"
      sourceSize.width: 64
      sourceSize.height: 64
      anchors {
        verticalCenter: button1Txt.verticalCenter
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
      height: txt1.height
      Text {
        id: txt1
        text: buttonText1
        color: theme.text
        font.pixelSize: Math.round(screenheight*0.025)
        font.family: titleFont.name
        font.bold: true
      }
      anchors {
        verticalCenter: parent.verticalCenter
        right: parent.right
        rightMargin: vpx(25)
      }
      
    }//buttonBack

    Image {
      id: button2
      width: Math.round(screenheight*0.04)
      height: width
      source: "../assets/images/controller/"+ processButtonArt(api.keys.cancel) + ".png"
      sourceSize.width: 64
      sourceSize.height: 64
      anchors {
        verticalCenter: button2Txt.verticalCenter
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
      height: txt2.height
      Text {
        id: txt2
        text: buttonText2
        color: theme.text
        font.pixelSize: Math.round(screenheight*0.025)
        font.family: titleFont.name
        font.bold: true
      }
      anchors {
        verticalCenter: parent.verticalCenter
        right: button1.left
        rightMargin: vpx(20)
      }
      visible: showBack
    }

  }//background
}//root
