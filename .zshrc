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
alias dc=docker-compose
alias dcr='docker-compose run --rm'
alias copy="xclip -selection c"
alias y=yarn
alias deploy='docker run -it --rm -v ~/.ssh:/root/.ssh -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -v $(pwd):/source neolao/capistrano:3.4.0 bash'

alias bepo='setxkbmap -layout fr -variant bepo'
alias fr='setxkbmap -layout fr -variant oss'

alias m='make'

drm()  { docker rm $(docker ps -qa); }
drme() { docker rm $(docker ps -qa --filter 'status=exited'); }
dri()  { docker rmi $(docker images -q --filter "dangling=true"); }
dgo() { docker exec -ti $@ bash }
dip()  { docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"; }
dcrefresh() {
	dc stop -t0 $1 && dc rm -vf --all $1 && dc up -d $1
}

bundle()  {
        BUNDLE_CMD=$@
        docker run -ti --rm --name bundle-${PWD##*/} \
                -v $HOME/.ssh:/root/.ssh \
                -v $(pwd):/app -w /app \
                -e BUNDLE_APP_CONFIG=/app/.bundle \
                ruby:2.2 bash -c "eval \`ssh-agent\` && ssh-add && bundle $BUNDLE_CMD";
}

mysql()  { docker run -ti --user 1000:1000 --rm mysql:5.6 mysql $@; }

caddy() {
	docker run -d --user 1000:1000 -v $(pwd):/srv --name caddy-${PWD##*/} -e VIRTUAL_PORT=2015 -e VIRTUAL_HOST=${PWD##*/}.test -P abiosoft/caddy
}

ngrok() {
  docker run --rm -it --link "$1":http wernight/ngrok ngrok http http:"$2"
}

ctop() {
  docker run -ti -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest
}

jq() {
  docker run -i pinterb/jq:latest $@
}