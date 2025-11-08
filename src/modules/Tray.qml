import Quickshell
import QtQuick

import Quickshell.Services.SystemTray

Row {
	id: root
	spacing: 5
	Repeater {
		model: SystemTray.items

		Image {
			source: modelData.icon
			width: 20
			height: 20

			MouseArea {
				anchors.fill: parent
				acceptedButtons: Qt.LeftButton | Qt.RightButton
				onClicked: event => {
					let win = root.QsWindow?.window
					if (event.button === Qt.LeftButton) {
						modelData.activate();
					} else if (event.button === Qt.RightButton) {
						if (modelData.hasMenu) {
							// TODO: Swap this display for something stylish
							modelData.display(
								win,
								win.width,
								win.height
							);
						}
					}
					event.accepted = true;
				}
			}
		}
	}
}
