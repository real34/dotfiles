# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-flow capistrano docker fasd ssh-agent)

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Convenient aliases
alias http='docker run -it --rm --name http-${PWD##*/} --net=host clue/httpie'
alias dc=docker-compose
alias copy="xclip -selection c"
alias composer='docker run -ti --rm --name composer-${PWD##*/} -v $(pwd):/app composer/composer'
alias npm='docker run -ti --rm --name npm-${PWD##*/} -v `pwd`:/project -w /project node:4.1.1 npm'

drm()  { docker rm $(docker ps -qa); }
drme() { docker rm $(docker ps -qa --filter 'status=exited'); }
dri()  { docker rmi $(docker images -q --filter "dangling=true"); }
dgo() { docker exec -ti $@ bash }
dip()  { docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"; }

dcrefresh() {
	dc stop $1 && dc rm -v -f $1 && dc up -d $1
}