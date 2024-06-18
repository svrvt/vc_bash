#!/bin/bash

# {{{ Interactive check

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# -------------------------------------------------------------------------- }}}
# {{{ Source global definitions
if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# -------------------------------------------------------------------------- }}}
# {{{ Disable ctrl-s, ctrl-q, and set infinite history.

# stty -ixon
# Allow ctrl-S for history navigation (with ctrl-R)
[[ $- == *i* ]] && stty -ixon

HISTSIZE='' HISTFILESIZE=''

# -------------------------------------------------------------------------- }}}
# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# Define directory exports that my_functions use.

BASHDDIR=$HOME/.config/bash
bash_sourses=("functions" "bash_func" "exports_and_path" "aliases" "completions" "bash_prompt")

for m in "${bash_sourses[@]}"; do
	[[ -f "$BASHDDIR/my_$m" ]] && source "$BASHDDIR/my_$m"
done

# echo "${HOSTNAME} on ${OSTYPE}"

# Automatically added by the Guix install script.
if [ -n "$GUIX_ENVIRONMENT" ]; then
	if [[ $PS1 =~ (.*)"\\$" ]]; then
		PS1="${BASH_REMATCH[1]} [env]\\\$ "
	fi
fi
