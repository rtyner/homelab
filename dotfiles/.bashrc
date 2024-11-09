# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

sudo umount ~/mnt/bdp && sudo umount ~/mnt/red && sudo umount ~/mnt/arch && mount ~/mnt/bdp && mount ~/mnt/red && mount ~/mnt/arch

TERM=xterm-256color
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=5000
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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

if [ "$color_prompt" = yes ]; then
    PS1='\[\e[0m\]# \[\e[0;38;5;214m\]\u\[\e[0m\]@\[\e[0;38;5;214m\]\H \[\e[0m\]| \[\e[0;38;5;214m\]\w \[\e[0m\][\[\e[0m\]\A\[\e[0m\]] \[\e[0m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# some more ls aliases
# fix typos
alias ;s='ls -lah'
alias ks='ls -lah'
alias sl='ls -lah'

# git
alias ga='git add'
alias gp='git push'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gpu='git pull'
alias gcl='git clone'

# misc
alias update='apt-get update -y'
alias update-upgrade='apt-get update && apt-get upgrade -y'
alias install='apt-get install'
alias ..='cd .. && ls'
alias ...='cd ... && ls'
alias v='vim'
alias cls='clear;ls'
alias myip='curl icanhazip.com'
alias ll='ls -lah --color=auto'
alias ls='ls -lh --color=auto'
alias dus='du -sckxh * | sort -nr'

# docker
alias dcd='docker-compose up -d'

# colorize grep output
alias grep='grep --color=auto -n'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi