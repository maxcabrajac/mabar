import Quickshell
import Quickshell.Io
import QtQuick

Scope {
	id: root
	required property list<string> command
	property string output
	property bool running: true
	property string splitMarker: "\n"

	Process {
		id: proc
		command: root.command
		running: root.running
		stdout: SplitParser {
			splitMarker: root.splitMarker
			onRead: (line) => {
				console.log("[ListenCmd] Received event from", command)
				root.output = line
			}
		}
	}
}
