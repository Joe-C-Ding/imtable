" imtable.vim	vim: ts=8 sw=4 fdm=marker
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2020-05-28 01:48:17

if &cp || exists("g:loaded_imtable")
    finish
endif
let g:loaded_imtable = 1

let s:save_cpo = &cpo
set cpo&vim

augroup im_autocmd
    au!
    au VimEnter * call s:LoadTable()
    au InsertCharPre * call TableConvert()
augroup END

" read configurations.
exec 'so ' .. substitute(expand('<sfile>:p:h'), 'opt.*', 'config.vim', '')


let s:table = {}

function! s:LoadTable() abort	" {{{1
    " do not overwrite if table exists.
    if empty(s:table)
	let l:json = substitute(g:table_def, 'txt$', 'json', '')
	let s:table = js_decode(readfile(l:json)[0])
    endif
endfunction

" TableConvert()	{{{1
let s:popid = -1
let s:popopt = #{pos: 'topleft', border: [], maxheight: 11, scrollbar: 0}

function! TableConvert() abort
    " for imisert, see |iminsert|
    if &iminsert != 2
	return
    else
	call feedkeys(v:char, 'i')
    endif

    let l:code = ''
    let s:popid = -1
    while v:true
	let l:char = getchar()
	if type(l:char) ==# v:t_number
	    let l:char = nr2char(l:char)
	endif

	if l:char == "\<BS>"
	    let l:code = l:code[:-2]
	    if empty(l:code)
		return s:Finalize('', '')
	    endif
	
	elseif l:char == g:im_toggle_chinese_punct
	    let g:im_disable_chinese_punct = !g:im_disable_chinese_punct
	    continue

	else
	    if index(g:im_valid_keys, l:char) < 0
		return s:Finalize(l:code, l:char)
	    elseif len(l:code) < 4
		let l:code ..= l:char
	    else
		call feedkeys(l:char, 'i')
		return s:Finalize(l:code, '')
	    endif
	endif

	if s:popid < 0
	    let s:popid = popup_atcursor(s:ListCandidates(l:code), s:popopt)
	else
	    call popup_settext(s:popid, s:ListCandidates(l:code))
	endif
	redraw
    endwhile
endfunction

let s:prev_word = ''
function! s:Finalize(code, char) abort	" {{{2
    call popup_close(s:popid)
    let s:popid = -1

    if a:char == "\<Esc>"
	let v:char = ''

    else
	let l:cand = s:GetCandidates(a:code)
	let l:char = s:HandlePunct(a:char)

	let l:idx = index(g:im_select_keys, l:char)
	if l:idx < 0 || l:idx >= len(l:cand)
	    let v:char = get(l:cand, 0, '') .. l:char
	else
	    let v:char = l:cand[l:idx]
	endif
    endif

    let s:prev_word = v:char
    return v:char
endfunction

function! s:GetCandidates(code) abort	" {{{2
    if has_key(s:table, a:code)
	return s:table[a:code]

    " use `z' to repeat last input.
    elseif a:code == 'z'
	return [s:prev_word]

    else
	return []
    endif
endfunction

function! s:ListCandidates(code) abort	" {{{2
    return [a:code .. ':'] +
	\s:GetCandidates(a:code)->copy()
	\->map({k,v -> printf('%d. %s',(k+1)%10, v)})
endfunction

function! s:HandlePunct(char) abort	" {{{2
    if g:im_disable_chinese_punct || !has_key(g:im_chinese_puncts, a:char)
	return a:char
    elseif a:char == '.' && s:prev_word =~# '\d$'
	return '.'
    else
	return g:im_chinese_puncts[a:char]
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
