import QtQuick 2.8
import "../global"
import "../utils.js" as Utils
import "qrc:/qmlutils" as PegasusUtils


ListView {
    id: platformLayout
    anchors.fill: parent
    spacing: vpx(14)
    orientation: ListView.Horizontal
    
    displayMarginBeginning: vpx(107)
    displayMarginEnd: vpx(107)

    preferredHighlightBegin: vpx(0)
    preferredHighlightEnd: vpx(1077)
    highlightRangeMode: ListView.StrictlyEnforceRange // Highlight never moves outside the range
    snapMode: ListView.SnapToItem
    highlightMoveDuration: 200
    highlightMoveVelocity: -1

    onCurrentIndexChanged: {
      navSound.play()
      return;
    }

    function gotoSoftware()
    {
            jumpToCollection(currentIndex);
            showSoftwareScreen();
    }

    Keys.onPressed: {
         if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            gotoSoftware();
        }
        
    }

    model: api.collections
    delegate: platformBarDelegate

    Component {
        id: platformBarDelegate
        Rectangle {
            id: wrapper
            property bool selected: ListView.isCurrentItem

            width: vpx(256)
            height: vpx(256)
            color: eslogo.source ? "#cccccc" : Utils.getPlatformColor(modelData.shortName)

            Image {
                id: logo

                width: parent.width - vpx(30)
                height: vpx(75)
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "../assets/images/logos/" + Utils.processPlatformName(modelData.shortName) + ".png"
                asynchronous: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: vpx(80)
                antialiasing: true
                sourceSize { width: 512; height: 512 }
                visible: !eslogo.source
            }

            Image {
                id: eslogo
                width: parent.width
                height: width
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "../assets/images/logos-es/" + Utils.processPlatformName(modelData.shortName) + ".jpg"
                asynchronous: true
                sourceSize { width: 512; height: 512 }
            }

            MouseArea {
                anchors.fill: wrapper
                hoverEnabled: true
                onEntered: {}
                onExited: {}
                onClicked: {
                    if (selected)
                    {
                        gotoSoftware();
                    }
                    else
                        platformLayout.currentIndex = index
                }
            }

            Text {
                id: platformTitle
                width: vpx(512)
                x: vpx(-128)
                y: vpx(-46)
                text: modelData.name
                color: theme.accent
                font.family: titleFont.name
                font.pixelSize: vpx(22)
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter

                opacity: wrapper.ListView.isCurrentItem ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 75 } }
            }

            HighlightBorder
            {
                id: highlightBorder
                width: vpx(274)
                height: vpx(274)

                x: vpx(-9)
                y: vpx(-9)
                z: -1

                selected: wrapper.ListView.isCurrentItem
            }

        }
    }

    
}

