import QtQuick 2.8
import QtGraphicalEffects 1.12
import "../global"
import "../Lists"
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
    
    NumberAnimation { id: anim; property: "scale"; to: 0.7; duration: 100 }

    //Keys.onLeftPressed: {  decrementCurrentIndex(); navSound.play(); }
    //Keys.onRightPressed: {  incrementCurrentIndex(); navSound.play();  }

    model: gamesListModel
    delegate: platformBarDelegate

    Component {
        id: platformBarDelegate
        Rectangle {
            id: wrapper

            property bool selected: ListView.isCurrentItem
            property var gameData: searchtext ? modelData : listRecent.currentGame(idx)
            property bool isGame: idx >= 0

            onGameDataChanged: { if (selected) updateData() }
            onSelectedChanged: { if (selected) updateData() }

            function updateData() {
                currentGame = gameData;
                currentScreenID = idx;
            }

            width: idx > -3 ? platformLayout.height : platformLayout.height*0.7//vpx(256)
            height: width//vpx(256)
            radius: idx > -3 ? 0 : width
            
            color: theme.button//"#cccccc"
            
            anchors.verticalCenter: parent.verticalCenter
            

            Image {
                id: logo

                anchors.fill: parent
                anchors.centerIn: parent
                anchors.margins: idx > -3 ? vpx(30) : vpx(65)
                property var logoImage: {
                    if (gameData != null) {
                        if (gameData.collections.get(0).shortName === "retropie")
                            return gameData.assets.boxFront;
                        else if (gameData.collections.get(0).shortName === "steam")
                            return gameData.assets.logo ? gameData.assets.logo : "" //root.logo(gameData);
                        else
                            return gameData.assets.logo;
                    } else {
                        return ""
                    }

                }
                /*gameData ? 
                    (gameData.collections.get(0).shortName === "retropie") ? 
                        gameData.assets.boxFront : 
                    (gameData.collections.get(0).shortName === "steam") ? 
                        logo(gameData) : 
                    gameData.assets.logo : 
                ""*/

                source: gameData ? Utils.logo(gameData) || "" : icon //gameData ? logoImage || "" : "../assets/images/allsoft_icon.svg"
                sourceSize: Qt.size(parent.width, parent.height)
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: true
                z: 10
                visible: idx > -3 ? true : false

                /*width: parent.width - vpx(30)
                height: vpx(75)
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "../assets/images/logos/" + Utils.processPlatformName(modelData.shortName) + ".png"
                asynchronous: true
                anchors.centerIn: parent
                antialiasing: true
                sourceSize { width: 128; height: 128 }
                visible: eslogo.paintedWidth < 1*/
            }

            ColorOverlay {
                anchors.fill: logo
                source: logo
                color: theme.allsoft
                antialiasing: true
                cached: true
            }

            Text
            {
                text: idx > -1 ? gameData.title : name
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
                fillMode: Image.PreserveAspectCrop
                source: gameData ? gameData.assets.screenshots[0] || "" : ""
                asynchronous: true
                sourceSize { width: 512; height: 512 }
            }

            Rectangle {
                width: parent.width
                height: parent.height
                color: "white"
                opacity: 0.15
                visible: eslogo.source != ""
            }


            MouseArea {
                anchors.fill: wrapper
                hoverEnabled: true
                onEntered: {}
                onExited: {}
                onClicked: {
                    if (selected)
                    {
                        if (currentIndex == 12) {
                            gotoSoftware();
                        } else {
                            anim.start();
                            playGame();//launchGame(currentGame);
                        }
                    }
                    else
                        platformLayout.currentIndex = index
                }
            }

            Text {
                id: platformTitle
                text: idx > -1 ? gameData.title : name
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

    // TODO if autorepeat play a multipleNavSound if I can find one
    Keys.onLeftPressed: {
        navSound.play();
        decrementCurrentIndex();
    }
    Keys.onRightPressed: {
        navSound.play();
        incrementCurrentIndex();
    }

    function gotoSoftware()
    {
            jumpToCollection(currentCollection);
            showSoftwareScreen();
    }


    //Software screen is always at index 12, but would hopefully not exist/be visible if there are less than 12 titles
    Keys.onPressed: {
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (currentIndex == 12) {
                gotoSoftware();
            } else {
                anim.start();
                playGame();//launchGame(currentGame);
            }
        }
    }
}

