//
// This file is part of Sugar Dark, a theme for the Simple Display Desktop Manager.
//
// Copyright 2026 NeekoKun
//
// Sugar Dark is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Sugar Dark is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Sugar Dark. If not, see <https://www.gnu.org/licenses/>.
//

import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import QtMultimedia 5.11

Rectangle {
    id: footer
    color: "#D5CFAF"

    Layout.fillWidth: true
    Layout.preferredHeight: 80

    property int typewriterCharIndex: 0

    property alias typewriterForward: typewriterForward
    property alias typewriterBackward: typewriterBackward

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.topMargin: 4
        anchors.rightMargin: -4
        anchors.bottomMargin: -4
        color: "#45000000"
        z: -1
    }

    Image {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        source: Qt.resolvedUrl("../Assets/vertical_bar.png")
        opacity: 0.7
    }

    Rectangle {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        width: 20
        height: 20
        color: "#000000"
        opacity: 0.7
    }

    Row {
        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 0
        spacing: 16
        opacity: typewriterCharIndex > 0 ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }

        // Restart button
        Item {
            width: 54
            height: 62

            Rectangle {
                id: restartRect
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: 44
                height: 44
                color: restartMouse.containsMouse ? "#C9C3A3" : "transparent"
                border.color: "#34332B"
                border.width: 1
                opacity: 0.6
                radius: 2

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            Text {
                anchors.centerIn: restartRect
                text: "\u21BA"
                font.pointSize: 18
                font.family: root.fontFamily
                color: "#34332B"
                opacity: 0.8
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: "Restart"
                font.family: root.fontFamily
                font.pointSize: 9
                font.weight: Font.DemiBold
                color: "#34332B"
                opacity: 0.7
            }

            MouseArea {
                id: restartMouse
                anchors.top: parent.top
                width: parent.width
                height: 44
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: sddm.reboot()
            }
        }

        // Power off button
        Item {
            width: 54
            height: 62

            Rectangle {
                id: powerRect
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: 44
                height: 44
                color: powerMouse.containsMouse ? "#C9C3A3" : "transparent"
                border.color: "#34332B"
                border.width: 1
                opacity: 0.6
                radius: 2

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            Text {
                anchors.centerIn: powerRect
                text: "\u23FB"
                font.pointSize: 16
                font.family: root.fontFamily
                color: "#34332B"
                opacity: 0.8
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: "Power Off"
                font.family: root.fontFamily
                font.pointSize: 9
                font.weight: Font.DemiBold
                color: "#34332B"
                opacity: 0.7
            }

            MouseArea {
                id: powerMouse
                anchors.top: parent.top
                width: parent.width
                height: 44
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: sddm.powerOff()
            }
        }
    }

    SequentialAnimation {
        id: typewriterForward
        PauseAnimation { duration: 100 }
        NumberAnimation {
            target: footer
            property: "typewriterCharIndex"
            from: 0
            to: 1
            duration: 200
            easing.type: Easing.Linear
        }
    }

    NumberAnimation {
        id: typewriterBackward
        target: footer
        property: "typewriterCharIndex"
        to: 0
        duration: 200
        easing.type: Easing.Linear
    }
}