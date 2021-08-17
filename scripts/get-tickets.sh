#!/bin/bash
die () {
    echo "$@"
	echo "Scrape ticket numbers between two commits (default end is current commit)"
	echo "Usage: $0 <start commit|tag> <end commit|tag or HEAD>"
    exit 1
}

if (( $# == 0)); then
	die "Starting commit/tag required"
else
	startCommit=$1
	endCommit=${2:-HEAD}
fi

currentBranch="$(git rev-parse --abbrev-ref $endCommit)"
startCommitMessage="$(git log --pretty=format:'%h -> %s' -n 1 $startCommit)"
endCommitMessage="$(git log --pretty=format:'%h -> %s' -n 1 $endCommit)"
timestamp="$(date +%y%m%d-%H%M)"

echo -e "Start commit is\t\t($currentBranch) $startCommitMessage"
echo -e "End commit is\t\t($currentBranch) $endCommitMessage"
echo -e "\n**************************************************"
echo "Tickets mentioned between $startCommit and $endCommit:"
git log $startCommit..$endCommit | grep -Eo '([A-Z]{2,}-)([0-9]+)' | sort | uniq
echo "**************************************************"
