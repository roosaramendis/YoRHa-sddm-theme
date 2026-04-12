//
// This file is part of Sugar Dark, a theme for the Simple Display Desktop Manager.
//
// Copyright 2018 Marian Arlt
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
import SddmComponents 2.0 as SDDM

Column {
    id: inputContainer
    Layout.fillWidth: true

    property Button exposeLogin: loginButton
    property bool failed
    property string fontFamily: "Arial"
    property var formFunctions: parent.parent

    required property PanelButton loginPanelButton

    function spawn() {
        spawnAnimationSequence.start()
    }

    function despawn() {
        despawnAnimationSequence.start()
    }

    // USERNAME INPUT (with user list dropdown)
    Item {
        id: usernameField

        property int typewriterCharIndex: 0

        // Expose the current username text for login
        property alias text: username.text

        height: 75
        width: 453 //TODO: Relative scaling
        anchors.left: parent.left

        // Hidden TextField keeps the actual username value and handles key events
        TextField {
            id: username
            visible: false
            text: {
                if (config.ForceLastUser === "true" && userModel.lastUser !== "")
                    return userModel.lastUser
                if (userCombo.currentIndex >= 0)
                    return userModel.data(userModel.index(userCombo.currentIndex, 0), 0x101) || ""
                return ""
            }
        }

        // ComboBox showing all users
        ComboBox {
            id: userCombo

            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            opacity: 0
            focus: false

            model: userModel
            textRole: "name"

            // Select last user by default
            currentIndex: {
                if (userModel.lastUser !== "") {
                    for (var i = 0; i < userModel.count; i++) {
                        if (userModel.data(userModel.index(i, 0), 0x101) === userModel.lastUser)
                            return i
                    }
                }
                return 0
            }

            // Keep username TextField in sync
            onCurrentIndexChanged: {
                username.text = userModel.data(userModel.index(currentIndex, 0), 0x101) || ""
            }

            Keys.onReturnPressed: loginButton.clicked()
            KeyNavigation.down: password
            KeyNavigation.up: loginPanelButton.button

            Keys.onDownPressed: {
                if (popup.visible) {
                    // Navigate list
                } else {
                    focusSound.play()
                    password.forceActiveFocus()
                }
            }

            Keys.onUpPressed: {
                if (!popup.visible) {
                    focusSound.play()
                    loginPanelButton.button.forceActiveFocus()
                }
            }

            // Style: transparent background, we use ButtonBackground underneath
            background: ButtonBackground {
                id: usernameBackground
                focused: userCombo.activeFocus
                textToDisplay: userCombo.currentText
            }

            // Hide the default ComboBox content area — ButtonBackground draws the text
            contentItem: Item {}

            // Dropdown popup styled to match the theme
            popup: Popup {
                y: userCombo.height
                width: userCombo.width
                padding: 0

                background: Rectangle {
                    color: "#D5CFAF"
                    border.color: "#AFA98F"
                    border.width: 2
                }

                contentItem: ListView {
                    implicitHeight: contentHeight
                    model: userCombo.delegateModel
                    clip: true

                    ScrollIndicator.vertical: ScrollIndicator {}
                }
            }

            delegate: ItemDelegate {
                width: userCombo.width
                height: 50

                background: Rectangle {
                    color: hovered ? "#C9C3A3" : "#D5CFAF"
                }

                contentItem: Text {
                    text: model.name
                    font.family: inputContainer.fontFamily
                    font.pointSize: 15
                    color: "#34332B"
                    leftPadding: 112
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    userCombo.currentIndex = index
                    userCombo.popup.close()
                    password.forceActiveFocus()
                }
            }

            z: 1
        }

        NumberAnimation {
            id: usernameTypewriter
            target: usernameField
            property: "typewriterCharIndex"
            from: 0
            to: 8
            duration: 200
            easing.type: Easing.Linear
        }

        Connections {
            target: usernameBackground
            function onSpawned() {
                userCombo.opacity = 1
                usernameTypewriter.start()
            }
        }
    }

    // PASSWORD INPUT
    Item {
        id: passwordField
        
        property int passwordCharIndex: 0
        
        height: 75
        width: 453 //TODO: Relative scaling
        anchors.left: parent.left

        TextField {
            id: password

            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            focus: false
            anchors.centerIn: parent
            selectByMouse: true
            echoMode: TextInput.Password
            placeholderText: root.getTypewriterText("Password", passwordField.passwordCharIndex)
            font.family: inputContainer.fontFamily
            font.pointSize: 15
            horizontalAlignment: TextInput.AlignLeft
            passwordCharacter: "*"
            passwordMaskDelay: config.PasswordHideDelay || 0
            renderType: Text.QtRendering
            color: password.activeFocus ? root.palette.highlight : root.palette.text
            leftPadding: 112

            background: ButtonBackground {
                id: passwordBackground
                focused: password.activeFocus
            }

            Keys.onReturnPressed: loginButton.clicked()
            KeyNavigation.down: sessionSelect

            Keys.onDownPressed: {
                focusSound.play()
                KeyNavigation.down.forceActiveFocus()
            }

            Keys.onUpPressed: {
                focusSound.play()
                KeyNavigation.up.forceActiveFocus()
            }
        }

        NumberAnimation {
            id: passwordTypewriter
            target: passwordField
            property: "passwordCharIndex"
            from: 0
            to: 8
            duration: 200
            easing.type: Easing.Linear
        }

        Connections {
            target: passwordBackground
            function onSpawned() {
                passwordTypewriter.start()
            }
        }
    }

    // SESSION SELECT
    Item {
        id: sessionSelectContainer
        
        property int sessionSelectCharIndex: 0
        
        height: 75
        width: 453 //TODO: Relative scaling
        anchors.left: parent.left

        SessionButton {
            id: sessionSelect

            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            KeyNavigation.up: password
            KeyNavigation.down: loginButton

            Keys.onUpPressed: {
                focusSound.play()
                KeyNavigation.up.forceActiveFocus()
            }
            Keys.onDownPressed: {
                focusSound.play()
                KeyNavigation.down.forceActiveFocus()
            }

            Behavior on width {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            ButtonBackground {
                id: sessionBackground
                anchors.fill: parent
                focused: sessionSelect.activeFocus
                textToDisplay: parent.currentSessionName
                popupOpened: sessionSelect.popupOpened
            }
        }

        SequentialAnimation {
            id: sessionSelectTypewriter

            NumberAnimation {
                target: sessionSelectContainer
                property: "sessionSelectCharIndex"
                from: 0
                to: sessionSelect.currentSessionName.length
                duration: 200
                easing.type: Easing.Linear
            }

            NumberAnimation {
                target: sessionSelectContainer
                property: "sessionSelectCharIndex"
                from: sessionSelect.currentSessionName.length
                to: 200 // Arbitrary large number to ensure it doesn't stop prematurely if the session name changes
            }
        }
    }

    // LOGIN BUTTON
    Item {
        id: login
        height: 75
        width: 453 //TODO: Relative scaling
        anchors.left: parent.left

        property int loginCharIndex: 0
        property real opacityMultiplier: (username.text.length > 0 && password.text.length > 0) ? 1 : 0.6

        Button {
            id: loginButton

            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            opacity: 0

            background: ButtonBackground {
                id: loginBackground
                anchors.fill: parent
                focused: loginButton.activeFocus
                textToDisplay: "Login"
                enabled: username.text.length > 0 && password.text.length > 0
            }

            KeyNavigation.up: sessionSelect
            Keys.onUpPressed: {
                focusSound.play()
                KeyNavigation.up.forceActiveFocus()
            }

            Keys.onReturnPressed: clicked()

            onClicked: if (username.text.length > 0 && password.text.length > 0) {
                closingAnimationDirector.start()

                loginDelayTimer.running ? loginDelayTimer.stop() && loginDelayTimer.start() : loginDelayTimer.start()
            }
        }
    }

    // ERROR FIELD
    Item {
        height: 15 * 2.3
        width: parent.width / 2
        anchors.left: parent.left
        Label {
            id: errorMessage
            width: parent.width
            text: failed ? config.TranslateLoginFailed || textConstants.loginFailed + "!" : keyboard.capsLock ? textConstants.capslockWarning : null
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 15 * 0.8
            font.italic: true
            color: root.palette.text
            opacity: 0
            states: [
                State {
                    name: "fail"
                    when: failed
                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }
                },
                State {
                    name: "capslock"
                    when: keyboard.capsLock
                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity"
                        duration: 100
                    }
                }
            ]
        }
    }

    // Login triggers
    Connections {
        target: sddm
        function onLoginSucceeded() { }
        function onLoginFailed() {
            failed = true
            openingAnimationDirector.start()
            resetError.running ? resetError.stop() && resetError.start() : resetError.start()
        }
    }

    ParallelAnimation {
        id: spawnAnimationSequence

        // USERNAME ANIMATIONS
        SequentialAnimation {
            id: usernameAnimations
            
            ScriptAction {
                script: {
                    usernameBackground.spawn()
                    userCombo.opacity = 1
                }
            }
        }

        // PASSWORD ANIMATIONS
        SequentialAnimation {
            id: passwordAnimations
            
            PauseAnimation { duration: 100 }

            ScriptAction {
                script: {
                    passwordBackground.spawn()
                }
            }
        }

        // SESSION ANIMATIONS
        SequentialAnimation {
            id: sessionAnimations
            
            PauseAnimation { duration: 200 }

            ScriptAction {
                script: {
                    sessionBackground.spawn()
                }
            }
        }

        // LOGIN ANIMATIONS
        SequentialAnimation {
            id: loginAnimations
            
            PauseAnimation { duration: 300 }

            ScriptAction {
                script: {
                    loginBackground.spawn()
                }
            }
        }
    }

    ParallelAnimation {
        id: despawnAnimationSequence

        // USERNAME ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 300 }

            ScriptAction {
                script: {
                    usernameBackground.despawn()
                }
            }
        }

        // PASSWORD ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 200 }

            ScriptAction {
                script: {
                    passwordBackground.despawn()
                }
            }
        }

        // SESSION SELECT ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 100 }

            ScriptAction {
                script: {
                    sessionBackground.despawn()
                }
            }
        }

        // LOGIN ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 000 }

            ScriptAction {
                script: {
                    loginBackground.despawn()
                }
            }
        }
    }

    Timer {
        id: loginDelayTimer
        interval: 800
        running: false
        repeat: false
        onTriggered: sddm.login(username.text, password.text, sessionSelect.selectedSession)
    }

    Timer {
        id: resetError
        interval: 2000
        onTriggered: failed = false
        running: false
    }
}