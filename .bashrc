# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# dont put duplicate lines in the history and do not add lines that start with a space
HISTCONTROL=erasedups:ignoredups:ignorespace

# Ignore history, ls, ps, and exit commands in history file
HISTIGNORE="&:history;ls:ls * ps:ps -A:[bf]g:exit"

HISTSIZE=2000

# Keep around 128K lines of history in file
HISTFILESIZE=131072

# appeneds to history instead of overwriting
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# lists any stopped or running jobs before exiting. requires two exits
shopt -s checkjobs

# use extra globbing features.ie !(foo), ?(bar|baz)...  See man bash, search extglob
shopt -s extglob

# include .files when globbing or pattern matching
shopt -s dotglob

# when a glob expands to nothing, make it an empty string instead of the literal characters

shopt -s nullglob

# fix spelling errors for cd, only in interactive shell
shopt -s cdspell

# Fix small errors in directory names during completion
shopt -s dirspell

# Check that hashed commands still exist before running them
shopt -s checkhash

# Allow double-start globs to match files and recursive paths
shopt -s globstar

# auto change directory
shopt -s autocd

# Don't assume a word with a @ in it is a hostname
shopt -u hostcomplete

# Don't complete a Tab press on an empty line with every possible command
shopt -s no_empty_cmd_completion

# Use programmable completion, if available
shopt -s progcomp

# protects from accidentally destroy content with the redirect (>) command. ie echo "test" > whatever.txt. Should be overwritable using >|. ie echo "test" >| whatever.txt.
set -o noclobber

s() { # do sudo, or sudo the last command if no arguments given
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;30m\]\u@\h\[\033[00m\]:\[\033[01;30m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;31m\]\w\[\033[00m\]\$ '
fi
unset color_prompt force_color_prompt

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi

if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dicolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias ll='ls -lha --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# alias to exit due to my fat fingering
alias exi="exit"
alias exti="exit"

# Changes dir color in terminal or tty (30:black, 31:red, 32:green, 33:yellow, 34:blue, 35:purple, 36:cyan, 37:white)
# Use di=1;4;33 to make it (1) bold, (4) underlined, and (33) yellow
LS_COLORS="di=1;33"

# move and go to the directory
mvg ()
{
    if [ -d "$2" ];then
        mv $1 $2 && cd $2
    else
        mv $1 $2
    fi
}

# Used for GoLang
export GOPATH=$HOME/go
export GOROOT=/usr/lib/go
export PATH="${GOPATH}/bin:${PATH}"

screenfetch 
