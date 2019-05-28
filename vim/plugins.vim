set nocompatible
" Vim-plug is our package manager, load all the plugins here
call plug#begin('/home/ubuntu/.vim/')

" The only theme
Plug 'whatyouhide/vim-gotham'
" Status info within vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Undo as a tree instead of a linear repr
Plug 'simnalamburt/vim-mundo'
" Auto comment blocks with gcc or gc<motion>
Plug 'tpope/vim-commentary'
" The best git integration
Plug 'tpope/vim-fugitive'
" Adds auto paren, bracket, etc                                                         │
Plug 'tpope/vim-surround'
" Fuzzy finder, 
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
" Intellisense for vim
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
" All syntax highlighting
Plug 'sheerun/vim-polyglot'
" Snippets
Plug 'honza/vim-snippets'
" Tmux conf support
Plug 'tmux-plugins/vim-tmux'
" Move around between tmux & vim splits
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

set updatetime=300
set signcolumn=yes

" Auto installs missing plugins on start
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif


" Set our undo tree position to bottom right
let g:mundo_right = 1
let g:mundo_bottom = 1


" TODO: Configure LeaderF keybinds
let g:Lf_WindowHeight = 0.30
let g:Lf_DefaultMode = 'NameOnly'
let g:Lf_WildIgnore = {
             \ 'dir': ['.svn','.git','.hg', 'node_modules'],
             \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
             \}

let g:airline#extensions#tabline#enabled = 1
