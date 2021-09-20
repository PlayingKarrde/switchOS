import QtQuick 2.15
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0

FocusScope {
  id: root
  property string label: "Default"
  property string button: "1"
  signal clicked

  Rectangle {
    id: helpButton

    width: buttonTxt.contentWidth + vpx(50)
    height: Math.round(screenheight*0.0611)
    color: theme.main

    anchors {
        //top: parent.top;
        right: parent.right;
        verticalCenter: parent.verticalCenter
    }

    Image {
        id: buttonImg
        width: Math.round(screenheight*0.04)
        height: width
        source: "../assets/images/controller/"+ button + ".png"
        sourceSize.width: 64
        sourceSize.height: 64
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left; leftMargin: vpx(10)
        }
    }

    ColorOverlay {
        anchors.fill: buttonImg
        source: buttonImg
        color: theme.text
        cached: true
    }

    Text {
        id: buttonTxt
        text: label

        anchors {
            left: buttonImg.right
            leftMargin: vpx(3); rightMargin: vpx(17)
            verticalCenter: buttonImg.verticalCenter
        }

        color: theme.text
        font.family: titleFont.name
        font.pixelSize: Math.round(screenheight*0.025)
        font.bold: true
        horizontalAlignment: Text.Right
    }

  }

  SequentialAnimation {
    id: colorAmin
    ColorAnimation { target: helpButton; property: "color"; from: helpButton.color; to: theme.press; duration: 100; easing.type: Easing.OutQuad }
    ColorAnimation { target: helpButton; property: "color"; from: theme.press; to: helpButton.color; duration: 100; easing.type: Easing.InQuad }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: helpButton
    hoverEnabled: true
    onClicked: {
      root.clicked();
      colorAmin.running = true
    }
  }

}
