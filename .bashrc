#!/usr/bin/env bash
#    _             _
#   | |__  __ _ __| |_  _ _ __
#  _| '_ \/ _` (_-< ' \| '_/ _|
# (_)_.__/\__,_/__/_||_|_| \__|
#
# bash sources ~/.bashrc automatically for non-login interactive
# shells, including those launched from a GUI. Place local settings in
# ~/.bashrc.local, which is executed at the bottom of this file.

# Source the system-wide config; anything that follows will override.
# Debian bash sources /etc/bash.bashrc (compiled with -DSYS_BASHRC)
# make sure autocomplete directives are un-commented in that file.
[ -r /etc/bashrc ] && . /etc/bashrc  # CentOS

# For when mechanisms override or ignore .profile and .bash_profile
umask 0007
ulimit -c 0  # Disable core dumps

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# set variable to chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
# \e = escape (aka \033)
# \[ .. \] = begin/end nonprinting characters - this helps line-wrapping
# Follow an escape with these codes:
# e.g. echo -e "\e[1mBold \e[34mand blue\e[22mnobold\e[0m"
#   [0m		reset; clears all colors and styles (to white on black)
#
# Styles
#   [1m [22m	bold or intensity
#   [3m [23m	italics on
#   [4m [24m	underline on
#   [9m [29m	strikethrough on
#   [7m [27m	inverse on; reverses foreground & background colors
#
# Colors
#   FG   BG
#   [30m [40m	black
#   [31m [41m	red
#   [32m [42m	green
#   [33m [43m	yellow
#   [34m [44m	blue
#   [35m [45m	magenta
#   [36m [46m	cyan
#   [37m [47m	white
#   [39m [49m	default (white)

case "$TERM" in
*xterm* | *screen* | cygwin | *linux* | cons25 | *gnome* | konsole | *256* )  # These terminals support color
  ROOT_="${debian_chroot:+($debian_chroot)}"
  USER_='\[\e[32m\]\u@\h\[\e[00m\]'
  JOBS_='\[\e[31m\][\j]\[\e[00m\]'
  PATH_='\[\e[33m\]\w\[\e[00m\]'
  HISTNUM_='\[\e[36m\]\!\[\e[00m\]'
  PS1="$ROOT_$USER_$JOBS_:$PATH_\n$HISTNUM_"
  PS2='\[\e[35m\]> \[\e[00m\] '
  ;;
*)
  ROOT_="${debian_chroot:+($debian_chroot)}"
  USER_='\u@\h'
  JOBS_='[\j]'
  PATH_='\w'
  HISTNUM_='\!'
  PS1="$ROOT_$USER_$JOBS_:$PATH_\n$HISTNUM_"
  PS2='> '
  ;;
esac
unset ROOT_ USER_ JOBS_ PATH_ HISTNUM_

# This escape sequence lets the shell give a title to screen. See "info '(screen)Dynamic Titles'".
# It uses <Esc>-k <Esc>-\
case $TERM in
  *screen*)
    SCREENTITLE='\[\ek\e\\\]\[\ek\w\e\\\]'
esac
export PS1="${PS1}${SCREENTITLE}$ "

# if running in a capable terminal, echo the running process to set up the title
case "$TERM" in
  *xterm* | *screen* | cygwin | *gnome* | konsole )  # These terminals parse PROMPT_COMMAND
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
esac

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
  for dc in dircolors gdircolors; do
    [ -r ~/.dircolors ] && dircolors_config=~/.dircolors
    which=$(which $dc 2>/dev/null)
    [ -x "$which" ] && eval $($dc --bourne-shell $dircolors_config)
  done
  unset which dc

  case `uname` in
  FreeBSD | Darwin)
    alias ls='ls -FG'
    alias gls='gls -F --color=auto'
    ;;
  HP-UX)
    alias ls='ls -F'
    ;;
  *)
    alias ls='ls -F --color=auto'
    ;;
  esac
fi

# More ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Colorful GNU Commands
alias grep='grep --color=auto'
alias grepc='grep --color=always'
alias lsc='ls --color=always'
alias dmesg='dmesg --color'
alias dmesgh='dmesg --human'
alias dmesgc='dmesg --color=always'

# "..*" to go to parent directories
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Make destructive commands interactive
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias grm='grm -i'
alias gcp='gcp -i'
alias gmv='gmv -i'
alias gln='gln -i'

# List the 20 most recent history entries, optionally matching $1
histgrep()
{
  if [ -z "$1" ]; then
    history 20
  else
    history | grep $1 |  tail -n 20
  fi

}
alias h=histgrep

dirstack()
{
# Called without arguments, display itemized directory stack
  if [ -z "$1" ]; then
    dirs -v
# Called with a non-numerical argument, eliminate dupes and push it to the top
  elif [ $(echo $1 | grep '[^0-9]') ]; then
    n=$(dirs -v | grep $1 | awk '{ print $1 }')
    if [ "$n" != "" ]; then
      popd -n +$n > /dev/null
    fi
    pushd $1 > /dev/null
    dirs -v
# Called with a numerical argument, pop it and push it on the top
  else
    dir=$(dirs -v | grep "\\<$1\\>" | awk -F'  +' '{ print $2 }')
    popd +$1 > /dev/null
    pushd "$dir" > /dev/null
    dirs -v
  fi
}
alias d=dirstack

alias j='jobs -l'

complete -f -X '!*.@(sfv|SFV|par2|PAR2|par|PAR|md5|MD5|torrent|TORRENT)' cfv
complete -f -X '!*.@(r[a0-9]*|R[A0-9]*)' rar
complete -f -X '!*.@(jpg|JPG|jpeg|JPEG)' exif

# Conditionally make less the pager
less=$(which less 2>/dev/null)
if [ -x "$less" ]; then
  export LESS='--ignore-case --no-init --RAW-CONTROL-CHARS --jump-target=5 --prompt=?f%f:-.?lb line %lb.?L/%L.?e (END):?Pb (%Pb%\\%).?m (file %i of %m).'
  export PAGER='less'

  # make less more friendly for non-text input files, see lesspipe(1)
  [ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
else
  export PAGER='more'
fi

which vim >& /dev/null && export EDITOR=vim || export EDITOR=vi

export BROWSER=elinks
export auto_resume=t    # single word commands are resume candidates

# Don't put duplicates or lines beginning with spaces in history
export HISTCONTROL=ignoreboth
export HISTIGNORE='h:h *:history*'
export HISTFILESIZE=0

# autocd - change to a directory if it's the only command
# cdspell - fix simple misspels in arguments to cd
# checkhash - check to see if command is hashed; search path if no longer found
# checkwinsize - check the window size after each command and
# cmdhist - save multiline commands on one line in history
# histreedit - allow editing of failed history substitution
# nocaseglob - case-insensitive file name completion
# no_empty_cmd_completion - do not complete commands on an empty line,
shopt -s cdspell checkhash checkwinsize cmdhist histreedit nocaseglob no_empty_cmd_completion

# checkjobs - list running jobs on attempt to exit shell
# dirspell - attempt spelling correction when doing directory completion
if [ $BASH_VERSINFO -ge 4 ]; then
  shopt -s autocd checkjobs dirspell
fi

[ -r ~/.bashrc_local ] && . ~/.bashrc_local
