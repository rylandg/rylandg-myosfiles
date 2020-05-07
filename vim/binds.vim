" Bind undo tree to leader u
nnoremap <leader>u :MundoToggle<cr>

" Allow TAB to autocomplete coc suggestions
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'


" select omni completion entry with enter (always supress newline)
" nmap <silent> xt <Plug>(coc-type-definition)<cr>
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" Use K for show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" nmap <leader>qf  <Plug>(coc-diagnostic-info)


nnoremap gt :bn<cr>
nnoremap gT :bp<cr>

nnoremap <silent> <leader>tg  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Remap for do codeAction of current line
nmap <leader>gv  <Plug>(coc-codeaction)

nnoremap Q :w\|bd<cr>

nm <silent> <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
    \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
    \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
    \ . ">"<CR>

nmap <F2> :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
