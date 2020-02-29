import QtQuick 2.8
import QtGraphicalEffects 1.0
import "../global"
import "../utils.js" as Utils
import "qrc:/qmlutils" as PegasusUtils

FocusScope
{

    Item
    {
        id: softwareScreenContainer
        anchors.fill: parent
        anchors {
            left: parent.left; leftMargin: screenmargin
            right: parent.right; rightMargin: screenmargin
        }

        Keys.onPressed: {
            if (event.isAutoRepeat)
                return;

            if (api.keys.isDetails(event)) {
                event.accepted = true;
                return;
            }
            if (api.keys.isCancel(event)) {
                event.accepted = true;
                showHomeScreen();
                return;
            }
            if (api.keys.isFilters(event)) {
                event.accepted = true;
                return;
            }
        }

        // Top bar
        Item
        {
            id: topBar
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            height: vpx(88)
            z: 5

            Image
            {
                id: headerIcon
                width: vpx(44)
                height: vpx(44)
                source: "../assets/images/allsoft_icon.svg"
                sourceSize.width: vpx(128)
                sourceSize.height: vpx(128)

                anchors {
                    top: parent.top; topMargin: vpx(30)
                    left: parent.left; leftMargin: vpx(38)
                }

                Text
                {
                    id: collectionTitle
                    text: api.collections.get(collectionIndex).name
                    color: theme.text
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.family: titleFont.name
                    font.pixelSize: vpx(22)
                    font.bold: true
                    anchors {
                        left: parent.right; leftMargin: vpx(12)
                    }
                }
            }

            ColorOverlay {
                anchors.fill: headerIcon
                source: headerIcon
                color: theme.text
                cached: true
            }

            MouseArea {
                anchors.fill: headerIcon
                hoverEnabled: true
                onEntered: {}
                onExited: {}
                onClicked: showHomeScreen();
            }

            // Line
            Rectangle {
                y: parent.height - vpx(1)
                anchors.left: parent.left; anchors.right: parent.right
                height: vpx(1)
                color: theme.secondary
            }
            

        }

        // Grid masks (better performance than using clip: true)
        Rectangle
        {
            anchors {
                left: parent.left; top: parent.top; right: parent.right
            }
            color: theme.main
            height: topBar.height
            z: 4
        }
        
        // Game grid
        GridView 
        {
            id: gameGrid
            focus: true

            Keys.onPressed: {
                if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                    event.accepted = true;
                    //currentItem.currentGame.launch();
                    launchGame();
                }
            }

            onCurrentIndexChanged: {
                navSound.play();
                currentGameIndex = currentIndex;
                return;
            }
            
            anchors.left: parent.left; leftMargin: vpx(63)
            anchors.top: topBar.bottom; topMargin: vpx(99)
            anchors.right: parent.right;
            anchors.bottom: parent.bottom

            cellWidth: vpx(184)
            cellHeight: vpx(184)
            preferredHighlightBegin: vpx(99)
            preferredHighlightEnd: vpx(470)
            highlightRangeMode: ListView.StrictlyEnforceRange // Highlight never moves outside the range
            snapMode: ListView.SnapToItem
            highlightMoveDuration: 200
            //clip: true
            //cacheBuffer: 256

            
            model: api.collections.get(collectionIndex).games
            delegate: gameGridDelegate

            Component 
            {
                id: gameGridDelegate
                
                Item
                {
                    id: delegateContainer
                    property bool selected: delegateContainer.GridView.isCurrentItem
                    width: vpx(174)
                    height: vpx(174)
                    z: -5


                    Image {
                        id: screenshot
                        width: parent.width
                        height: parent.height
                        
                        asynchronous: true
                        //smooth: true
                        source: modelData.assets.screenshots[0] ? modelData.assets.screenshots[0] : ""
                        sourceSize { width: 256; height: 256 }
                        fillMode: Image.PreserveAspectCrop
                        
                    }//*/

                    Rectangle 
                    {
                        width: parent.width
                        height: parent.height
                        color: "black"
                        opacity: 0.5
                        visible: screenshot.source != ""
                    }

                    // Logo
                    Image {
                        id: gamelogo

                        width: screenshot.width
                        height: screenshot.height
                        anchors {
                            fill: parent
                            margins: vpx(6)
                        }

                        asynchronous: true

                        //opacity: 0
                        source: modelData.assets.logo ? modelData.assets.logo : ""
                        sourceSize { width: 256; height: 256 }
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        visible: modelData.assets.logo ? modelData.assets.logo : ""
                        z:8
                    }

                    /*DropShadow {
                        id: logoshadow
                        anchors.fill: gamelogo
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 4.0
                        samples: 6
                        color: "#80000000"
                        source: gamelogo
                    }*/

                    MouseArea {
                        anchors.fill: screenshot
                        hoverEnabled: true
                        onEntered: {}
                        onExited: {}
                        onClicked: {
                            if (selected)
                            {
                                anim.start();
                                playGame();
                            }
                            else
                                gameGrid.currentIndex = index
                        }
                    }

                    NumberAnimation { id: anim; property: "scale"; to: 0.7; duration: 100 }
                    //NumberAnimation { property: "scale"; to: 1.0; duration: 100 }
                    
                    Rectangle {
                        id: outerborder
                        width: screenshot.width
                        height: screenshot.height
                        color: "white"//Utils.getPlatformColor(api.collections.get(collectionIndex).shortName)
                        z: -1

                        Rectangle
                        {
                            anchors.fill: outerborder
                            anchors.margins: vpx(4)
                            color: theme.main
                            z: 7
                        }

                        Text
                        {
                            text: modelData.title
                            x: vpx(8)
                            width: parent.width - vpx(16)
                            height: parent.height
                            font.family: titleFont.name
                            color: theme.text//"white"
                            font.pixelSize: vpx(14)
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                            visible: !modelData.assets.logo
                            z: 10
                        }
                    }
                        

                    // Title bubble
                    Rectangle {
                        id: titleBubble
                        width: gameTitle.contentWidth + vpx(54)
                        height: vpx(44)
                        color: "white"
                        radius: vpx(4)
                        
                        // Need to figure out how to stop it from clipping the margin
                        // mapFromItem and mapToItem are probably going to help
                        property int xpos: screenshot.width/2 - width/2
                        x: xpos
                        y: vpx(-63)
                        z: 10 * index
                        
                        opacity: selected ? 0.95 : 0
                        //Behavior on opacity { NumberAnimation { duration: 50 } }

                        Text {
                            id: gameTitle                        
                            text: modelData.title
                            color: theme.accent
                            font.pixelSize: vpx(18)
                            font.bold: true
                            font.family: titleFont.name
                            
                            anchors { 
                                top: parent.top; topMargin: vpx(8)
                                left: parent.left; leftMargin: vpx(27)
                            }
                            
                        }
                    }

                    Image {
                        id: bubbletriangle
                        source: "../assets/images/triangle.svg"
                        width: vpx(17)
                        height: vpx(11)
                        opacity: titleBubble.opacity
                        x: screenshot.width/2 - width/2
                        anchors.top: titleBubble.bottom
                    }

                    // Border
                    HighlightBorder
                    {
                        id: highlightBorder
                        width: vpx(188)
                        height: vpx(188)

                        x: vpx(-7)
                        y: vpx(-7)
                        z: -10

                        selected: delegateContainer.GridView.isCurrentItem
                    }

                }
            }
        }

    }
}
