#!/bin/zsh

mkdir -p $HOME/docker_work/persist

cat '#!/bin/zsh' > $HOME/docker_work/run.sh
cat 'sed -i "s/autoload -Uz bracketed-paste-magic/#autoload -Uz bracketed-paste-magic/" ~/.oh-my-zsh/lib/misc.zsh' > $HOME/docker_work/run.sh
cat 'sed -i "s/zle -N bracketed-paste bracketed-paste-magic/#zle -N bracketed-paste bracketed-paste-magic/" ~/.oh-my-zsh/lib/misc.zsh ' > $HOME/docker_work/run.sh
cat 'sed -i "s/autoload -Uz url-quote-magic/#autoload -Uz url-quote-magic/" ~/.oh-my-zsh/lib/misc.zsh ' > $HOME/docker_work/run.sh
cat 'sed -i "s/zle -N self-insert url-quote-magic/#zle -N self-insert url-quote-magic/" ~/.oh-my-zsh/lib/misc.zsh ' > $HOME/docker_work/run.sh