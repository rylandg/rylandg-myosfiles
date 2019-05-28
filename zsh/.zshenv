export ZDOTDIR=$HOME/.zsh_config
export ZIM_HOME=$HOME/.zim
export HISTFILE=$HOME/.zhistory
export DEFAULT_USER=`whoami`

export MYVIMRC=${HOME}/.vim_runtime/vimrc
export VIMINIT=":set runtimepath+=$HOME/.vim|:source $MYVIMRC"
export VIM_PLUGIN_PATH=$HOME/.vim_runtime/plugins.vim

export TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins/

if [ ! -d $ZIM_HOME ]; then
  # ZIM_HOME has issues being auto set during build
  # Install Zim, which acts as our base zsh framework
  git clone --recursive https://github.com/zimfw/zimfw.git $ZIM_HOME
  sed -i 's/${USER}@%m/${USER}/' $HOME/.zim/modules/prompt/themes/eriner.zsh-theme
fi

if [ ! -d $HOME/.zsh/zsh-autosuggestions ]; then
  # Add autocomplete functionality to the zsh command line
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

if [ ! -d $HOME/.fzf ]; then
  # Add fuzzy search to zsh (ctrl-r)
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
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
  env - HOME="$HOME" USER="$USER" PATH=/usr/bin:/bin /bin/sh -c $vimcmd </dev/null > job.log 2>&1
  ~/.vim_runtime/install_coc_plugins.sh
fi
