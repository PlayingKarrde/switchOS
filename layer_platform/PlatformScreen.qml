import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.11
import "../utils.js" as Utils
import "qrc:/qmlutils" as PegasusUtils
//import QtQml 2.0

FocusScope
{
    id: root

    Item
    {
        id: platformScreenContainer
        width: parent.width
        height: parent.height
        

        /*onVisibleChanged: {
            platformSwitcher.focus = true;
        }*/

        // Top bar
        Image
        {
            id: profileIcon
            anchors
            {
                top: parent.top; topMargin: vpx(34)
                left: parent.left; leftMargin: vpx(60)
            }
            width: vpx(60)
            height: vpx(60)
            source: "../assets/images/profile_icon.svg"
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
            id: sysTime

            function set() {
                sysTime.text = Qt.formatTime(new Date(), "hh:mm")
            }

            Timer {
                id: textTimer
                interval: 60000 // Run the timer every minute
                repeat: true
                running: true
                triggeredOnStart: true
                onTriggered: sysTime.set()
            }

            x: parent.width - contentWidth - vpx(55)
            y: vpx(55)
            color: theme.text
            font.pixelSize: vpx(20)
            horizontalAlignment: Text.Right
        }

        // Platform menu
        PlatformBar
        {
            id: platformSwitcher
            anchors 
            {
                left: parent.left; leftMargin: vpx(98)
                right: parent.right
                top: parent.top; topMargin: vpx(185)
            }
            height: vpx(256)
            focus: true
        }

        /*// Button menu
        RowLayout {
            id: buttonMenu
            spacing: vpx(22)
            width: vpx(194)
            height: vpx(86)

            anchors { 
                top: parent.top; topMargin: vpx(503) 
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
