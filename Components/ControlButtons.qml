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

import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import SddmComponents 2.0 as SDDM

ColumnLayout {
    property bool canSuspend: sddm.canSuspend
    property bool canHibernate: sddm.canHibernate
    property bool canReboot: sddm.canReboot
    property bool canHybridSleep: sddm.canHybridSleep
    property bool canShutdown: sddm.canPowerOff

    spacing: 0

    required property PanelButton controlPanelButton
    required property Item modalBox
    required property Item systemModal

    property int focusedButtonIndex: suspend.activeFocus ? 0 : hibernate.activeFocus ? 1 : reboot.activeFocus ? 2 : hybridSleep.activeFocus ? 3 : shutdown.activeFocus ? 4 : 5

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
        width: 453

        // BUTTON
        Button {
            id: suspend

            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            background: ButtonBackground {
                id: suspendBackground
                focused: suspend.activeFocus
                textToDisplay: "Suspend"
                enabled: canSuspend
            }

            onClicked: {
                if (!canSuspend) return //TODO: Play error sfx
                systemModal.text = "Suspend the system?"
                modalBox.visible = true
                systemModal.cancelButton.forceActiveFocus()

                modalBox.onConfirmCallback = function() {
                    modalBox.visible = false
                    closingAnimationDirector.start()
                    systemDelayTimer.callback = sddm.suspend()
                    systemDelayTimer.running ? systemDelayTimer.stop() && systemDelayTimer.start() : systemDelayTimer.start()
                }
                modalBox.onCancelCallback = function() {
                    modalBox.visible = false
                    suspend.forceActiveFocus()
                }
            }

            KeyNavigation.up: controlPanelButton.button

            Keys.onReturnPressed: clicked()

            Keys.onUpPressed: {
                focusSound.play()
                controlPanelButton.button.forceActiveFocus()
            }

            Keys.onDownPressed: {
                focusSound.play()
                hibernate.forceActiveFocus()
            }
        }
    }

    // Hibernate Button
    Item {
        id: hibernateButton

        property int typewriterCharIndex: 0
        property real opacityMultiplier: hibernate[2] ? 1 : 0.6

        height: 75
        width: 453

        // BUTTON
        Button {
            id: hibernate

            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            background: ButtonBackground {
                id: hibernateBackground
                focused: hibernate.activeFocus
                textToDisplay: "Hibernate"
                enabled: canHibernate
            }

            onClicked: {
                if (!canHibernate) return //TODO: Play error sfx
                systemModal.text = "Hibernate the system?"
                modalBox.visible = true
                systemModal.cancelButton.forceActiveFocus()

                modalBox.onConfirmCallback = function() {
                    modalBox.visible = false
                    closingAnimationDirector.start()
                    systemDelayTimer.callback = sddm.hibernate()
                    systemDelayTimer.running ? systemDelayTimer.stop() && systemDelayTimer.start() : systemDelayTimer.start()
                }
                modalBox.onCancelCallback = function() {
                    modalBox.visible = false
                    hibernate.forceActiveFocus()
                }
            }

            Keys.onReturnPressed: clicked()

            Keys.onUpPressed: {
                focusSound.play()
                suspend.forceActiveFocus()
            }

            Keys.onDownPressed: {
                focusSound.play()
                reboot.forceActiveFocus()
            }
        }
    }

    // Reboot Button
    Item {
        id: rebootButton

        property real opacityMultiplier: reboot[2] ? 1 : 0.6

        height: 75
        width: 453

        Button {
            id: reboot

            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            background: ButtonBackground {
                id: rebootBackground
                focused: reboot.activeFocus
                textToDisplay: "Reboot"
                enabled: canReboot
            }

            onClicked: {
                if (!canReboot) return //TODO: Play error sfx
                systemModal.text = "Reboot the system?"
                modalBox.visible = true
                systemModal.cancelButton.forceActiveFocus()

                modalBox.onConfirmCallback = function() {
                    modalBox.visible = false
                    closingAnimationDirector.start()
                    systemDelayTimer.callback = sddm.reboot()
                    systemDelayTimer.running ? systemDelayTimer.stop() && systemDelayTimer.start() : systemDelayTimer.start()
                }
                modalBox.onCancelCallback = function() {
                    modalBox.visible = false
                    reboot.forceActiveFocus()
                }
            }

            Keys.onReturnPressed: clicked()

            Keys.onUpPressed: {
                focusSound.play()
                hibernate.forceActiveFocus()
            }
            Keys.onDownPressed: {
                focusSound.play()
                hybridSleep.forceActiveFocus()
            }
        }
    }

    // Hybrid Sleep Button
    Item {
        id: hybridSleepButton

        property real opacityMultiplier: hybridSleep[2] ? 1 : 0.6

        height: 75
        width: 453

        Button {
            id: hybridSleep

            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            background: ButtonBackground {
                id: hybridSleepBackground
                focused: hybridSleep.activeFocus
                textToDisplay: "Hybrid Sleep"
                enabled: canHybridSleep
            }

            onClicked: {
                if (!canHybridSleep) return //TODO: Play error sfx
                systemModal.text = "Initiate Hybrid Sleep?"
                modalBox.visible = true
                systemModal.cancelButton.forceActiveFocus()

                modalBox.onConfirmCallback = function() {
                    modalBox.visible = false
                    closingAnimationDirector.start()
                    systemDelayTimer.callback = sddm.hybridSleep()
                    systemDelayTimer.running ? systemDelayTimer.stop() && systemDelayTimer.start() : systemDelayTimer.start()
                }
                modalBox.onCancelCallback = function() {
                    modalBox.visible = false
                    hybridSleep.forceActiveFocus()
                }
            }

            Keys.onReturnPressed: clicked()

            Keys.onUpPressed: {
                focusSound.play()
                reboot.forceActiveFocus()
            }
            Keys.onDownPressed: {
                focusSound.play()
                shutdown.forceActiveFocus()
            }
        }
    }

    // Shutdown Button
    Item {
        id: shutdownButton

        property int typewriterCharIndex: 0
        property real opacityMultiplier: shutdown[2] ? 1 : 0.6

        height: 75
        width: 453

        // BUTTON
        Button {
            id: shutdown

            width: parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            background: ButtonBackground {
                id: shutdownBackground
                focused: shutdown.activeFocus
                textToDisplay: "Shutdown"
                enabled: canShutdown
            }

            onClicked: {
                if (!canShutdown) return //TODO: Play error sfx
                systemModal.text = "Shutdown the system?"
                modalBox.visible = true
                systemModal.cancelButton.forceActiveFocus()

                modalBox.onConfirmCallback = function() {
                    modalBox.visible = false
                    closingAnimationDirector.start()
                    systemDelayTimer.callback = sddm.shutdown()
                    systemDelayTimer.running ? systemDelayTimer.stop() && systemDelayTimer.start() : systemDelayTimer.start()
                }
                modalBox.onCancelCallback = function() {
                    modalBox.visible = false
                    shutdown.forceActiveFocus()
                }
            }

            Keys.onReturnPressed: clicked()

            Keys.onUpPressed: {
                focusSound.play()
                hybridSleep.forceActiveFocus()
            }
        }
    }

    Timer {
        id: systemDelayTimer
        interval: 800
        repeat: false
        running: false
        onTriggered: if (callback) callback()
    }

    ParallelAnimation {
        id: spawnAnimationSequence

        // REBOOT ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 000 }

            ParallelAnimation {
                ScriptAction {
                    script: {
                        suspendBackground.spawn()
                    }
                }
            }
        }

        // HIBERNATE ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 100 }

            ParallelAnimation {
                ScriptAction {
                    script: {
                        hibernateBackground.spawn()
                    }
                }
            }
        }

        // REBOOT ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 200 }

            ParallelAnimation {
                ScriptAction {
                    script: {
                        rebootBackground.spawn()
                    }
                }
            }
        }

        // HYBRID SLEEP ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 300 }

            ParallelAnimation {
                ScriptAction {
                    script: {
                        hybridSleepBackground.spawn()
                    }
                }
            }
        }

        // SHUTDOWN ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 400 }
            
            ParallelAnimation {
                ScriptAction {
                    script: {
                        shutdownBackground.spawn()
                    }
                }
            }
        }
    }

    ParallelAnimation {
        id: despawnAnimationSequence

        // SUSPEND BUTTON ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 400 }

            ScriptAction {
                script: {
                    suspendBackground.despawn()
                }
            }
        }

        // HIBERNATE BUTTON ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 300 }

            ScriptAction {
                script: {
                    hibernateBackground.despawn()
                }
            }
        }

        // REBOOT BUTTON ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 200 }

            ScriptAction {
                script: {
                    rebootBackground.despawn()
                }
            }
        }

        // HYBRID SLEEP BUTTON ANIMATIONS
        SequentialAnimation {
            PauseAnimation { duration: 100 }

            ScriptAction {
                script: {
                    hybridSleepBackground.despawn()
                }
            }
        }

        // SHUTDOWN BUTTON ANIMATIONS
        SequentialAnimation {
            ScriptAction {
                script: {
                    shutdownBackground.despawn()
                }
            }
        }
    }
}
