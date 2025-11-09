random_workspace_permutation() {
	(
		focused='{"focused": true, "empty": false}'
		occupied='{"focused": false, "empty": false}'
		empty='{"focused": false, "empty": true}'

		echo "$focused"
		for _ in $(seq 4); do
			echo "$occupied"
		done
		for _ in $(seq 5); do
			echo "$empty"
		done
	) | shuf
}

workspaces() {
	random_workspace_permutation | jq --slurp --compact-output '. | [.[:5], .[5:]]'
}

while true; do
	$1
	sleep 5
done
