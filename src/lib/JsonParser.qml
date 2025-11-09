import Quickshell

Scope {
	default required property var input
	readonly property var output: {
		return JSON.parse(input.output)
	}
}
