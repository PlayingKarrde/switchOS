import QtQuick 2.8
import QtGraphicalEffects 1.0
import "qrc:/qmlutils" as PegasusUtils

Item {
    id: root

    property bool selected: focus
    property real borderWidth: vpx(10)
    property string label: "No label"
    signal clicked

    Rectangle {
        id: innerCircle
        width: vpx(86); height: vpx(86)
        z: 5
        radius:width/2
        color: theme.button
    }

    Rectangle {
        id: highlight
        width: innerCircle.width + borderWidth
        height: innerCircle.height + borderWidth
        radius:width/2
        color: theme.accent

        x: innerCircle.x - borderWidth/2
        y: innerCircle.y - borderWidth/2

        visible: selected
    }

    Rectangle {
        id: highlightAnim
        width: innerCircle.width + borderWidth
        height: innerCircle.height + borderWidth
        radius:width/2
        color: "white"

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
        width: vpx(512)
        x: vpx(-128)
        y: vpx(-46)
        text: label
        color: theme.accent
        font.family: titleFont.name
        font.pixelSize: vpx(22)
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter

        //opacity: wrapper.ListView.isCurrentItem ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 75 } }
    }

}
