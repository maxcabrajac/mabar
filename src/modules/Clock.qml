import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls

Button {
	property bool verbose: true
	onClicked: verbose = !verbose

	text: Qt.formatDateTime(clk.date, verbose ? "dd MMM yyyy hh:mm": "hh:mm")
	SystemClock {
		id: clk
		precision: SystemClock.Minutes
	}
}
