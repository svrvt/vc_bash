#!/bin/bash
iatest=$(expr index "$-" i)

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

# {{{ Ignore upper and lowercase when TAB completion

# bind "set completion-ignore-case on"
# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi

# -------------------------------------------------------------------------- }}}

# Disable the bell
if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi

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

GIT_HOME=$HOME/aggregate
export GIT_HOME

DOT_SHELL=$GIT_HOME/re_shell
SHELLSOURCE=$DOT_SHELL/config/bash

my_sourses=("functions" "bash_func" "exports_and_path" "aliases" "completions" "bash_prompt")

for m in "${my_sourses[@]}"; do
	[[ -f "$SHELLSOURCE/my_$m" ]] && source "$SHELLSOURCE/my_$m"
done

# echo "${HOSTNAME} on ${OSTYPE}"

if [ -f "/usr/share/autojump/autojump.sh" ]; then
	. /usr/share/autojump/autojump.sh
elif [ -f "/usr/share/autojump/autojump.bash" ]; then
	. /usr/share/autojump/autojump.bash
else
	echo "can't found the autojump script"
fi

# Automatically added by the Guix install script.
if [ -n "$GUIX_ENVIRONMENT" ]; then
    if [[ $PS1 =~ (.*)"\\$" ]]; then
        PS1="${BASH_REMATCH[1]} [env]\\\$ "
    fi
fi

