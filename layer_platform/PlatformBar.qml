import QtQuick 2.15
import QtGraphicalEffects 1.12
import "../global"
import "../Lists"
import "../utils.js" as Utils
import "qrc:/qmlutils" as PegasusUtils


ListView {
    id: platformLayout
    //anchors.fill: parent
    property int _index: 0
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

            width: platformLayout.height//isGame ? platformLayout.height : platformLayout.height*0.7
            height: width
            color: "transparent"

            anchors.verticalCenter: parent.verticalCenter

            Rectangle{
                id: background
                width: isGame ? platformLayout.height : platformLayout.height*0.7
                height: width
                radius: isGame ? 0 : width
                opacity: 1
                color: theme.button
                layer.enabled: false//enableDropShadows && !selected && idx > -3 //disabled on All Software button to avoid graphical glitch
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 2
                    color: "#1F000000"
                    radius: 6.0
                    samples: 6
                    z: -2
                }
                
                anchors.centerIn: parent
                
            }

            //preference order for Game Backgrounds, tiles always come first due to assumption that it's set manually
            property var gameBG: {
                switch (settings.gameBackground) {
                    case "Screenshot":
                        return gameData ? gameData.assets.tile || gameData.assets.screenshots[0] || gameData.assets.background || gameData.assets.boxFront || "" : "";
                    case "Fanart":
                        return gameData ? gameData.assets.tile || gameData.assets.background || gameData.assets.screenshots[0] || gameData.assets.boxFront || "" : "";
                    default:
                        return ""
                }
            }

            Image {
                id: gameImage
                width: isGame ? platformLayout.height : platformLayout.height*0.7//.width
                height: width
                smooth: true
                fillMode: (gameBG == gameData.assets.boxFront) ? Image.PreserveAspectFit : Image.PreserveAspectCrop
                source: gameData.collections.get(0).shortName === "steam" ? gameData.assets.screenshot : gameBG
                asynchronous: true
                sourceSize { width: 512; height: 512 }
                
                anchors.centerIn: parent
                
            }

            //white overlay on screenshot for better logo visibility over screenshot
            Rectangle {
                width: gameImage.width
                height: gameImage.height
                color: "white"
                opacity: 0.15
                visible: logo.source != "" && gameImage.source != ""
            }

            Image {
                id: logo

                anchors.fill: gameImage
                anchors.centerIn: gameImage
                anchors.margins: isGame ? vpx(30) : vpx(60)
                property var logoImage: {
                    if (gameData != null) {
                        if (gameData.collections.get(0).shortName === "retropie")
                            return "";//gameData.assets.boxFront;
                        else if (gameData.collections.get(0).shortName === "steam")
                            return Utils.logo(gameData) ? Utils.logo(gameData) : "" //root.logo(gameData);
                        else if (gameData.assets.tile != "")
                            return "";
                        else
                            return gameData.assets.logo;
                    } else {
                        return ""
                    }
                }

                source: gameData ? logoImage : icon //Utils.logo(gameData)
                sourceSize: Qt.size(gameImage.width, gameImage.height)
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: true
                z: 10
                visible: isGame && !(gameBG == gameData.assets.boxFront) ? true : false
            }

            ColorOverlay {
                anchors.fill: logo
                source: logo
                color: theme.icon
                antialiasing: true
                cached: true
            }


            Text
            {
                text: idx > -1 ? gameData.title : name
                width: gameImage.width
                horizontalAlignment : Text.AlignHCenter
                font.family: titleFont.name
                color: theme.text
                font.pixelSize: Math.round(screenheight*0.025)
                font.bold: true

                anchors.centerIn: gameImage
                wrapMode: Text.Wrap
                visible: logo.source == "" && gameImage.source == ""
                z: 10
            }

            MouseArea {
                anchors.fill: gameImage
                hoverEnabled: true
                onEntered: {}
                onExited: {}
                onClicked: {
                    if (selected)
                    {
                        if (currentIndex == softCount) {
                            gotoSoftware();
                        } else {
                            anim.start();
                            playGame();//launchGame(currentGame);
                        }
                    }
                    else
                        navSound.play();
                        platformSwitcher.currentIndex = index
                        platformSwitcher.focus = true
                        buttonMenu.focus = false

                }
            }

            Text {
                id: topTitle
                text: idx > -1 ? gameData.title : name
                color: theme.accent
                font.family: titleFont.name
                font.pixelSize: Math.round(screenheight*0.035)
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                //clip: true
                //elide: Text.ElideRight

                anchors {
                    horizontalCenter: gameImage.horizontalCenter
                    bottom: gameImage.top; bottomMargin: Math.round(screenheight*0.025)
                }

                opacity: wrapper.ListView.isCurrentItem ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 75 } }
            }

            Component.onCompleted: {
                if (wordWrap) {
                    if (topTitle.paintedWidth > gameImage.width * 1.70) {
                        topTitle.width = gameImage.width * 1.5
                    }
                }
            }

            HighlightBorder
            {
                id: highlightBorder
                width: gameImage.width + vpx(18)//vpx(274)
                height: width//vpx(274)
                
                anchors.centerIn: parent
                

                x: vpx(-9)
                y: vpx(-9)
                z: -1

                selected: wrapper.ListView.isCurrentItem
            }

        }
    }

    Keys.onLeftPressed: {
        navSound.play();
        decrementCurrentIndex();
    }
    Keys.onRightPressed: {
        navSound.play();
        incrementCurrentIndex();
    }

    Keys.onUpPressed:{
        borderSfx.play();
    }

    Keys.onDownPressed: {
        _index = currentIndex;
        navSound.play();
        themeButton.focus = true
        platformSwitcher.currentIndex = -1
    }

    function gotoSoftware()
    {
            jumpToCollection(currentCollection);
            showSoftwareScreen();
    }


    //TODO Software screen is always at index 12, but would hopefully not exist/be visible if there are less than 12 titles
    Keys.onPressed: {
        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
            event.accepted = true;
            if (currentIndex == softCount) {
                gotoSoftware();
            } else {
                anim.start();
                playGame();//launchGame(currentGame);
            }
        }
    }
}

