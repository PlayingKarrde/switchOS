import QtQuick 2.8
import QtGraphicalEffects 1.12

Rectangle {
    property bool selected: false
    property int borderwidth: idx && idx == -3 ? vpx(7) : vpx(5)

    id: hlBorder
    width: parent.width
    height: parent.height
    color: theme.accent
    radius: idx && idx == -3 ? width : vpx(3)
    layer.enabled: enableDropShadows
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 2
        color: "#1F000000"
        radius: 6.0
        samples: 6
        z: -2
    }
    opacity: selected ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 75 } }

    // Highlight animation (ColorOverlay causes graphical glitches on W10)
    Rectangle {
        anchors.fill: parent
        color: "white"//"#c0f0f3"
        radius: hlBorder.radius
        SequentialAnimation on opacity {
            id: colorAnim
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 0.5; duration: 400; easing { type: Easing.OutQuad } }
            NumberAnimation { to: 0; duration: 500; easing { type: Easing.InQuad } }
            PauseAnimation { duration: 200 }
        }
    }
    
    // Inner highlight
    Rectangle {
        width: parent.width - (borderwidth*2)
        height: parent.height - (borderwidth*2)
        radius: idx && idx == -3 ? width : vpx(3)
        anchors.centerIn: parent
        
        color: idx && idx == -3 ? theme.button : theme.highlight
        opacity: 1
    }

}