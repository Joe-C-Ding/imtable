" build.vim	vim: ts=8 sw=4 fdm=marker
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	
" Last Change:	2020-05-28 00:12:50

function! table#build#BuildTable(txtfile=s:table_data) abort
    let l:tabledict = {}

    echo 'building table from:' a:txtfile '...'
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
    echo 'done in' reltimestr(reltime(start))..'s.'

    call writefile([js_encode(l:tabledict)], s:table_json)
    return l:tabledict
endfunction
