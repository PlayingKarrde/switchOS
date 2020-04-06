// This file contains some helper scripts for formatting data


// For multiplayer games, show the player count as '1-N'
function formatPlayers(playerCount) {
    if (playerCount === 1)
        return playerCount

    return "1-" + playerCount;
}


// Show dates in Y-M-D format
function formatDate(date) {
    return Qt.formatDate(date, "yyyy-MM-dd");
}


// Show last played time as text. Based on the code of the default Pegasus theme.
// Note to self: I should probably move this into the API.
function formatLastPlayed(lastPlayed) {
    if (isNaN(lastPlayed))
        return "never";

    var now = new Date();

    var elapsedHours = (now.getTime() - lastPlayed.getTime()) / 1000 / 60 / 60;
    if (elapsedHours < 24 && now.getDate() === lastPlayed.getDate())
        return "today";

    var elapsedDays = Math.round(elapsedHours / 24);
    if (elapsedDays <= 1)
        return "yesterday";

    return elapsedDays + " days ago"
}


// Display the play time (provided in seconds) with text.
// Based on the code of the default Pegasus theme.
// Note to self: I should probably move this into the API.
function formatPlayTime(playTime) {
    var minutes = Math.ceil(playTime / 60)
    if (minutes <= 90)
        return Math.round(minutes) + " minutes";

    return parseFloat((minutes / 60).toFixed(1)) + " hours"
}

// Process the platform name to make it friendly for the logo
// Unfortunately necessary for LaunchBox
function processPlatformName(platform) {
  switch (platform) {
    case "panasonic 3do":
      return "3do";
      break;
    case "3do interactive multiplayer":
      return "3do";
      break;
    case "amstrad cpc":
      return "amstradcpc";
      break;
    case "apple ii":
      return "apple2";
      break;
    case "atari 800":
      return "atari800";
      break;
    case "atari 2600":
      return "atari2600";
      break;
    case "atari 5200":
      return "atari5200";
      break;
    case "atari 7800":
      return "atari7800";
      break;
    case "atari jaguar":
      return "atarijaguar";
      break;
    case "atari jaguar cd":
      return "atarijaguarcd";
      break;
    case "atari lynx":
      return "atarilynx";
      break;
    case "atari st":
      return "atarist";
      break;
    case "commodore 64":
      return "c64";
      break;
    case "tandy trs-80":
      return "coco";
      break;
    case "commodore amiga":
      return "amiga";
      break;
    case "sega dreamcast":
      return "dreamcast";
      break;
    case "final burn alpha":
      return "fba";
      break;
    case "sega game gear":
      return "gamegear";
      break;
    case "nintendo game boy":
      return "gb";
      break;
    case "nintendo game boy advance":
      return "gba";
      break;
    case "nintendo game boy color":
      return "gbc";
      break;
    case "nintendo gamecube":
      return "gc";
      break;
    case "sega genesis":
      return "genesis";
      break;
    case "mattel intellivision":
      return "intellivision";
      break;
    case "sega master system":
      return "mastersystem";
      break;
    case "sega mega drive":
      return "megadrive";
      break;
    case "sega genesis":
      return "genesis";
      break;
    case "microsoft msx":
      return "msx";
      break;
    case "nintendo 64":
      return "n64";
      break;
    case "nintendo ds":
      return "nds";
      break;
    case "snk neo geo aes":
      return "neogeo";
      break;
    case "snk neo geo mvs":
      return "neogeo";
      break;
    case "snk neo geo cd":
      return "neogeocd";
      break;
    case "nintendo 64":
      return "n64";
      break;
    case "nintendo entertainment system":
      return "nes";
      break;
    case "snk neo geo pocket":
      return "ngp";
      break;
    case "snk neo geo pocket color":
      return "ngpc";
      break;
    case "sega cd":
      return "segacd";
      break;
    case "nec turbografx-16":
      return "tg16";
      break;
    case "sony psp":
      return "psp";
      break;
    case "sony playstation":
      return "psx";
      break;
    case "sony playstation 2":
      return "ps2";
      break;
    case "sony playstation 3":
      return "ps3";
      break;
    case "sony playstation vita":
      return "vita";
      break;
    case "sega saturn":
      return "saturn";
      break;
    case "sega 32x":
      return "sega32x";
      break;
    case "super nintendo entertainment system":
      return "snes";
      break;
    case "sega cd":
      return "segacd";
      break;
    case "nintendo wii":
      return "wii";
      break;
    case "nintendo wii u":
      return "wiiu";
      break;
    case "nintendo 3ds":
      return "3ds";
      break;
    case "microsoft xbox":
      return "xbox";
      break;
    case "microsoft xbox 360":
      return "xbox360";
      break;
    case "nintendo switch":
      return "switch";
      break;
    default:
      return platform;
  }
}

// Get the color for each platform
// Again not the best but ehh what ya gonna do
function getPlatformColor(platform) {
  switch (platform) {
    case "arcade":
      return "#CA0543";
      break;
    case "panasonic 3do":
      return "#005AAB";
      break;
    case "3do interactive multiplayer":
      return "#005AAB";
      break;
    case "amstrad cpc":
      return "#891113";
      break;
    case "apple ii":
      return "#F5831E";
      break;
    case "atari 800":
      return "#F60002";
      break;
    case "atari 2600":
      return "#F60002";
      break;
    case "atari 5200":
      return "#F60002";
      break;
    case "atari 7800":
      return "#F60002";
      break;
    case "atari jaguar":
      return "#F60002";
      break;
    case "atari jaguar cd":
      return "#F60002";
      break;
    case "atari lynx":
      return "#F60002";
      break;
    case "atari st":
      return "#F60002";
      break;
    case "commodore 64":
      return "#032055";
      break;
    case "tandy trs-80":
      return "#E61B23";
      break;
    case "commodore amiga":
      return "#032055";
      break;
    case "sega dreamcast":
      return "#0085C9";
      break;
    case "final burn alpha":
      return "#F8762E";
      break;
    case "sega game gear":
      return "#0085C9";
      break;
    case "nintendo game boy":
      return "#e4000f";
      break;
    case "nintendo game boy advance":
      return "#e4000f";
      break;
    case "nintendo game boy color":
      return "#e4000f";
      break;
    case "nintendo gamecube":
      return "#e4000f";
      break;
    case "sega genesis":
      return "#0085C9";
      break;
    case "mattel intellivision":
      return "#CB2320";
      break;
    case "sega master system":
      return "#0085C9";
      break;
    case "sega mega drive":
      return "#0085C9";
      break;
    case "sega genesis":
      return "#0085C9";
      break;
    case "microsoft msx":
      return "#0075D1";
      break;
    case "nintendo 64":
      return "#e4000f";
      break;
    case "nintendo ds":
      return "#e4000f";
      break;
    case "snk neo geo aes":
      return "#008CBA";
      break;
    case "snk neo geo mvs":
      return "#008CBA";
      break;
    case "snk neo geo cd":
      return "#008CBA";
      break;
    case "nintendo 64":
      return "#e4000f";
      break;
    case "nintendo entertainment system":
      return "#e4000f";
      break;
    case "snk neo geo pocket":
      return "#008CBA";
      break;
    case "snk neo geo pocket color":
      return "#008CBA";
      break;
    case "sega cd":
      return "#0085C9";
      break;
    case "nec turbografx-16":
      return "#F86346";
      break;
    case "sony psp":
      return "#003E94";
      break;
    case "sony playstation":
      return "#003E94";
      break;
    case "sony playstation 2":
      return "#003E94";
      break;
    case "sony playstation 3":
      return "#003E94";
      break;
    case "sony playstation vita":
      return "#003E94";
      break;
    case "sega saturn":
      return "#0085C9";
      break;
    case "sega 32x":
      return "#0085C9";
      break;
    case "super nintendo entertainment system":
      return "#e4000f";
      break;
    case "sega cd":
      return "#0085C9";
      break;
    case "nintendo wii":
      return "#e4000f";
      break;
    case "nintendo wii u":
      return "#e4000f";
      break;
    case "nintendo 3ds":
      return "#e4000f";
      break;
    case "microsoft xbox":
      return "#10790F";
      break;
    case "microsoft xbox 360":
      return "#10790F";
      break;
    case "nintendo switch":
      return "#e4000f";
      break;
    case "windows":
      return "#0075D1"
      break;
    default:
      return platform;
  }
}


/*function processButtonArt(buttonModel) {
  return buttonModel;
}*/
