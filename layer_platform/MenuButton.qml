import QtQuick 2.8
import QtGraphicalEffects 1.12
import "qrc:/qmlutils" as PegasusUtils

Item {
    id: root

    property bool selected: focus
    property real borderWidth: vpx(10)
    property string label: "No label"
    property string icon: "../assets/images/allsoft_icon.svg"
    signal clicked

    Rectangle {
        id: innerCircle
        width: vpx(86); height: vpx(86)
        //z: 5
        radius:width/2
        color: theme.button
        layer.enabled: enableDropShadows
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            color: "#1F000000"
            radius: 6.0
            samples: 6
            z: -2
        }
    }

    Image {
        id: menuIcon
        anchors.fill: innerCircle
        anchors.centerIn: innerCircle
        anchors.margins: vpx(22)
        source: icon
        sourceSize: Qt.size(parent.width, parent.height)
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        smooth: true
        //z: 10
    }

    ColorOverlay {
        anchors.fill: menuIcon
        source: menuIcon
        color: theme.icon
        antialiasing: true
        smooth: true
        cached: true
    }

    Rectangle {
        id: highlight
        width: innerCircle.width + borderWidth
        height: innerCircle.height + borderWidth
        radius:width/2
        color: theme.accent
        layer.enabled: enableDropShadows
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            color: "#1F000000"
            radius: 6.0
            samples: 6
            z: -2
        }
        z: -1

        x: innerCircle.x - borderWidth/2
        y: innerCircle.y - borderWidth/2

        visible: selected
    }

    Rectangle {
        id: highlightAnim
        width: innerCircle.width + borderWidth
        height: innerCircle.height + borderWidth
        radius:width/2
        color: "#c0f0f3"
        z: -1

        x: innerCircle.x - borderWidth/2
        y: innerCircle.y - borderWidth/2

        SequentialAnimation on opacity {
            id: colorAnim
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 0.6; duration: 400; easing { type: Easing.OutQuad } }
            NumberAnimation { to: 0; duration: 500; easing { type: Easing.InQuad } }
            PauseAnimation { duration: 200 }
        }

        visible: highlight.visible
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
        hoverEnabled: true
    }

    Text {
        id: titleText
        text: label
        color: theme.accent
        font.family: titleFont.name
        font.pixelSize: Math.round(screenheight*0.0277)
        font.bold: false
        anchors {
            top: highlight.bottom; topMargin: vpx(8)
            horizontalCenter: parent.horizontalCenter
        }
        opacity: parent.focus ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 75 } }
    }

}
