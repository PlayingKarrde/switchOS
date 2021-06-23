// skylineOS

import QtQuick 2.12
import QtQuick.Layouts 1.11
import SortFilterProxyModel 0.2
import QtMultimedia 5.9
import QtGraphicalEffects 1.12
import "qrc:/qmlutils" as PegasusUtils
import "utils.js" as Utils
import "layer_platform"
import "layer_grid"
import "layer_help"
import "Lists"

FocusScope
{
    id: root
    ListLastPlayed  { id: listRecent; max: 12}
    ListLastPlayed  { id: listByLastPlayed}
    ListMostPlayed  { id: listByMostPlayed}
    ListAllGames    { id: listByTitle}

    property int currentCollection: api.memory.has('Last Collection') ? api.memory.get('Last Collection') : -1
    property int nextCollection: api.memory.has('Last Collection') ? api.memory.get('Last Collection') : -1
    property var currentGame
    property var softwareList: [listByLastPlayed, listByTitle, listByMostPlayed]
    property int sortByIndex: 0
    property string searchtext

    onNextCollectionChanged: { changeCollection() }

    function changeCollection() {
        if (nextCollection != currentCollection) {
            currentCollection = nextCollection;
            searchtext = ""
            //gameGrid.currentIndex = 0;
        }
    }

    property int collectionIndex: 0
    property int currentGameIndex: 0
    property int screenmargin: vpx(30)
    property real screenwidth: width
    property real screenheight: height
    property bool widescreen: ((height/width) < 0.7)
    property real helpbarheight: Math.round(screenheight * 0.1041) // Calculated manually based on mockup
    property bool darkThemeActive

    function modulo(a,n) {
        return (a % n + n) % n;
    }

    function nextColl() {
        jumpToCollection(collectionIndex + 1);
    }

    function prevCollection() {
        jumpToCollection(collectionIndex - 1);
    }

    function jumpToCollection(idx) {
        api.memory.set('gameCollIndex' + collectionIndex, currentGameIndex); // save game index of current collection
        collectionIndex = modulo(idx, api.collections.count); // new collection index
        currentGameIndex = 0; // Jump to the top of the list each time collection is changed
    }

    function showSoftwareScreen()
    {
        /*platformScreen.visible = false;
        softwareScreen.visible = true;*/
        softwareScreen.focus = true;
        toSoftware.play();
    }

    function showHomeScreen()
    {
        platformScreen.focus = true;
        backSfx.play();
        /*platformScreen.visible = true;
        softwareScreen.visible = false;*/
        //platformScreen.focus = true;
    }

    function playGame()
    {
        root.state = "playgame"

        launchSfx.play()
    }

    function playSoftware()
    {
        root.state = "playsoftware"

        launchSfx.play()
    }

    // Launch the current game from PlatformBar
    function launchGame(game) {
        api.memory.set('Last Collection', currentCollection);
        if (game != null)
            game.launch();
        else
            currentGame.launch();
    }

    // Launch current game from SoftwareScreen
    function launchSoftware() {
        softwareList[sortByIndex].currentGame(currentGameIndex).launch();
            //currentGame.launch();
    }

    // Theme settings
    FontLoader { id: titleFont; source: "fonts/Nintendo_Switch_UI_Font.ttf" }

    property var themeLight: {
        return {
            main: "#EBEBEB",
            secondary: "#2D2D2D",
            accent: "#10AEBE",
            highlight: "white",
            text: "#2C2C2C",
            button: "#cccccc"
        }
    }

    property var themeDark: {
        return {
            main: "#2D2D2D",
            secondary: "#EBEBEB",
            accent: "#10AEBE",
            highlight: "black",
            text: "white",
            button: "#515151"
        }
    }

    // TODO - Do this properly later
    property var theme: {
        return {
            main: api.memory.get('themeBG') || themeDark.main,
            secondary: api.memory.get('themeSecondary') || themeDark.secondary,
            accent: api.memory.get('themeAccent') || themeDark.accent,
            highlight: api.memory.get('themeHighlight') || themeDark.highlight,
            text: api.memory.get('themeText') || themeDark.text,
            button: api.memory.get('themeButton') || themeDark.button
        }
    }

    function swapTheme() {
        if (darkThemeActive) {
            darkThemeActive = false;
            theme.main = themeLight.main;
        } else {
            darkThemeActive = true;
            theme.main = themeDark.main;
        }
    }

    // State settings
    states: [
        State {
            name: "platformscreen"; when: platformScreen.focus == true
        },
        State {
            name: "softwarescreen"; when: softwareScreen.focus == true
        },
        State {
            name: "playgame";
        },
        State {
            name: "playsoftware";
        }
    ]

    property int currentScreenID: -3

    transitions: [
        Transition {
            from: "platformscreen"; to: "softwarescreen"
            SequentialAnimation {
                PropertyAnimation { target: platformScreen; property: "opacity"; to: 0; duration: 200}
                PropertyAction { target: platformScreen; property: "visible"; value: false }
                PropertyAction { target: softwareScreen; property: "visible"; value: true }
                PropertyAnimation { target: softwareScreen; property: "opacity"; to: 1; duration: 200}
            }
        },
        Transition {
            from: "softwarescreen"; to: "platformscreen"
            SequentialAnimation {
                PropertyAnimation { target: softwareScreen; property: "opacity"; to: 0; duration: 200}
                PropertyAction { target: softwareScreen; property: "visible"; value: false }
                PropertyAction { target: platformScreen; property: "visible"; value: true }
                PropertyAnimation { target: platformScreen; property: "opacity"; to: 1; duration: 200}
            }
        },
        Transition {
            to: "playgame"
            SequentialAnimation {
                PropertyAnimation { target: softwareScreen; property: "opacity"; to: 0; duration: 200}
                PauseAnimation { duration: 200 }
                ScriptAction { script: launchGame(currentGame) }
            }
        },
        Transition {
            to: "playsoftware"
            SequentialAnimation {
                PropertyAnimation { target: softwareScreen; property: "opacity"; to: 0; duration: 200}
                PauseAnimation { duration: 200 }
                ScriptAction { script: launchSoftware() }
            }
        },
        Transition {
            from: ""; to: "platformscreen"
            ParallelAnimation {
                NumberAnimation { target: platformScreen; property: "scale"; from: 1.2; to: 1.0; duration: 200; easing.type: Easing.OutQuad }
                NumberAnimation { target: platformScreen; property: "opacity"; from: 0; to: 1; duration: 200 }
            }
        }
    ]


    // Background
    Rectangle {
        id: background
        anchors
        {
            left: parent.left; right: parent.right
            top: parent.top; bottom: parent.bottom
        }
        color: theme.main
    }

    Component.onCompleted: {
        state: "platformscreen"
        currentCollection = api.memory.has('Last Collection') ? api.memory.get('Last Collection') : -1
        api.memory.unset('Last Collection');
        homeSfx.play()
    }


    // Platform screen
    PlatformScreen
    {
        id: platformScreen
        focus: true
        anchors
        {
            left: parent.left; right: parent.right
            top: parent.top; bottom: helpBar.top
        }
    }

    // List specific input
    Keys.onPressed: {
        // Open collections menu
        if (api.keys.isFilters(event) && !event.isAutoRepeat) {
            event.accepted = true;
        }

        // Cycle collection forward
        if (api.keys.isNextPage(event) && !event.isAutoRepeat) {
            event.accepted = true;
            turnOnSfx.play();
            nextColl();
            if (currentCollection < api.collections.count-1) {
                nextCollection++;
            } else {
                nextCollection = -1;
            }
        }

        // Cycle collection back
        if (api.keys.isPrevPage(event) && !event.isAutoRepeat) {
            event.accepted = true;
            turnOffSfx.play();
            prevCollection();
            if (currentCollection == -1) {
                nextCollection = api.collections.count-1;
            } else{ 
                nextCollection--;
            }
        }
    }

     // Collection bar
    Item {
    id: collectionList

        width: parent.width
        height: vpx(90)
        //opacity: gameBar.active ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 50 } }

        // Build the collections list but with "All Games" as starting element
        ListModel {
        id: collectionsModel

            ListElement { name: "All Software"; shortName: "allgames"; games: "0" }

            Component.onCompleted: {
                for(var i=0; i<api.collections.count; i++) {
                    append(createListElement(i));
                }
            }
            
            function createListElement(i) {
                return {
                    name:       api.collections.get(i).name,
                    shortName:  api.collections.get(i).shortName,
                    games:      api.collections.get(i).games.count.toString()
                }
            }
        }
        
        // Collections
        ListView {
        id: collectionNav

            anchors {
                left: parent.left; leftMargin: vpx(75)
                right: searchButton.left; rightMargin: vpx(150)
                top: parent.top; bottom: parent.bottom
            }
            
            orientation: ListView.Horizontal
            preferredHighlightBegin: vpx(0)
            preferredHighlightEnd: vpx(0)
            highlightRangeMode: ListView.StrictlyEnforceRange
            snapMode: ListView.SnapOneItem 
            highlightMoveDuration: 100
            currentIndex: currentCollection+1
            clip: true
            interactive: false
            model: collectionsModel
            delegate: 
                Text {
                    property bool selected: ListView.isCurrentItem
                    text:name
                    color: "white"
                    //font.family: selected ? titleFont.name : subtitleFont.name
                    font.pixelSize: vpx(24)
                    width: implicitWidth + vpx(35)
                    height: collectionNav.height
                    verticalAlignment: Text.AlignVCenter
                }

            visible: false
        }

        Rectangle {
        id: navMask

            anchors.fill: collectionNav
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.9; color: "white" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            visible: false
        }

        OpacityMask {
            anchors.fill: collectionNav
            source: collectionNav
            maskSource: navMask
        }

        // Navigation
        Image {
        id: searchButton

            width: vpx(25)
            height: width
            source: "assets/images/Search.png"
            sourceSize: Qt.size(parent.width, parent.height)
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            smooth: true
            anchors {
                verticalCenter: parent.verticalCenter
                right: settingsButton.left; rightMargin: vpx(50)
            }
            visible: false // Disabling until ready to implement
        }

        Image {
        id: settingsButton

            width: vpx(25)
            height: width
            source: "assets/images/Settings.png"
            sourceSize: Qt.size(parent.width, parent.height)
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            smooth: true
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.left; rightMargin: vpx(50)
            }
            visible: false // Disabling until ready to implement
        }
    }

    // All Software screen
    SoftwareScreen {
        id: softwareScreen
        opacity: 0
        visible: false
        anchors
        {
            left: parent.left;// leftMargin: screenmargin
            right: parent.right;// rightMargin: screenmargin
            top: parent.top; bottom: helpBar.top
        }
    }

    //Changes Sort Option
    function cycleSort() {
        turnOnSfx.play()
        if (sortByIndex < softwareList.length - 1)
            sortByIndex++;
        else
            sortByIndex = 0;
    }



    // Help bar
    Item
    {
        id: helpBar
        anchors
        {
            left: parent.left; leftMargin: screenmargin
            right: parent.right; rightMargin: screenmargin
            bottom: parent.bottom
        }
        height: helpbarheight

        Rectangle {

            anchors.fill: parent
            color: theme.main
        }

        Rectangle {
            anchors.left: parent.left; anchors.right: parent.right
            height: 1
            color: theme.secondary
        }

        ControllerHelp {
            id: controllerHelp
            width: parent.width
            height: parent.height
            anchors {
                bottom: parent.bottom;
            }
            showBack: !platformScreen.focus
        }

    }

    SoundEffect {
      id: navSound
      source: "assets/audio/Klick.wav"
      volume: 1.0
    }

    SoundEffect {
      id: toSoftware
      source: "assets/audio/EnterBack.wav"
      volume: 1.0
    }

    SoundEffect {
      id: fillList
      source: "assets/audio/Icons.wav"
      volume: 1.0
    }

    SoundEffect {
      id: backSfx
      source: "assets/audio/Nock.wav"
      volume: 1.0
    }

    SoundEffect {
        id: launchSfx
        source: "assets/audio/PopupRunTitle.wav"
        volume: 1.0
    }

    SoundEffect {
        id: homeSfx
        source: "assets/audio/Home.wav"
        volume: 1.0
    }

    SoundEffect {
        id: turnOffSfx
        source: "assets/audio/Turn On.wav"
        volume: 1.0
    }

    SoundEffect {
        id: turnOnSfx
        source: "assets/audio/Turn Off.wav"
        volume: 1.0
    }

}
