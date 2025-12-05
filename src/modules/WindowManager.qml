import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls

import qs.lib

Row {
	id: root
	required property var screen

	spacing: 50

	Column {
		id: workspaces

		property int numRows: workspacesCmd.output.length

		property int totalSize: root.parent.height
		property int cellSize: (totalSize - (numRows + 1) * spacing) / numRows
		property real cellRatio: 1920.0 / 1080.0

		spacing: 2

		Repeater {
			model: workspacesCmd.output
			Row {
				spacing: workspaces.spacing
				Repeater {
					model: modelData
					Rectangle {
						property var w: modelData
						width: workspaces.cellSize * workspaces.cellRatio
						height: workspaces.cellSize
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
			id: workspacesCmd
			ListenCmd {
				output: "[]"
				command: [ "wmInterface", "workspaces", `${root.screen.name}` ]
			}
		}
	}

	Row {
		id: windows

		spacing: 1

		property int iconSize: root.parent.height - 2 * spacing
		property int iconPadding: 8

		Repeater {
			model: {
				if (windowsCmd.output.length == 0) return 0
				return Math.max(...windowsCmd.output.map(w => w.x)) + 1
			}
			Row {
				Repeater {
					model: ScriptModel {
						values: windowsCmd.output
							.filter(w => w.x == modelData)
							.sort((a, b) => (a.y - b.y))
					}

					Item {
						width: windows.iconSize
						height: windows.iconSize
						Rectangle {
							anchors.fill: parent
							color: modelData.focused ? "dark gray" : "gray"
							radius: 4
						}

						Image {
							anchors.centerIn: parent
							source: Quickshell.iconPath(DesktopEntries.heuristicLookup(modelData.class).icon)
							height: windows.iconSize - windows.iconPadding
							width: windows.iconSize - windows.iconPadding
						}
					}
				}
			}
		}

		JsonParser {
			id: windowsCmd
			ListenCmd {
				output: "[]"
				command: ["wmInterface", "windows", `${root.screen.name}` ]
			}
		}
	}
}

