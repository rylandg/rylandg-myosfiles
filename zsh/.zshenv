export ZDOTDIR=$HOME/.zsh_config
export ZIM_HOME=$HOME/.zim
export HISTFILE=$HOME/.zhistory
export DEFAULT_USER=`whoami`

export MYVIMRC=/home/ubuntu/.vim_runtime/vimrc
export VIMINIT="source ~/.vim_runtime/vimrc"
export VIM_PLUGIN_PATH=$HOME/.vim_runtime/plugins.vim
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=99'

export TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins/

eval `ssh-agent -s`
grep -slR "PRIVATE" ~/.ssh_host/ | xargs ssh-add

mkdir -p $HOME/.vim_runtime
chown -R $USER:$USER $HOME/.vim_runtime
mkdir -p $HOME/.config
chown -R $USER:$USER $HOME/.config

if [ ! -d $ZIM_HOME ]; then
  mkdir -p $HOME/.zim/
  curl -sL https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh --output $HOME/.zim/zimfw.zsh
  # Define Zim location
  # }}} End configuration added by Zim install
  chown -R $USER:$USER $HOME/.zim
  source $HOME/.zim/zimfw.zsh install

  #mkdir $HOME/.zim
  #chown -R $USER:$USER $HOME/.zim
  #ls -al $HOME
  #curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
  # git clone ---recursive 
  # ZIM_HOME has issues being auto set during build
  # Install Zim, which acts as our base zsh framework
  # git clone --recursive https://github.com/zimfw/zimfw.git $ZIM_HOME
  sed -i 's/${USER}@%m/${USER}/' $HOME/.zim/modules/eriner/eriner.zsh-theme
fi

if [ ! -d $HOME/.zsh/zsh-autosuggestions ]; then
  # Add autocomplete functionality to the zsh command line
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

if [ ! -d $HOME/.fzf ]; then
  echo "fzf is not a directory"
  # Add fuzzy search to zsh (ctrl-r)
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  $HOME/.fzf/install --all
fi

if [ ! -d $HOME/.tmux/plugins/tpm ]; then
  # Install tmux plugin manager
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  # We add this file now to take advantage of build time plugin install
  ~/.tmux/plugins/tpm/bin/install_plugins
fi

if [ ! -f $HOME/.vim/autoload/plug.vim ]; then
  # Install vim-plug as our default package manager
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  
  # This is the easiest way to install with VimPlug from the command line
  vimcmd="vim -E -s -u "${VIM_PLUGIN_PATH}" +PlugInstall +qall"
  #vimcmd="vim +PlugInstall +qall > /dev/null"
  env - HOME="$HOME" USER="$USER" PATH=/usr/bin:/bin /bin/sh -c $vimcmd </dev/null > job.log 2>&1
  ~/.vim_runtime/install_coc_plugins.sh
fi
