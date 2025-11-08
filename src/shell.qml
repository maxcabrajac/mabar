import Quickshell
import Quickshell.Io
import QtQuick

import "lib"

Scope {
	Variants {
		model: Quickshell.screens;

		PanelWindow {
			anchors {
				top: true
				left: true
				right: true
			}

			required property var modelData

			screen: modelData

			implicitHeight: 30

			Text {
				// center the bar in its parent component (the window)
				anchors.centerIn: parent
				text: date.output
			}
		}
	}

	PollCmd {
		id: date
		command: ["date", "+%s"]
		frequency: 1000
	}
}
