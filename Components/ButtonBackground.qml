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
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.4

Item {
    id: backgroundRoot

    property bool focused: false
    property string textToDisplay: ""


    property int typewriterCharIndex: 0

    function spawn() {
        spawnAnimations.start()
    }

    function despawn() {
        despawnAnimations.start()
    }

    // VERTICAL BAR
    Image {
        id: buttonVerticalBar
        anchors.left: parent.left
        width: 30
        height: parent.height
        source: Qt.resolvedUrl("../Assets/vertical_bar.png")
        opacity: 0 //0.13
    }

    // FOCUS POINTER
    Image {
        id: buttonFocusPointer
        anchors.left: parent.left
        anchors.leftMargin: 14 //TODO: Relative scaling
        anchors.verticalCenter: parent.verticalCenter
        width: 40 //TODO: Relative scaling
        height: 27 //TODO: Relative scaling
        source: Qt.resolvedUrl("../Assets/focus_pointer.png")
        opacity: focused ? 0.63 : 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
    }

    Item {
        id: buttonBackgroundContainer

        anchors.right: parent.right
        anchors.rightMargin: 60 //0
        
        anchors.verticalCenter: parent.verticalCenter

        height: 48
        width: 389

        Rectangle {
            id: buttonBackground
            
            anchors.fill: parent
            
            color: root.palette.button

            opacity: 0
            layer.enabled: false
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 4
                verticalOffset: 4
                radius: 0
                samples: 17
                color: "#45000000"
            }
        }

        Rectangle {
            id: buttonDarkener

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: 0
            color: "#000000"
            opacity: 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }

            Behavior on width {
                enabled: !buttonDarkener.width > 0 // Fire animation only when expanding, not collapsing
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutExpo
                }
            }
        }

        // SIDEBARS
        Rectangle {
            id: buttonUpwardsSidebar
            width: 389 //TODO: Relative scaling
            height: 2 //TODO: Relative scaling
            anchors.bottom: parent.top
            anchors.bottomMargin: -2
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#000000"
            opacity: 0

            Behavior on anchors.bottomMargin {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }
        
        Rectangle {
            id: buttonDownwardsSidebar
            width: 389 //TODO: Relative scaling
            height: 2 //TODO: Relative scaling
            anchors.top: parent.bottom
            anchors.topMargin: -2
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#000000"
            opacity: 0

            Behavior on anchors.topMargin {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // SQUARE
        Rectangle {
            id: buttonSquare
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 12
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            width: height
            color: root.palette.text
            opacity: 0 //0.8
            z: 5
        }

        Text {
            id: buttonText

            property string textToDisplay: backgroundRoot.textToDisplay

            text: root.getTypewriterText(textToDisplay, backgroundRoot.typewriterCharIndex)
            anchors.left: buttonSquare.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            font.family: root.fontFamily
            font.pointSize: 15

            color: root.palette.text
            opacity: 0 //1
            
            z: 3
        }
    }

    states: [
        State {
            name: "focused"
            when: focused
            PropertyChanges { // Change text color
                target: buttonText
                color: root.palette.highlight
            }
            PropertyChanges { // Darken the background
                target: buttonDarkener
                opacity: 0.5
                width: buttonBackground.width
            }
            PropertyChanges { // Add shadow to the background
                target: backgroundRoot
                layer.enabled: true
            }
            PropertyChanges { // Pop out the sidebars
                target: buttonUpwardsSidebar
                anchors.bottomMargin: 4 //TODO: Relative scaling
                opacity: 0.63
            }
            PropertyChanges { // Pop out the sidebars
                target: buttonDownwardsSidebar
                anchors.topMargin: 4 //TODO: Relative scaling
                opacity: 0.63
            }
            PropertyChanges { // Highlight square
                target: buttonSquare
                color: root.palette.highlight
            }
        }
    ]

    SequentialAnimation {
        id: spawnAnimations
        ParallelAnimation {
            NumberAnimation {
                target: buttonSquare
                property: "opacity"
                from: 0
                to: 0.8
                duration: 200
            }

            NumberAnimation {
                target: buttonBackground
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }

            NumberAnimation {
                target: backgroundRoot.parent
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }

            NumberAnimation {
                target: buttonVerticalBar
                property: "opacity"
                from: 0
                to: 0.13
                duration: 200
            }

            NumberAnimation {
                target: buttonBackgroundContainer.anchors
                property: "rightMargin"
                from: 60
                to: 0
                duration: 200
            }
        }
        
        ScriptAction {
            script: {
                buttonText.opacity = 1
                buttonTypewriter.start()
            }
        }
    }

    ParallelAnimation {
        id: despawnAnimations
        NumberAnimation {
            target: buttonSquare
            property: "opacity"
            from: 0.8
            to: 0
            duration: 200
        }

        NumberAnimation {
            target: backgroundRoot.parent
            property: "opacity"
            from: 1
            to: 0
            duration: 200
        }

        NumberAnimation {
            target: buttonVerticalBar
            property: "opacity"
            from: 0.13
            to: 0
            duration: 200
        }

        ScriptAction {
            script: {
                buttonText.opacity = 0
                buttonTypewriter.stop()
                backgroundRoot.typewriterCharIndex = 0
            }
        }
    }

    NumberAnimation {
        id: buttonTypewriter
        target: backgroundRoot
        property: "typewriterCharIndex"
        from: 0
        to: buttonText.textToDisplay.length
        duration: 200
        easing.type: Easing.Linear
    }
}