#!/bin/bash

scriptPath="$0"
dotFilesPath="$(dirname $scriptPath)"
echo "Running script: $scriptPath"
echo "dot-files path is at: $dotFilesPath"

echo "Changing location to HOME directory"
pushd ~
echo "Now in: $(pwd)"

rm -f .vimrc
ln -s "${dotFilesPath}/.vimrc" .vimrc

rm -f .ideavimrc
ln -s "${dotFilesPath}/.ideavimrc" .ideavimrc

echo "Done!"
popd
