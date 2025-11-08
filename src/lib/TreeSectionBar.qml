import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
	id: r
	property list<Item> left
	property list<Item> center
	property list<Item> right
	property int spacing: 0

	RowLayout {
		spacing: r.spacing
		layoutDirection: Qt.LeftToRight
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom

		children: r.left
	}

	RowLayout {
		spacing: r.spacing
		layoutDirection: Qt.LeftToRight
		anchors.centerIn: parent
		height: parent.height

		children: r.center
	}

	RowLayout {
		spacing: r.spacing
		layoutDirection: Qt.LeftToRight
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: parent.bottom

		children: r.right
	}
}
