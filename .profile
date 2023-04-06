# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 0027
ulimit -c 0  # Disable core dumps

# Source ~/.bashrc if running bash
if [ -n "$BASH_VERSION" ]; then
    [ -r ~/.bashrc ] && . ~/.bashrc
fi

# Prepend ~/.local/bin to the path -- this is the directory pipx uses for virtual installs
echo $PATH | grep -q "$HOME/.local/bin" || [ -x "$HOME/.local/bin" ] && PATH=$HOME/.local/bin:${PATH}

# Prepend ~/bin to the path
echo $PATH | grep -q "$HOME/bin" || [ -x "$HOME/bin" ] && PATH=$HOME/bin:${PATH}

# Append sbin directories
echo $PATH | grep -q sbin || export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
