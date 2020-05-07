set nocompatible
" Vim-plug is our package manager, load all the plugins here
call plug#begin('/home/ubuntu/.vim/')

" The only theme
Plug 'whatyouhide/vim-gotham'
Plug 'arcticicestudio/nord-vim'
" Status info within vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Undo as a tree instead of a linear repr
Plug 'simnalamburt/vim-mundo'
" Auto comment blocks with gcc or gc<motion>
" Plug 'tpope/vim-commentary'
Plug 'tomtom/tcomment_vim'
" The best git integration
Plug 'tpope/vim-fugitive'
" Adds auto paren, bracket, etc 
Plug 'tpope/vim-surround'
" Fuzzy finder, 
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
" Intellisense for vim
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install()}}
" All syntax highlighting
Plug 'sheerun/vim-polyglot'
" Snippets
Plug 'honza/vim-snippets'
" Tmux conf support
Plug 'tmux-plugins/vim-tmux'
" Move around between tmux & vim splits
Plug 'christoomey/vim-tmux-navigator'
" Add color highlighting to css colors
Plug 'ap/vim-css-color'
" TypeScript syntax
Plug 'leafgarland/typescript-vim'
" React JSX
Plug 'peitalin/vim-jsx-typescript'

call plug#end()

set updatetime=300
set signcolumn=yes

if has("autocmd")  
  " Auto reload *.vim files if they change
  augroup plugins
    " Preview pane should dissapear after successful completion
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    autocmd User CocQuickfixChange :CocList --normal quickfix
    " Auto installs missing plugins on start
    autocmd VimEnter *
      \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \|   PlugInstall --sync | q
      \| endif
    autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
    autocmd BufWritePost * silent call popup_clear()
  augroup END
endif

" Set our undo tree position to bottom right
let g:mundo_right = 1
let g:mundo_bottom = 1


" TODO: Configure LeaderF keybinds
let g:Lf_UseMemoryCache = 0
let g:Lf_UseCache = 0
let g:Lf_WindowHeight = 0.30
let g:Lf_DefaultMode = 'NameOnly'
let g:Lf_WildIgnore = {
             \ 'dir': ['.svn','.git','.hg', 'node_modules', 'dist'],
             \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
             \}
noremap <C-T> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
let g:Lf_CommandMap = {'<C-F>': ['<C-D>'], '<ESC>': ['<C-A>', '<C-B>']}


let g:airline#extensions#tabline#enabled = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0 C             :CocConfig
command! -nargs=0 R             :CocRestart
command! -nargs=0 L             :CocListResume
command! -nargs=0 -range D      :CocCommand
command! -nargs=0 Prettier      :CocCommand prettier.formatFile

command! -nargs=0 JSONPretty    :%!python -m json.tool
command! -nargs=0 Todos         :CocList -A --normal grep -e TODO|FIXME
command! -nargs=0 Status        :CocList -A --normal gstatus
command! -nargs=+ Find          :exe 'CocList -A --normal grep --smart-case '.<q-args>
command! -nargs=0 Format        :call CocAction('format')
command! -nargs=0 GitChunkUndo  :call CocAction('runCommand', 'git.chunkUndo')
command! -nargs=0 OR            :call CocAction('runCommand', 'editor.action.organizeImport')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! s:GoToDefinition()
  if CocAction('jumpDefinition')
    return v:true
  endif

  let ret = execute("silent! normal \<C-]>")
  if ret =~ "Error" || ret =~ "错误"
    call searchdecl(expand('<cword>'))
  endif
endfunction

function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

function! CopyFloatText() abort
  let id = win_getid()
  let winid = coc#util#get_float()
  if winid
    call win_gotoid(winid)
    execute 'normal! ggvGy'
    call win_gotoid(id)
  endif
endfunction

function! FloatScroll(forward) abort
  let float = coc#util#get_float()
  if !float | return '' | endif
  let buf = nvim_win_get_buf(float)
  let buf_height = nvim_buf_line_count(buf)
  let win_height = nvim_win_get_height(float)
  if buf_height < win_height | return '' | endif
  let pos = nvim_win_get_cursor(float)
  if a:forward
    if pos[0] == 1
      let pos[0] += 3 * win_height / 4
    elseif pos[0] + win_height / 2 + 1 < buf_height
      let pos[0] += win_height / 2 + 1
    else
      let pos[0] = buf_height
    endif else
    if pos[0] == buf_height
      let pos[0] -= 3 * win_height / 4
    elseif pos[0] - win_height / 2 + 1  > 1
      let pos[0] -= win_height / 2 + 1
    else
      let pos[0] = 1
    endif
  endif
  call nvim_win_set_cursor(float, pos)
  return ''
endfunction

nmap <silent> gd :call <SID>GoToDefinition()<CR>
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)
nmap <silent> ge <Plug>(coc-diagnostic-next)
nmap <silent> ga <Plug>(coc-codeaction)
nmap <silent> gl <Plug>(coc-codelens-action)
nmap <silent> gs <Plug>(coc-git-chunkinfo)
nmap <silent> gm <Plug>(coc-git-commit)
omap <silent> ig <Plug>(coc-git-chunk-inner)
xmap <silent> ig <Plug>(coc-git-chunk-inner)

nmap <silent> <expr> [c &diff ? '[c' : '<Plug>(coc-git-prevchunk)'
nmap <silent> <expr> ]c &diff ? ']c' : '<Plug>(coc-git-nextchunk)'
nmap <silent> <expr> <C-d> <SID>select_current_word()
nmap <leader>x  <Plug>(coc-cursors-operator)
nmap <leader>rf <Plug>(coc-refactor)
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" use ctrl-j, ctrl-k for selecting omni completion entries
inoremap <expr> <C-j> pumvisible() ? '<C-n>' : ''
inoremap <expr> <C-k> pumvisible() ? '<C-p>' : ''
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> <leader>o  :<C-u>CocList -A outline -kind<CR>
nnoremap <silent> <leader>a  :<C-u>CocList diagnostics<CR>
nnoremap <silent> <,>f  :<C-u>CocList files<CR>
nnoremap <silent> <,>l  :<C-u>CocList lines<CR>
nnoremap <silent> <leader>q  :<C-u>CocList quickfix<CR>
nnoremap <silent> <,>w  :<C-u>CocList -I -N symbols<CR>
nnoremap <silent> <,>y  :<C-u>CocList -A --normal yank<CR>
nnoremap <silent> <,>m  :<C-u>CocList -A -N mru<CR>
nnoremap <silent> <,>b  :<C-u>CocList -A -N --normal buffers<CR>
nnoremap <silent> <,>j  :<C-u>CocNext<CR>
nnoremap <silent> <,>k  :<C-u>CocPrev<CR>
" nnoremap <silent> <,>s  :exe 'CocList -A -I --normal --input='.expand('<cword>').' words'<CR>
nnoremap <silent> <,>S  :exe 'CocList -A --normal grep '.expand('<cword>').''<CR>

function ProfileStart()
  :profile start profile.log
  :profile func *
  :profile file *
endfunction

function ProfileEnd()
  :profile pause
endfunction

" nnoremap <leader>r :call <SID>ProfileStart()<CR>
" nnoremap <leader>z :call <SID>ProfileEnd()<CR>
" nnoremap <silent> <leader>8 :profile pause | noautocmd qall!

imap <C-k> <Plug>(coc-snippets-expand)
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
call coc#add_command('tree', 'Vexplore', 'open netrw explorer')
