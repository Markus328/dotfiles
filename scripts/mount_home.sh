#!/bin/bash

DOT=/home/.dotfiles
HOME=/home/markus
hmount(){
	from=$DOT/$1
	target=$HOME/$2
	findmnt $target
	if [ $? -eq 1 ] ; then
	[ -f $target ] || touch $target
	mount --bind $from $target
	fi
}
hmount zsh/.zshrc .zshrc
hmount zsh/.zlogin .zlogin
hmount zsh/zinit .local/share/zinit
hmount .tmux.conf .tmux.conf
hmount util .config/util
hmount nvim .config/nvim
hmount wofi .config/wofi
hmount foot .config/foot
hmount sway .config/sway
hmount hikari .config/hikari
