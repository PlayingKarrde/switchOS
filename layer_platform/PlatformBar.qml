import QtQuick 2.8
import "../global"
import "../utils.js" as Utils
import "qrc:/qmlutils" as PegasusUtils


ListView {
    id: platformLayout
    //anchors.fill: parent
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
    keyNavigationWraps: true

    onCurrentIndexChanged: {
      //navSound.play()
      return;
    }

    Keys.onLeftPressed: {  decrementCurrentIndex(); navSound.play(); }
    Keys.onRightPressed: {  incrementCurrentIndex(); navSound.play();  }

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

    model: allCollections
    delegate: platformBarDelegate

    Component {
        id: platformBarDelegate
        Rectangle {
            id: wrapper
            property bool selected: ListView.isCurrentItem

            width: platformLayout.height//vpx(256)
            height: width//vpx(256)
            color: eslogo.source ? "#cccccc" : Utils.getPlatformColor(modelData.shortName)

            Image {
                id: logo

                width: parent.width - vpx(30)
                height: vpx(75)
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "../assets/images/logos/" + Utils.processPlatformName(modelData.shortName) + ".png"
                asynchronous: true
                anchors.centerIn: parent
                antialiasing: true
                sourceSize { width: 128; height: 128 }
                visible: eslogo.paintedWidth < 1
            }

            Text
            {
                text: modelData.name
                width: parent.width
                horizontalAlignment : Text.AlignHCenter
                font.family: titleFont.name
                color: theme.text
                font.pixelSize: Math.round(screenheight*0.025)
                font.bold: true

                anchors.centerIn: parent
                wrapMode: Text.Wrap
                visible: logo.paintedWidth < 1
                z: 10
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
                text: modelData.name
                color: theme.accent
                font.family: titleFont.name
                font.pixelSize: Math.round(screenheight*0.03)
                elide: Text.ElideRight

                anchors {
                    horizontalCenter: eslogo.horizontalCenter
                    bottom: eslogo.top; bottomMargin: Math.round(screenheight*0.02)
                }

                opacity: wrapper.ListView.isCurrentItem ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 75 } }
            }

            HighlightBorder
            {
                id: highlightBorder
                width: parent.width + vpx(18)//vpx(274)
                height: width//vpx(274)

                x: vpx(-9)
                y: vpx(-9)
                z: -1

                selected: wrapper.ListView.isCurrentItem
            }

        }
    }


}

