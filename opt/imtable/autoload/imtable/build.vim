" build.vim	vim: ts=8 sw=4 fdm=marker
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2020-05-30 12:00:49


function! imtable#build#BuildTable(txtfile=g:im_table_def) abort
    if !filereadable(a:txtfile)
	echohl WarningMsg
	echom 'No such file or it cannot be read:' a:txtfile
	echohl None

	return {}
    endif

    echo 'building table from:' a:txtfile
    echo 'This may take a few seconds...'
    let l:tabledict = {}
    let start = reltime()

    for line in readfile(a:txtfile)
	let [code, char, freq] = split(line, "\t")
	if has_key(l:tabledict, code)
	    call add(l:tabledict[code], [char, freq])
	else
	    let l:tabledict[code] = [[char, freq]]
	endif
    endfor

    call map(l:tabledict, {_,v -> sort(v, {a,b -> -(a[1]-b[1])})->map({_,v -> v[0]})})
    echo 'done. in' reltimestr(reltime(start))..'s.'

    let l:table_json = substitute(g:im_table_def, '.txt$', '.json', '')
    call writefile([js_encode(l:tabledict)], l:table_json)
    return l:tabledict
endfunction
