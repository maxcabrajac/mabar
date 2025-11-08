pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
	id: root
	readonly property PwNode sink: Pipewire.defaultAudioSink
	readonly property PwNode source: Pipewire.defaultAudioSource
	PwObjectTracker { objects: [ root.sink, root.source ] }

	// helpers
	readonly property var volumeRaw: sink?.audio.volume
	readonly property var volume: Math.round(volumeRaw * 100)
	readonly property var muted: sink?.audio.muted

	readonly property var micVolumeRaw: source?.audio.volume
	readonly property var micVolume: Math.round(micVolumeRaw * 100)
	readonly property var micMuted: source?.audio.muted

	function direction(event: WheelEvent): int {
		return Math.sign(event.angleDelta.y)
	}

	function clamp(x: real, a: real, b: real): real {
		return Math.min(Math.max(a, x), b)
	}

	function wheelAction(event: WheelEvent, delta: real) {
		root.sink.audio.volume = clamp(0, volumeRaw + delta * direction(event), 1.3)
	}

	function micWheelAction(event: WheelEvent, delta: real) {
		root.source.audio.volume = clamp(0, micVolumeRaw + delta * direction(event), 1)
	}
}
