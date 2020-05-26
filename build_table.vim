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

augroup imtest
    au!
    au InsertCharPre * call Translate()
augroup END

function! Translate() abort	" {{{2
    if &iminsert == 2
	let v:char = Convert(v:char)
    endif
endfunction

let b:valid_char = split('a b c d e f g h i j k l m n o p q r s t u v w x y z')
function! Convert(char) abort	" {{{2
    if index(b:valid_char, a:char) < 0
	return a:char
    endif

    let l:code = a:char
    while v:true
	let l:char = getchar()
	if type(l:char) ==# v:t_number
	    let l:char = nr2char(l:char)
	    if index(b:valid_char, l:char) < 0
		return ChoseCode(l:code, l:char)
	    elseif len(l:code) < 4
		let l:code ..= l:char
	    else
		call feedkeys(l:char, 'i')
		return ChoseCode(l:code, ' ')
	    endif
	else
	    return ChoseCode(l:code, l:char)
	endif
    endwhile
endfunction

function! ChoseCode(code, char) abort	" {{{2
    if has_key(b:tabledict, a:code)
	if a:char == ' '
	    return b:tabledict[a:code][0]
	else
	    return b:tabledict[a:code][0] .. a:char
	endif
    else
	return a:char
    endif
endfunction

