import Quickshell
import Quickshell.Io
import QtQuick

Scope {
	id: root
	property int frequency
	required property list<string> command
	property string output
	property bool running: true

	Process {
		id: proc
		command: root.command
		running: root.running
		stdout: StdioCollector {
			onStreamFinished: root.output = this.text;
		}
	}

	Timer {
		interval: root.frequency
		running: root.running
		repeat: true
		onTriggered: proc.running = true
	}
}
