#!/bin/bash

ansible-playbook --ask-become-pass dotfiles.yml -i hosts \
	|| sudo ansible-galaxy install -r requirements.txt --ignore-errors
