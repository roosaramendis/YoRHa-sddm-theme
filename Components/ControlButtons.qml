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

ColumnLayout {
    property bool canSuspend: sddm.canSuspend
    property bool canHibernate: sddm.canHibernate
    property bool canReboot: sddm.canReboot
    property bool canShutdown: sddm.canShutdown

    spacing: 0

    required property PanelButton controlPanelButton

    function spawn() {
        spawnAnimationSequence.start()
    }

    function despawn() {
        despawnAnimationSequence.start()
    }

    // Suspend Button
    Item {
        id: suspendButton

        property int typewriterCharIndex: 0
        property real opacityMultiplier: suspend[2] ? 1 : 0.6

        height: 75
        width: 500

        // VERTICAL BAR
        Image {
            id: suspendVerticalBar
            anchors.right: parent.left
            anchors.rightMargin: -21
            width: 30
            height: parent.height
            source: Qt.resolvedUrl("../Assets/vertical_bar.png")
            opacity: 0 // 0.13
        }

        // FOCUS POINTER
        Image {
            id: suspendFocusPointer
            anchors.right: suspend.left
            anchors.rightMargin: 10 //TODO: Relative scaling
            anchors.verticalCenter: suspendButton.verticalCenter
            width: 40 //TODO: Relative scaling
            height: 27 //TODO: Relative scaling
            source: Qt.resolvedUrl("../Assets/focus_pointer.png")
            opacity: suspend.activeFocus ? 0.63 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        // SIDEBARS
        Rectangle {
            id: suspendUpwardsSidebar
            width: 389 //TODO: Relative scaling
            height: 2 //TODO: Relative scaling
            anchors.bottom: suspend.top
            anchors.bottomMargin: -2
            anchors.horizontalCenter: suspend.horizontalCenter
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
            id: suspendDownwardsSidebar
            width: 389 //TODO: Relative scaling
            height: 2 //TODO: Relative scaling
            anchors.top: suspend.bottom
            anchors.topMargin: -2
            anchors.horizontalCenter: suspend.horizontalCenter
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
            id: suspendSquare
            anchors.left: suspend.left
            anchors.top: suspend.top
            anchors.bottom: suspend.bottom
            anchors.leftMargin: 12
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            width: height
            color: root.palette.text
            opacity: 0 //0.8
            z: 5
        }

        Text {
            id: suspendText
            text: root.getTypewriterText("Suspend", suspend.typewriterCharIndex)
            anchors.left: suspendSquare.right
            anchors.verticalCenter: suspend.verticalCenter
            anchors.leftMargin: 12
            font.family: root.fontFamily
            font.pointSize: 15

            color: root.palette.text
            opacity: 0 //1

            z: 3
        }

        // BUTTON
        Button {
            id: suspend

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 55 //TODO: Relative scaling
            height: 48
            width: 389

            background: Item {
                Rectangle {
                    id: suspendBackground
                    anchors.fill: parent
                    color: root.palette.button
                    opacity: 0
                }

                Rectangle {
                    id: suspendDarkener
                    anchors.left: parent.left
                    height: parent.height
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
                        enabled: !suspendDarkener.width > 0 // Fire animation only when expanding, not collapsing
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutExpo
                        }
                    }
                }

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

            onClicked: {
                sddm.suspend() //TODO: "Are you sure?" check box
            }

            KeyNavigation.up: controlPanelButton.button
            KeyNavigation.down: hibernate
            Keys.onReturnPressed: clicked()
        }

        states: [
            State {
                name: "focused"
                when: suspend.activeFocus
                PropertyChanges { // Change text color
                    target: suspendText
                    color: root.palette.highlight
                }
                PropertyChanges { // Darken the background
                    target: suspendDarkener
                    opacity: 0.5
                    width: parent.width
                }
                PropertyChanges { // Add shadow to the background
                    target: suspend.background
                    layer.enabled: true
                }
                PropertyChanges { // Pop out the sidebars
                    target: suspendUpwardsSidebar
                    anchors.bottomMargin: 4 //TODO: Relative scaling
                    opacity: 0.63
                }
                PropertyChanges { // Pop out the sidebars
                    target: suspendDownwardsSidebar
                    anchors.topMargin: 4 //TODO: Relative scaling
                    opacity: 0.63
                }
                PropertyChanges { // Highlight square
                    target: suspendSquare
                    color: root.palette.highlight
                }
            }
        ]

        NumberAnimation {
            id: suspendTypewriter
            target: suspendButton
            property: "typewriterCharIndex"
            from: 0
            to: suspendText.text.length
            duration: 300
            easing.type: Easing.Linear
        }
    }

    // Hibernate Button
    Item {
        id: hibernateButton

        property int typewriterCharIndex: 0
        property real opacityMultiplier: hibernate[2] ? 1 : 0.6

        height: 75
        width: 500

        // VERTICAL BAR
        Image {
            id: hibernateVerticalBar
            anchors.right: parent.left
            anchors.rightMargin: -21
            width: 30
            height: parent.height
            source: Qt.resolvedUrl("../Assets/vertical_bar.png")
            opacity: 0.13 //0
        }

        // FOCUS POINTER
        Image {
            id: hibernateFocusPointer
            anchors.right: hibernate.left
            anchors.rightMargin: 10 //TODO: Relative scaling
            anchors.verticalCenter: hibernateButton.verticalCenter
            width: 40 //TODO: Relative scaling
            height: 27 //TODO: Relative scaling
            source: Qt.resolvedUrl("../Assets/focus_pointer.png")
            opacity: hibernate.activeFocus ? 0.63 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        // SIDEBARS
        Rectangle {
            id: hibernateUpwardsSidebar
            width: 389 //TODO: Relative scaling
            height: 2 //TODO: Relative scaling
            anchors.bottom: hibernate.top
            anchors.bottomMargin: -2
            anchors.horizontalCenter: hibernate.horizontalCenter
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
            id: hibernateDownwardsSidebar
            width: 389 //TODO: Relative scaling
            height: 2 //TODO: Relative scaling
            anchors.top: hibernate.bottom
            anchors.topMargin: -2
            anchors.horizontalCenter: hibernate.horizontalCenter
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
            id: hibernateSquare
            anchors.left: hibernate.left
            anchors.top: hibernate.top
            anchors.bottom: hibernate.bottom
            anchors.leftMargin: 12
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            width: height
            color: root.palette.text
            opacity: 0.8
            z: 5
        }

        Text {
            id: hibernateText
            text: root.getTypewriterText("Hibernate", hibernate.typewriterCharIndex)
            anchors.left: hibernateSquare.right
            anchors.verticalCenter: hibernate.verticalCenter
            anchors.leftMargin: 12
            font.family: root.fontFamily
            font.pointSize: 15

            color: root.palette.text
            
            z: 3
        }

        // BUTTON
        Button {
            id: hibernate

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 55 //TODO: Relative scaling
            height: 48
            width: 389

            background: Item {
                Rectangle {
                    id: hibernateBackground
                    anchors.fill: parent
                    color: root.palette.button

                    opacity: 0
                }

                Rectangle {
                    id: hibernateDarkener
                    anchors.left: parent.left
                    height: parent.height
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
                        enabled: !hibernateDarkener.width > 0 // Fire animation only when expanding, not collapsing
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutExpo
                        }
                    }
                }

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

            onClicked: {
                sddm.hibernate() //TODO: "Are you sure?" check box
            }

            KeyNavigation.up: suspend
            KeyNavigation.down: reboot
            Keys.onReturnPressed: clicked()
        }

        states: [
            State {
                name: "focused"
                when: hibernate.activeFocus
                PropertyChanges { // Change text color
                    target: hibernateText
                    color: root.palette.highlight
                }
                PropertyChanges { // Darken the background
                    target: hibernateDarkener
                    opacity: 0.5
                    width: parent.width
                }
                PropertyChanges { // Add shadow to the background
                    target: hibernate.background
                    layer.enabled: true
                }
                PropertyChanges { // Pop out the sidebars
                    target: hibernateUpwardsSidebar
                    anchors.bottomMargin: 4 //TODO: Relative scaling
                    opacity: 0.63
                }
                PropertyChanges { // Pop out the sidebars
                    target: hibernateDownwardsSidebar
                    anchors.topMargin: 4 //TODO: Relative scaling
                    opacity: 0.63
                }
                PropertyChanges { // Highlight square
                    target: hibernateSquare
                    color: root.palette.highlight
                }
            }
        ]

        NumberAnimation {
            id: hibernateTypewriter
            target: hibernateButton
            property: "typewriterCharIndex"
            from: 0
            to: hibernateText.text.length
            duration: 300
            easing.type: Easing.Linear
        }
    }

    // Reboot Button
    Item {
        id: rebootButton

        property int typewriterCharIndex: 0
        property real opacityMultiplier: reboot[2] ? 1 : 0.6

        height: 75
        width: 500

        // VERTICAL BAR
        Image {
            id: rebootVerticalBar
            anchors.right: parent.left
            anchors.rightMargin: -21
            width: 30
            height: parent.height
            source: Qt.resolvedUrl("../Assets/vertical_bar.png")
            opacity: 0.13 //0
        }

        // FOCUS POINTER
        Image {
            id: rebootFocusPointer
            anchors.right: reboot.left
            anchors.rightMargin: 10 //TODO: Relative scaling
            anchors.verticalCenter: rebootButton.verticalCenter
            width: 40 //TODO: Relative scaling
            height: 27 //TODO: Relative scaling
            source: Qt.resolvedUrl("../Assets/focus_pointer.png")
            opacity: reboot.activeFocus ? 0.63 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        // SIDEBARS
        Rectangle {
            id: rebootUpwardsSidebar
            width: 389 //TODO: Relative scaling
            height: 2 //TODO: Relative scaling
            anchors.bottom: reboot.top
            anchors.bottomMargin: -2
            anchors.horizontalCenter: reboot.horizontalCenter
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
            id: rebootDownwardsSidebar
            width: 389 //TODO: Relative scaling
            height: 2 //TODO: Relative scaling
            anchors.top: reboot.bottom
            anchors.topMargin: -2
            anchors.horizontalCenter: reboot.horizontalCenter
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
            id: rebootSquare
            anchors.left: reboot.left
            anchors.top: reboot.top
            anchors.bottom: reboot.bottom
            anchors.leftMargin: 12
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            width: height
            color: root.palette.text
            opacity: 0.8
            z: 5
        }

        Text {
            id: rebootText
            text: root.getTypewriterText("Reboot", reboot.typewriterCharIndex)
            anchors.left: rebootSquare.right
            anchors.verticalCenter: reboot.verticalCenter
            anchors.leftMargin: 12
            font.family: root.fontFamily
            font.pointSize: 15

            color: root.palette.text
            
            z: 3
        }

        Button {
            id: reboot

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 55 //TODO: Relative scaling
            height: 48
            width: 389

            background: Item {
                Rectangle {
                    id: rebootBackground
                    anchors.fill: parent
                    color: root.palette.button

                    opacity: 0
                }

                Rectangle {
                    id: rebootDarkener
                    anchors.left: parent.left
                    height: parent.height
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
                        enabled: !rebootDarkener.width > 0 // Fire animation only when expanding, not collapsing
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutExpo
                        }
                    }
                }

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

            onClicked: {
                sddm.reboot() //TODO: "Are you sure?" check box
            }

            KeyNavigation.up: hibernate
            KeyNavigation.down: shutdown
            Keys.onReturnPressed: clicked()
        }

        states: [
            State {
                name: "focused"
                when: reboot.activeFocus
                PropertyChanges { // Change text color
                    target: rebootText
                    color: root.palette.highlight
                }
                PropertyChanges { // Darken the background
                    target: rebootDarkener
                    opacity: 0.5
                    width: parent.width
                }
                PropertyChanges { // Add shadow to the background
                    target: reboot.background
                    layer.enabled: true
                }
                PropertyChanges { // Pop out the sidebars
                    target: rebootUpwardsSidebar
                    anchors.bottomMargin: 4 //TODO: Relative scaling
                    opacity: 0.63
                }
                PropertyChanges { // Pop out the sidebars
                    target: rebootDownwardsSidebar
                    anchors.topMargin: 4 //TODO: Relative scaling
                    opacity: 0.63
                }
                PropertyChanges { // Highlight square
                    target: rebootSquare
                    color: root.palette.highlight
                }
            }
        ]

        NumberAnimation {
            id: rebootTypewriter
            target: rebootButton
            property: "typewriterCharIndex"
            from: 0
            to: rebootText.text.length
            duration: 300
            easing.type: Easing.Linear
        }
    }

    // Shutdown Button
    Item {
        id: shutdownButton

        property int typewriterCharIndex: 0
        property real opacityMultiplier: shutdown[2] ? 1 : 0.6

        height: 75
        width: 500

        // VERTICAL BAR
        Image {
            id: shutdownVerticalBar
            anchors.right: parent.left
            anchors.rightMargin: -21
            width: 30
            height: parent.height
            source: Qt.resolvedUrl("../Assets/vertical_bar.png")
            opacity: 0.13 //0
        }

        // FOCUS POINTER
        Image {
            id: shutdownFocusPointer
            anchors.right: shutdown.left
            anchors.rightMargin: 10 //TODO: Relative scaling
            anchors.verticalCenter: shutdownButton.verticalCenter
            width: 40 //TODO: Relative scaling
            height: 27 //TODO: Relative scaling
            source: Qt.resolvedUrl("../Assets/focus_pointer.png")
            opacity: shutdown.activeFocus ? 0.63 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        // SIDEBARS
        Rectangle {
            id: shutdownUpwardsSidebar
            width: 389 //TODO: Relative scaling
            height: 2 //TODO: Relative scaling
            anchors.bottom: shutdown.top
            anchors.bottomMargin: -2
            anchors.horizontalCenter: shutdown.horizontalCenter
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
            id: shutdownDownwardsSidebar
            width: 389 //TODO: Relative scaling
            height: 2 //TODO: Relative scaling
            anchors.top: shutdown.bottom
            anchors.topMargin: -2
            anchors.horizontalCenter: shutdown.horizontalCenter
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
            id: shutdownSquare
            anchors.left: shutdown.left
            anchors.top: shutdown.top
            anchors.bottom: shutdown.bottom
            anchors.leftMargin: 12
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            width: height
            color: root.palette.text
            opacity: 0 //0.8
            z: 5
        }

        Text {
            id: shutdownText
            text: root.getTypewriterText("Shutdown", shutdown.typewriterCharIndex)
            anchors.left: shutdownSquare.right
            anchors.verticalCenter: shutdown.verticalCenter
            anchors.leftMargin: 12
            font.family: root.fontFamily
            font.pointSize: 15

            color: root.palette.text
            
            z: 3
        }

        // BUTTON
        Button {
            id: shutdown

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 55 //TODO: Relative scaling
            height: 48
            width: 389

            background: Item {
                Rectangle {
                    id: shutdownBackground
                    anchors.fill: parent
                    color: root.palette.button

                    opacity: 0
                }

                Rectangle {
                    id: shutdownDarkener
                    anchors.left: parent.left
                    height: parent.height
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
                        enabled: !shutdownDarkener.width > 0 // Fire animation only when expanding, not collapsing
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutExpo
                        }
                    }
                }

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

            onClicked: {
                sddm.shutdown() //TODO: "Are you sure?" check box
            }

            KeyNavigation.up: reboot
            Keys.onReturnPressed: clicked()
        }

        states: [
            State {
                name: "focused"
                when: shutdown.activeFocus
                PropertyChanges { // Change text color
                    target: shutdownText
                    color: root.palette.highlight
                }
                PropertyChanges { // Darken the background
                    target: shutdownDarkener
                    opacity: 0.5
                    width: parent.width
                }
                PropertyChanges { // Add shadow to the background
                    target: shutdown.background
                    layer.enabled: true
                }
                PropertyChanges { // Pop out the sidebars
                    target: shutdownUpwardsSidebar
                    anchors.bottomMargin: 4 //TODO: Relative scaling
                    opacity: 0.63
                }
                PropertyChanges { // Pop out the sidebars
                    target: shutdownDownwardsSidebar
                    anchors.topMargin: 4 //TODO: Relative scaling
                    opacity: 0.63
                }
                PropertyChanges { // Highlight square
                    target: shutdownSquare
                    color: root.palette.highlight
                }
            }
        ]

        NumberAnimation {
            id: shutdownTypewriter
            target: shutdownButton
            property: "typewriterCharIndex"
            from: 0
            to: shutdownText.text.length
            duration: 300
            easing.type: Easing.Linear
        }
    }

    ParallelAnimation {
        id: spawnAnimationSequence

        // SUSPEND ANIMATIONS
        SequentialAnimation {
            id: suspendAnimations
            
            ParallelAnimation {
                NumberAnimation {
                    target: suspendSquare
                    property: "opacity"
                    from: 0
                    to: 0.8
                    duration: 200
                }

                NumberAnimation {
                    target: suspend
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }

                NumberAnimation {
                    target: suspendBackground
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }

                NumberAnimation {
                    target: suspend.anchors
                    property: "leftMargin"
                    from: -5 //TODO: Relative scaling
                    to: 55 //TODO: Relative scaling
                    duration: 200
                }

                NumberAnimation {
                    target: suspendVerticalBar
                    property: "opacity"
                    from: 0
                    to: 0.13
                    duration: 200
                }
            }
            
            ScriptAction {
                script: suspendTypewriter.start()
            }
        }

        // HIBERNATE ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 100 }
            
            ParallelAnimation {
                NumberAnimation {
                    target: hibernateSquare
                    property: "opacity"
                    from: 0
                    to: 0.8
                    duration: 200
                }

                NumberAnimation {
                    target: hibernateBackground
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }

                NumberAnimation {
                    target: hibernate
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }

                NumberAnimation {
                    target: hibernate.anchors
                    property: "leftMargin"
                    from: -5 //TODO: Relative scaling
                    to: 55 //TODO: Relative scaling
                    duration: 200
                }

                NumberAnimation {
                    target: hibernateVerticalBar
                    property: "opacity"
                    from: 0
                    to: 0.13
                    duration: 200
                }
            }

            ScriptAction {
                script: {
                    hibernateTypewriter.start()
                }
            }
        }

        // REBOOT ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 200 }
            ParallelAnimation {
                NumberAnimation {
                    target: rebootSquare
                    property: "opacity"
                    from: 0
                    to: 0.8
                    duration: 200
                }

                NumberAnimation {
                    target: rebootBackground
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }

                NumberAnimation {
                    target: reboot
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }

                NumberAnimation {
                    target: rebootSelect.anchors
                    property: "leftMargin"
                    from: -5 //TODO: Relative scaling
                    to: 55 //TODO: Relative scaling
                    duration: 200
                }

                NumberAnimation {
                    target: rebootVerticalBar
                    property: "opacity"
                    from: 0
                    to: 0.13
                    duration: 200
                }
            }
            
            ScriptAction {
                script: rebootTypewriter.start()
            }
        }

        // SHUTDOWN ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 300 }
            ParallelAnimation {
                NumberAnimation {
                    target: shutdownSquare
                    property: "opacity"
                    from: 0
                    to: 0.8
                    duration: 200
                }

                NumberAnimation {
                    target: shutdownBackground
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }

                NumberAnimation {
                    target: shutdown
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }

                NumberAnimation {
                    target: shutdown.anchors
                    property: "leftMargin"
                    from: -5 //TODO: Relative scaling
                     to: 55 //TODO: Relative scaling
                    duration: 200
                }

                NumberAnimation {
                    target: shutdownVerticalBar
                    property: "opacity"
                    from: 0
                    to: 0.13
                    duration: 200
                }
            }
            
            ScriptAction {
                script: shutdownTypewriter.start()
            }
        }
    }

    ParallelAnimation {
        id: despawnAnimationSequence

        // SUSPEND ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 300 }
            ParallelAnimation {
                NumberAnimation {
                    target: suspendSquare
                    property: "opacity"
                    from: 0.8
                    to: 0
                    duration: 200
                }

                NumberAnimation {
                    target: suspend
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                }

                NumberAnimation {
                    target: suspend.anchors
                    property: "leftMargin"
                    from: 55 //TODO: Relative scaling
                    to: -5 //TODO: Relative scaling
                    duration: 200
                }

                NumberAnimation {
                    target: suspendVerticalBar
                    property: "opacity"
                    from: 0.13
                    to: 0
                    duration: 200
                }
            }
        }

        // HIBERNATE ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 200 }
            
            ParallelAnimation {
                NumberAnimation {
                    target: hibernateSquare
                    property: "opacity"
                    from: 0.8
                    to: 0
                    duration: 200
                }

                NumberAnimation {
                    target: hibernate
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                }

                NumberAnimation {
                    target: hibernate.anchors
                    property: "leftMargin"
                    from: 55 //TODO: Relative scaling
                    to: -5 //TODO: Relative scaling
                    duration: 200
                }

                NumberAnimation {
                    target: hibernateVerticalBar
                    property: "opacity"
                    from: 0.13
                    to: 0
                    duration: 200
                }
            }
        }

        // REBOOT SELECT ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 100 }
            ParallelAnimation {
                NumberAnimation {
                    target: rebootSquare
                    property: "opacity"
                    from: 0.8
                    to: 0
                    duration: 200
                }

                NumberAnimation {
                    target: reboot
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                }

                NumberAnimation {
                    target: rebootSelect.anchors
                    property: "leftMargin"
                    from: 55 //TODO: Relative scaling
                    to: -5 //TODO: Relative scaling
                    duration: 200
                }

                NumberAnimation {
                    target: rebootVerticalBar
                    property: "opacity"
                    from: 0.13
                    to: 0
                    duration: 200
                }
            }
        }

        // SHUTDOWN BUTTON ANIMATIONS
        SequentialAnimation {
            ParallelAnimation {
                NumberAnimation {
                    target: shutdownSquare
                    property: "opacity"
                    from: shutdown.opacityMultiplier
                    to: 0
                    duration: 200
                }

                NumberAnimation {
                    target: shutdownButton
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                }

                NumberAnimation {
                    target: shutdownButton.anchors
                    property: "leftMargin"
                    from: 55 //TODO: Relative scaling
                    to: -5 //TODO: Relative scaling
                    duration: 200
                }

                NumberAnimation {
                    target: shutdownVerticalBar
                    property: "opacity"
                    from: 0.13
                    to: 0
                    duration: 200
                }
            }
        }
    }
}
