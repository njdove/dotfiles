#!/usr/bin/env bash
#
#    _             _                     __ _ _     
#   | |__  __ _ __| |_     _ __ _ _ ___ / _(_) |___ 
#  _| '_ \/ _` (_-< ' \   | '_ \ '_/ _ \  _| | / -_)
# (_)_.__/\__,_/__/_||_|__| .__/_| \___/_| |_|_\___|
#                     |___|_|                       
#
# bash sources ~/.bash_profile for "interactive login shells" - namely
# SSH and text consoles. GUI "interactive non-login shells" use
# ~/.bashrc.

# Add ~/bin to the path
echo $PATH | grep "$HOME/bin" || [ -x "$HOME/bin" ] && PATH=$HOME/bin:${PATH}

# Add the sbin directories
echo $PATH | grep -q sbin || export PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH

umask 0007
ulimit -c 0  # Disable core dumps

# Source .bashrc if it's readable
[ -r ~/.bashrc ] && . ~/.bashrc
