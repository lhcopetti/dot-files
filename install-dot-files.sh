#!/bin/bash

scriptPath="$0"
echo "Running script: $scriptPath"

if [ "$(uname)" == "Linux" ]; then
	dotFilesPath="$(readlink -f $scriptPath | xargs dirname)"
else
    dotFilesPath="$(dirname $scriptPath)"
fi

echo "dot-files path is at: $dotFilesPath"

if [ "$dotFilesPath" == "." ]; then
	echo "This is probably an error. Double check the output dot-files path because it should contain the full path to the dot-files directory from root /"
	exit 1;
fi

echo "Changing location to HOME directory"
pushd ~
echo "Now in: $(pwd)"

rm -f .vimrc
ln -s "${dotFilesPath}/.vimrc" .vimrc

rm -f .ideavimrc
ln -s "${dotFilesPath}/.ideavimrc" .ideavimrc

echo "Done!"
popd
