import QtQuick 2.12
import QtGraphicalEffects 1.12
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

        property var batteryStatus: isNaN(api.device.batteryPercent) ? "" : parseInt(api.device.batteryPercent*100);

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

            // DropShadow {
            //     id: profileIconShadow
            //     anchors.fill: profileIcon
            //     horizontalOffset: 0
            //     verticalOffset: 2
            //     radius: 6.0
            //     samples: 6
            //     color: "#1F000000"
            //     source: profileIcon
            // }

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
            
            RowLayout {
                spacing: vpx(15)
                anchors {
                        verticalCenter: profileIcon.verticalCenter;
                        right: parent.right; rightMargin: vpx(15)
                    }
                Text
                {
                    id: sysTime

                    //12HR-"h:mmap" 24HR-"hh:mm"
                    property var timeSetting: (settings.timeFormat === "12hr") ? "h:mmap" : "hh:mm";

                    function set() {
                        sysTime.text = Qt.formatTime(new Date(), timeSetting) 
                    }

                    Timer {
                        id: textTimer
                        interval: 60000 // Run the timer every minute
                        repeat: true
                        running: true
                        triggeredOnStart: true
                        onTriggered: sysTime.set()
                    }

                    onTimeSettingChanged: sysTime.set()

                    // anchors {
                    //     verticalCenter: profileIcon.verticalCenter;
                    //     right: parent.right; rightMargin: vpx(15)
                    // }
                    color: theme.text
                    font.family: titleFont.name
                    font.weight: Font.Bold
                    font.letterSpacing: 4
                    font.pixelSize: Math.round(screenheight*0.0277)
                    horizontalAlignment: Text.Right
                    font.capitalization: Font.SmallCaps
                }
                Row{
                    spacing: vpx(5)

                    Text {
                        id: batteryPercentage

                        function set() {
                            batteryPercentage.text = platformScreenContainer.batteryStatus+"%";
                        }

                        Timer {
                            id: percentTimer
                            interval: 60000 // Run the timer every minute
                            repeat: isNaN(api.device.batteryPercent) ? "" : showPercent
                            running: isNaN(api.device.batteryPercent) ? "" : showPercent
                            triggeredOnStart: isNaN(api.device.batteryPercent) ? "" : showPercent
                            onTriggered: batteryPercentage.set()
                        }

                        // anchors {
                        //     verticalCenter: profileIcon.verticalCenter;
                        //     //left: sysTime.right;
                        //     right: parent.right; rightMargin: vpx(5)
                        // }

                        color: theme.text
                        font.family: titleFont.name
                        font.weight: Font.Bold
                        font.letterSpacing: 1
                        font.pixelSize: Math.round(screenheight*0.0277)
                        horizontalAlignment: Text.Right
                        Component.onCompleted: font.capitalization = Font.SmallCaps
                        //font.capitalization: Font.SmallCaps
                        visible: isNaN(api.device.batteryPercent) ? "" : showPercent
                    }

                    BatteryIcon{
                        id: batteryIcon
                        width: height * 2
                        height: sysTime.paintedHeight
                        layer.enabled: true
                        layer.effect: ColorOverlay {
                            color: theme.text
                            antialiasing: true
                            cached: true
                        }

                        function set() {
                            batteryIcon.level = platformScreenContainer.batteryStatus;
                        }

                        Timer {
                            id: iconTimer
                            interval: 60000 // Run the timer every minute
                            repeat: true
                            running: true
                            triggeredOnStart: true
                            onTriggered: batteryIcon.set()
                        }

                        // anchors {
                        //     verticalCenter: profileIcon.verticalCenter;
                        //     right: parent.right;
                        // }

                        visible: isNaN(api.device.batteryPercent) ? false : true
                    }
                }
                // ColorOverlay {
                //     Layout.alignment: batteryIcon
                //     source: batteryIcon
                //     color: theme.text
                //     antialiasing: true
                //     cached: true
                //     visible: true
                // }
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
        RowLayout {
            id: buttonMenu
            spacing: vpx(22)

            anchors {
                top: platformSwitcher.bottom;
                bottom: parent.bottom
            }

            Keys.onUpPressed: {
                navSound.play();
                platformSwitcher.focus = true
                platformSwitcher.currentIndex = platformSwitcher._index
            }

            Keys.onDownPressed:{
                borderSfx.play();
            }

            x: parent.width/2 - buttonMenu.width/2

            MenuButton {
                id: themeButton
                width: vpx(86); height: vpx(86)
                label: "Toggle Theme"
                icon: "../assets/images/navigation/theme.svg"

                Keys.onPressed: {
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        selectSfx.play();
                        toggleDarkMode();
                    }
                }

                Keys.onLeftPressed:{
                    borderSfx.play();
                }

                Keys.onRightPressed:{
                    navSound.play();
                    settingsButton.focus = true
                }

                onClicked: {
                    if (themeButton.focus)
                    {
                        selectSfx.play();
                        toggleDarkMode();
                    }
                    else
                        themeButton.focus = true;
                        navSound.play();
                        platformSwitcher.currentIndex = -1;
                }
            }

            MenuButton {
                id: settingsButton
                width: vpx(86); height: vpx(86)
                label: "Theme Settings"
                icon: "../assets/images/navigation/Settings.png"

                //Disabled until settings screen is built/implemented
                Keys.onPressed: {
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        showSettingsScreen();
                    }
                }

                Keys.onLeftPressed:{
                    navSound.play();
                    themeButton.focus = true
                }

                Keys.onRightPressed:{
                    borderSfx.play();
                }
                onClicked: {
                    if (settingsButton.focus)
                    {
                        showSettingsScreen();
                    }
                    else
                        settingsButton.focus = true;
                        navSound.play();
                        platformSwitcher.currentIndex = -1;
                }
                visible: true
            }
        }
    }
}
