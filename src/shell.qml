//@ pragma UseQApplication

import Quickshell

import "lib"
import "modules"

Scope {
	Variants {
		model: Quickshell.screens;

		TreeSectionBar {
			color: "gray"
			anchors {
				top: true
				left: true
				right: true
			}
			spacing: 0

			required property var modelData
			screen: modelData

			implicitHeight: 30

			left: [
				WindowManager {
					screen: modelData
				}
			]

			center: [
				Clock {}
			]

			right: [
				Volume {},
				Tray {}
			]
		}
	}
}
