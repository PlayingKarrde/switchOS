import QtQuick 2.8

Rectangle {
    property bool selected: false
    property int borderwidth: vpx(5)

    id: hlBorder
    width: parent.width
    height: parent.height
    color: theme.accent
    radius: vpx(3)

    opacity: selected ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 75 } }

    // Highlight animation (ColorOverlay causes graphical glitches on W10)
    Rectangle {
        anchors.fill: parent
        //color: "#9EF6FF"
        color: "white"
        radius: hlBorder.radius
        SequentialAnimation on opacity {
            id: colorAnim
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 0.6; duration: 400; easing { type: Easing.OutQuad } }
            NumberAnimation { to: 0; duration: 500; easing { type: Easing.InQuad } }
            PauseAnimation { duration: 200 }
        }
    }
    
    // Inner highlight
    Rectangle {
        width: parent.width - (borderwidth*2)
        height: parent.height - (borderwidth*2)
        
        anchors.centerIn: parent
        
        color: theme.highlight
    }

}