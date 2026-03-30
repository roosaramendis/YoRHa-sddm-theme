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
import QtMultimedia 5.11

Item {
    id: modalRoot

    anchors.centerIn: parent

    height: 356
    width: 780

    signal confirmed()
    signal cancelled()

    property alias confirmButton: confirmButton
    property alias text: messageText.text

    SoundEffect {
        id: focusSound
        source: Qt.resolvedUrl("../Assets/sfx/focus.wav")
        volume: 1
    }

    Rectangle {
        anchors.fill: parent
        color: root.palette.highlight
        opacity: 1
    }

    // HEADER
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: 48

        color: "#B2000000"

        Rectangle {
            id: modalSquare

            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.top: parent.top

            anchors.leftMargin: 12
            anchors.bottomMargin: 12
            anchors.topMargin: 12

            width: height

            color: root.palette.highlight
            opacity: 1
        }

        Text {
            anchors.left: modalSquare.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12

            text: "SYSTEM MESSAGE"
            font.pointSize: 15
            font.family: root.fontFamily
            font.letterSpacing: 8

            color: root.palette.highlight
        }
    }

    // MESSAGE
    Text {
        id: messageText
        
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.leftMargin: 24
        anchors.rightMargin: 24
        anchors.topMargin: 72
        anchors.bottomMargin: 72

        text: "This is a system message. If you are seeing this message, you are either debugging successfully or something went wrong. This Module should be called by setting this text to something meaningful and connecting to the provided signal"
        wrapMode: Text.WordWrap
        font.pointSize: 16
        font.family: root.fontFamily

        color: root.palette.text
    }

    // SEPARATOR
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: buttonsContainer.top

        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.bottomMargin: 31

        height: 2

        color: root.palette.button
    }

    // BUTTONS
    Item {
        id: buttonsContainer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: 132
        anchors.rightMargin: 132
        anchors.bottomMargin: 31

        height: 48

        Button {
            id: confirmButton
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.top: parent.top

            width: 180

            Image {
                anchors.right: parent.left
                anchors.verticalCenter: parent.verticalCenter

                anchors.rightMargin: 12

                source: Qt.resolvedUrl("../Assets/focus_pointer.png")

                opacity: confirmButton.activeFocus ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            Rectangle {
                id: confirmSquare

                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.top: parent.top

                anchors.leftMargin: 12
                anchors.bottomMargin: 12
                anchors.topMargin: 12

                width: height

                color: root.palette.text

            }

            Text {
                id: confirmText

                anchors.left: confirmSquare.right
                anchors.verticalCenter: parent.verticalCenter
                
                anchors.leftMargin: 12

                text: "Yes"
                font.pointSize: 15
                font.family: root.fontFamily

                color: root.palette.text
            }

            background: Item {
                id: confirmBackground

                Rectangle {
                    anchors.fill: parent
                    color: root.palette.button
                    opacity: 1
                }

                Rectangle {
                    id: confirmDarkener
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
                        enabled: !confirmDarkener.width > 0 // Fire animation only when expanding, not collapsing
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

            states: [
                State {
                    name: "focused"
                    when: confirmButton.activeFocus

                    PropertyChanges {
                        target: confirmText
                        color: root.palette.highlight
                    }

                    PropertyChanges {
                        target: confirmDarkener
                        opacity: 0.5
                        width: parent.width
                    }

                    PropertyChanges {
                        target: confirmBackground
                        layer.enabled: true
                    }

                    PropertyChanges {
                        target: confirmSquare
                        color: root.palette.highlight
                    }
                }
            ]

            Keys.onRightPressed: {
                focusSound.play()
                cancelButton.forceActiveFocus()
            }

            Keys.onReturnPressed: {
                confirmButton.clicked()
            }

            onClicked: {
                confirmed()
            }
        }

        Button {
            id: cancelButton
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top

            width: 180

            Image {
                anchors.right: parent.left
                anchors.verticalCenter: parent.verticalCenter

                anchors.rightMargin: 12

                source: Qt.resolvedUrl("../Assets/focus_pointer.png")

                opacity: cancelButton.activeFocus ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            Rectangle {
                id: cancelSquare

                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.top: parent.top

                anchors.leftMargin: 12
                anchors.bottomMargin: 12
                anchors.topMargin: 12

                width: height

                color: root.palette.text

            }

            Text {
                id: cancelText

                anchors.left: cancelSquare.right
                anchors.verticalCenter: parent.verticalCenter
                
                anchors.leftMargin: 12

                text: "No"
                font.pointSize: 15
                font.family: root.fontFamily

                color: root.palette.text
            }

            background: Item {
                id: cancelBackground

                Rectangle {
                    anchors.fill: parent
                    color: root.palette.button
                    opacity: 1
                }

                Rectangle {
                    id: cancelDarkener
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
                        enabled: !cancelDarkener.width > 0 // Fire animation only when expanding, not collapsing
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

            states: [
                State {
                    name: "focused"
                    when: cancelButton.activeFocus

                    PropertyChanges {
                        target: cancelText
                        color: root.palette.highlight
                    }

                    PropertyChanges {
                        target: cancelDarkener
                        opacity: 0.5
                        width: parent.width
                    }

                    PropertyChanges {
                        target: cancelBackground
                        layer.enabled: true
                    }

                    PropertyChanges {
                        target: cancelSquare
                        color: root.palette.highlight
                    }
                }
            ]

            Keys.onLeftPressed: {
                focusSound.play()
                confirmButton.forceActiveFocus()
            }

            Keys.onReturnPressed: {
                cancelButton.clicked()
            }

            onClicked: {
                cancelled()
            }
        }
    }
}