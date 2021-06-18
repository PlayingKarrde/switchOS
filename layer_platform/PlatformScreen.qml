import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.11
import "../utils.js" as Utils
import "qrc:/qmlutils" as PegasusUtils
//import QtQml 2.0

FocusScope
{
    id: root

    // Build the games list but with extra menu options at the start and end
    ListModel {
    id: gamesListModel

        property var activeCollection: listRecent.games

        Component.onCompleted: {
            clear();
            buildList();
        }

        onActiveCollectionChanged: {
            clear();
            buildList();
        }

        function buildList() {
            /*append({
                "name":         "Explore", 
                "idx":          -1, 
                "icon":         "assets/images/navigation/Explore.png",
                "background":   ""
            })*/
            for(var i=0; i<activeCollection.count; i++) {
                append(createListElement(i));
            }/*
            append({
                "name":         "Top Games", 
                "idx":          -2,
                "icon":         "assets/images/navigation/Top Rated.png",
                "background":   ""
            })//*/
            append({
                "name":         "All Software", 
                "idx":          -3,
                "icon":         "../assets/images/allsoft_icon.svg",
                "background":   ""
            })
        }

        function createListElement(i) {
            return {
                name:       listRecent.games.get(i).title,
                idx:        i,
                icon:       listRecent.games.get(i).assets.logo,
                background: listRecent.games.get(i).assets.screenshots[0]
            }
        }
    }

    Item
    {
        id: platformScreenContainer
        width: parent.width
        height: parent.height
        

        /*onVisibleChanged: {
            platformSwitcher.focus = true;
        }*/

        Item {
        id: topbar

            
            height: Math.round(screenheight * 0.2569)
            anchors {
                left: parent.left; leftMargin: vpx(60)
                right: parent.right; rightMargin: vpx(60)
                top: parent.top; topMargin: Math.round(screenheight * 0.0472)
            }

            // Top bar
            Image
            {
                id: profileIcon
                anchors
                {
                    top: parent.top;
                    left: parent.left;
                }
                width: Math.round(screenheight * 0.0833)
                height: width
                source: "../assets/images/profile_icon.png"
                sourceSize { width: 128; height:128 }
                smooth: true
                antialiasing: true
            }

            DropShadow {
                id: profileIconShadow
                anchors.fill: profileIcon
                horizontalOffset: 0
                verticalOffset: 0
                radius: 6.0
                samples: 6
                color: "#1F000000"
                source: profileIcon
            }

            Text
                {
                    id: collectionHomeTitle
                    text: currentCollection == -1 ? "" : api.collections.get(currentCollection).name
                    color: theme.text
                    font.family: titleFont.name
                    font.pixelSize: Math.round(screenheight*0.0277)
                    font.bold: true
                    anchors {
                        verticalCenter: profileIcon.verticalCenter
                        left: profileIcon.right; leftMargin: vpx(12)
                    }
                }

            Text
            {
                id: sysTime

                function set() {
                    sysTime.text = Qt.formatTime(new Date(), "h:mmap")
                }

                Timer {
                    id: textTimer
                    interval: 60000 // Run the timer every minute
                    repeat: true
                    running: true
                    triggeredOnStart: true
                    onTriggered: sysTime.set()
                }

                anchors {
                    verticalCenter: profileIcon.verticalCenter;
                    right: parent.right
                }
                color: theme.text
                font.family: titleFont.name
                font.weight: Font.Bold
                font.letterSpacing: 4
                font.pixelSize: Math.round(screenheight*0.0277)
                horizontalAlignment: Text.Right
                font.capitalization: Font.SmallCaps
            }
        }


        // Platform menu
        PlatformBar
        {
            id: platformSwitcher
            anchors 
            {
                left: parent.left; leftMargin: vpx(98)
                right: parent.right
                top: topbar.bottom;
            }
            height: Math.round(screenheight * 0.3555)
            focus: true
            
        }

        // Button menu
        /*RowLayout {
            id: buttonMenu
            spacing: vpx(22)

            anchors { 
                top: platformSwitcher.bottom;
                bottom: parent.bottom
            }
            
            x: parent.width/2 - buttonMenu.width/2

            MenuButton {
                id: themeButton
                width: vpx(86); height: vpx(86)

                onClicked: { 
                    focus = true;
                    platformSwitcher.focus = false;
                }
            }

            MenuButton {
                id: systemButton
                width: vpx(86); height: vpx(86)

                onClicked: { 
                    focus = true;
                    platformSwitcher.focus = false;
                }
            }
        }//*/
    }    
}
