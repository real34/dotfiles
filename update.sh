#!/bin/bash

TAGS=''
if [ ! -z $1 ]; then
	TAGS="--tags=$1"
fi

ansible-playbook --ask-become-pass dotfiles.yml -i hosts $TAGS \
	|| sudo ansible-galaxy install -r requirements.txt --ignore-errors
