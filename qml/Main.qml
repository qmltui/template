pragma ComponentBehavior: Bound
import QtQml
import QmlTui
import QmlTui.Controls

Terminal {
    id: root

    title: controller.count === 0 ? "MyApp" : "MyApp (" + controller.count + ")"
    color: "#0d1117"

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Q || event.key === Qt.Key_Escape) {
            event.accepted = true;
            Qt.quit();
        }
    }

    AppController {
        id: controller
    }

    Shortcut {
        sequence: "Ctrl+R"
        onActivated: controller.reset()
    }

    Panel {
        id: mainPanel
        objectName: "mainPanel"
        anchors.centerIn: parent
        width: Math.min(54, Math.max(36, root.width - 4))
        height: 11
        color: "#0d1117"
        border {
            style: Border.Single
            color: "#2cde85"
        }
        title: Text {
            text: "MyApp"
            color: "#00ff66"
            bold: true
        }
        footer: Text {
            text: "[Tab] Focus  [Ctrl+R] Reset  [Q] Quit"
            color: "#8b949e"
            dim: true
        }

        Column {
            anchors.centerIn: parent
            spacing: 1

            Text {
                text: "QmlTui Starter Application"
                color: "#c9d1d9"
                bold: true
            }

            Row {
                spacing: 2

                Button {
                    objectName: "incrementButton"
                    text: "Increment (+1)"
                    focus: true
                    color: "#0d1117"
                    borderColor: "#2cde85"
                    textColor: "#00ff66"
                    onClicked: controller.increment()
                }

                Button {
                    objectName: "resetButton"
                    text: "Reset"
                    enabled: controller.count > 0
                    color: "#0d1117"
                    borderColor: "#58a6ff"
                    textColor: "#c9d1d9"
                    onClicked: controller.reset()
                }
            }

            Text {
                objectName: "statusText"
                text: "Status: " + controller.status
                color: controller.count === 0 ? "#8b949e" : "#39c5cf"
            }
        }
    }
}
