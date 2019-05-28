let helpers = {}

func helpers.hasPaste() dict
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunc

func helpers.cleanExtraSpaces() dict
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunc
