import QtQuick 2.11
import QtQuick.Layouts 1.11
import SddmComponents 2.0 as SDDM
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

ColumnLayout {
    id: formContainer
    anchors.fill: parent
    anchors.leftMargin: 63  // Add padding inside the background rectangle
    anchors.rightMargin: 63

    SDDM.TextConstants { id: textConstants }

    property int p: config.ScreenPadding
    property string a: config.FormPosition

    FontLoader {
        id: rodinFont
        source: Qt.resolvedUrl("../fonts/Rodin_Pro_DB.otf") // TODO: Get the correct font (RodinPro M)
    }    

    property string fontFamily: rodinFont.name || "Arial"

    spacing: 20  // Add spacing between sections

    // HEADER - Simple text with HeaderText aligned to the left
    Item {
        id: header
        Layout.fillWidth: true
        Layout.preferredHeight: 60

        Text {
            id: headerText
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: "START SESSION"
            font.family: formContainer.fontFamily
            font.pointSize: root.font.pointSize * 3
            color: "#34332B"
            opacity: 0.8

            layer.enabled: true
            layer.effect: DropShadow {
                anchors.fill: headerText
                horizontalOffset: 5
                verticalOffset: 5
                radius: 0
                samples: 16
                color: "#45000000"
            }
        }
    }

    Row {
        width: parent.width
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        Layout.fillWidth: true
        Layout.preferredHeight: root.height / 10
        Layout.leftMargin: 10
        // INPUT - Input fields aligned to the left
        Input {
            id: input
            anchors.verticalCenter: parent.verticalCenter
            fontFamily: formContainer.fontFamily
        }

        Item {
            id: avatarContainer
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 440
            height: 540

            Rectangle {
                id: avatarBackground
                anchors.fill: parent
                color: "#D5CFAF"

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 4
                    verticalOffset: 4
                    radius: 0
                    samples: 17
                    color: "#45000000"
                }
            }

            Image {
                
            }

            Image {
                id: yorhaLogo
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.margins: 20

                source: Qt.resolvedUrl("../Assets/yorha_logo.png")
                
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    // INFOBOARD - Box with current time and date, fills horizontally
    Rectangle {
        id: infoBoard
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 110

        Layout.fillWidth: true
        Layout.preferredHeight: 80

        color: "#D5CFAF"

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
            anchors.fill: parent
            anchors.leftMargin: 60

            Row {  // Time & Date
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 15
                spacing: 20

                // DATE
                Text {
                    id: currentDate
                    anchors.verticalCenter: parent.verticalCenter
                    text: Qt.formatDate(new Date(), config.DateFormat || "dddd, MMMM d, yyyy")
                    font.pointSize: root.font.pointSize * 1.2
                    font.family: formContainer.fontFamily
                    color: "#34332B"
                    opacity: 0.8
                }

                // Separator
                Rectangle {
                    width: 2
                    height: parent.height * 0.7
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#34332B"
                    opacity: 0.8
                }

                // TIME
                Text {
                    id: currentTime
                    anchors.verticalCenter: parent.verticalCenter
                    text: Qt.formatTime(new Date(), "HH:mm")
                    font.pointSize: root.font.pointSize * 1.2
                    font.family: formContainer.fontFamily
                    color: "#34332B"
                    opacity: 0.8
                }

                // Separator
                Rectangle {
                    width: 2
                    height: parent.height * 0.7
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#34332B"
                    opacity: 0.8
                }

                // Optional: System info section
                Text {
                    text: sddm.hostName || "YoRHa System"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: root.font.pointSize * 1.2
                    font.family: formContainer.fontFamily
                    color: "#34332B"
                    opacity: 0.8
                }
            }

            SystemButtons {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 60
                exposedLogin: input.exposeLogin
                spacing: 20
            }
        }

        // Timer to update time every second
        Timer {
            interval: 1000
            repeat: true
            running: true
            onTriggered: {
                currentTime.text = Qt.formatTime(new Date(), config.HourFormat == "12" ? "hh:mm AP" : "HH:mm")
                currentDate.text = Qt.formatDate(new Date(), config.DateFormat || "dddd, MMMM d, yyyy")
            }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 4
            verticalOffset: 4
            radius: 0
            samples: 17
            color: "#45000000"
        }
    }
}