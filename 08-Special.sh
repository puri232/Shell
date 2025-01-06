#!/bin/bash


echo "all variable passed :: $@"
echo "number of variables:: $#"
echo "Script name: $0"
echo "Presnt working Directory: $PWD"
echo "which user is running the script: $USER"
echo "home directory of user $HOME"
echo "Process ID of current script $$"
sleep 60 &
echo "Porcess id of last command in background:  $!"