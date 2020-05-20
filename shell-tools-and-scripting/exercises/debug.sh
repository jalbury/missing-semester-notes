#!/usr/bin/env bash

run_buggy() {
	bash buggy.sh 1> "run-$count-output.txt" 2> "run-$count-error.txt"
}

count=1
run_buggy $count

while [[ $? -eq 0 ]]; do
	count=$((count+1))
	run_buggy $count
done

echo "After $count runs, we ran into an error"
