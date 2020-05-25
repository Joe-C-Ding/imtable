let b:tabledata = 'wubi86.txt'
let b:tablejson = 'wubi86.json'

function! BuildTable(txtfile) abort	" {{{2
    let b:tabledict = {}

    for line in readfile(a:txtfile)
	let [code, char, freq] = split(line, "\t")
	if !has_key(b:tabledict, code)
	    let b:tabledict[code] = [[char, freq]]
	else
	    call add(b:tabledict[code], [char, freq])
	endif
    endfor
    call map(b:tabledict, function('SortEntry'))

    call writefile([js_encode(b:tabledict)], b:tablejson)
endfunction

function! SortEntry(_, list) abort	" {{{2
    return a:list->sort({a,b -> -(a[1]-b[1])})->map({_,v -> v[0]})
endfunction

function! LoadTable(jsonfile) abort	" {{{2
    let b:tabledict = js_decode(readfile(a:jsonfile)[0])
    let b:lkeys = keys(b:tabledict)->filter({_,v -> len(v) >= 3})->sort()
endfunction

function! Do() abort	" {{{2
    let start = reltime()
    call LoadTable(b:tablejson)
    echo 'load elapsed:' reltimestr(reltime(start)).'s.'
    for key in keys(b:tabledict)[0:10]
	echo key.':' b:tabledict[key]
    endfor

    for k in b:lkeys[0:10]
	echo k
    endfor
endfunction


