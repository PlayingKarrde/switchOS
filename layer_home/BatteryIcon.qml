import QtQuick 2.15
import QtGraphicalEffects 1.12

Item {
    property int level // 0-100 levels

    function getBatteryIcon()
    {
        if (level >= 0 && level <= 20)
            return "../assets/images/battery-empty.svg" // fa-battery-empty
        else if (level >= 21 && level <= 40)
            return "../assets/images/battery-quarter.svg"  // fa-battery-quarter
        else if (level >= 41 && level <= 60)
            return "../assets/images/battery-half.svg"  // fa-battery-half
        else if (level >= 61 && level <= 80)
            return "../assets/images/battery-three-quarters.svg" // fa-battery-three-quarters
        else if (level >= 81 && level <= 100)
            return "../assets/images/battery-full.svg"  // fa-battery-full
        else
            return "../assets/images/battery-empty.svg"  // fa-battery-empty
    }

    Image {
        width: Math.round(screenheight * 0.0433)
        height: width / 1.5
        source: getBatteryIcon();
        sourceSize { width: 128; height:64 }
        smooth: true
    }

}