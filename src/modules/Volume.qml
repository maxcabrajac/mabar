import Quickshell
import Quickshell.Widgets

import qs.singletons

import QtQuick

Row {
	spacing: 3
	Repeater {
		model: [
			{ vol: Audio.volume, onWheel: Audio.wheelAction },
			{ vol: Audio.micVolume, onWheel: Audio.micWheelAction }
		]

		WrapperMouseArea {
			required property var modelData

			Text {
				text: `${modelData.vol}%`
			}

			onWheel: (event) => {
				modelData.onWheel(event, 0.01)
				event.accepted = true
			}
		}
	}
}
