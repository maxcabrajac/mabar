import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls

import qs.lib

Column {
	id: root

	required property var screen

	property int numRows: workspaces.output.length

	property int totalSize: parent.height
	property int cellSize: (totalSize - (numRows + 1) * spacing) / numRows

	spacing: 2

	Repeater {
		model: workspaces.output
		Row {
			spacing: root.spacing
			Repeater {
				model: modelData
				Rectangle {
					property var w: modelData
					width: root.cellSize * (1920 / 1080)
					height: root.cellSize
					radius: 2

					function attr(focused, occupied, empty) {
						if (w.focused) return focused
						if (w.empty) return empty
						return occupied
					}

					color: attr("red", "blue", "dark gray")
				}
			}
		}
	}

	JsonParser {
		id: workspaces
		ListenCmd {
			output: "[]"
			command: [ "wmInterface", "workspaces", `${root.screen.name}` ]
		}
	}
}

