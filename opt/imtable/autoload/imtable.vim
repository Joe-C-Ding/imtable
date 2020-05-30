" imtable.vim	vim: ts=8 sw=4 fdm=marker
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2020-05-30 10:57:32

" read configurations.
exec 'so ' .. substitute(expand('<sfile>:p:h'), 'opt.*', 'config.vim', '')

let s:table = {}

function! imtable#LoadTable() abort	" {{{1
    " do not overwrite if table exists.
    if empty(s:table)
	let l:json = substitute(g:im_table_def, 'txt$', 'json', '')
	let s:table = js_decode(readfile(l:json)[0])
    endif
endfunction

" TableConvert()	{{{1
let s:popid = -1
let s:popopt = #{pos: 'topleft', border: [], maxheight: 11, scrollbar: 0}

function! imtable#TableConvert() abort
    " for imisert, see |iminsert|
    if &iminsert != 2
	return
    else
	" put this char back for next read.
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

	elseif l:char == g:im_temp_english_key && len(l:code) == 0
	    return s:TempEnglish()

	elseif l:char == g:im_toggle_chinese_punct
	    let g:im_disable_chinese_punct = !g:im_disable_chinese_punct
	    continue

	else
	    if index(g:im_valid_keys, l:char) < 0
		return s:Finalize(l:code, l:char)
	    elseif len(l:code) < g:im_max_code_length
		let l:code ..= l:char
	    else
		call feedkeys(l:char, 'i')
		return s:Finalize(l:code, '')
	    endif
	endif

	let l:poptext = [l:code .. ':'] + s:GetCandidates(l:code, 1)
	if s:popid < 0
	    let s:popid = popup_atcursor(l:poptext, s:popopt)
	else
	    call popup_settext(s:popid, l:poptext)
	endif
	redraw
    endwhile
endfunction

let s:prev_word = ''
" close the popup-window, and determine candidates.
function! s:Finalize(code, char) abort	" {{{2
    if s:popid == -1
	return
    else
	call popup_close(s:popid)
	let s:popid = -1
    endif

    " <Esc> to cancel input
    if a:char == "\<Esc>"
	let v:char = ''

    " if configures so, <CR> submits the code itself
    elseif a:char == "\<CR>" && g:im_enter_submit
	let v:char = a:code

    else
	let l:cand = s:GetCandidates(a:code)

	let l:idx = index(g:im_select_keys, a:char)
	if l:idx < 0 || l:idx >= len(l:cand)
	    let v:char = get(l:cand, 0, '') .. s:HandlePunct(a:char)
	else
	    let v:char = l:cand[l:idx]
	endif
    endif

    let s:prev_word = v:char
    return v:char
endfunction

" translate code to Chinese.
" if padding is non-zero, padding a number before each item for selection.
function! s:GetCandidates(code, padding=0) abort	" {{{2
    if has_key(s:table, a:code)
	let l:cand = s:table[a:code]

    " use `z' to repeat last input.
    elseif a:code == 'z'
	let l:cand = [s:prev_word]

    else
	" make a beep for empty code 
	if len(a:code) == g:im_max_code_length
	    norm! 
	endif
	let l:cand = []
    endif

    return !a:padding ? l:cand :
	\copy(l:cand)->map({k,v -> printf('%d. %s',(k+1)%10, v)})
endfunction

" translate punctuation based on configs.
function! s:HandlePunct(char) abort	" {{{2
    if g:im_disable_chinese_punct || !has_key(g:im_chinese_puncts, a:char)
	return a:char

    " period after number always be half-width.
    elseif a:char == '.' && s:prev_word =~# '\d$'
	return '.'

    else
	return g:im_chinese_puncts[a:char]
    endif
endfunction

function! s:TempEnglish() abort	" {{{2
    let s:popid = popup_atcursor('', s:popopt)
    redraw

    let v:char = ''
    while v:true
	let l:char = getchar()
	if type(l:char) ==# v:t_number
	    let l:char = nr2char(l:char)
	endif

	if l:char == "\<CR>"
	    let s:prev_word = v:char
	    break

	elseif l:char == "\<BS>"
	    let v:char = v:char[:-2]
	    if empty(v:char)
		break
	    endif

	elseif l:char == "\<Esc>"
	    let v:char = ''
	    break

	else
	    let v:char ..= l:char
	endif

	call popup_settext(s:popid, v:char)
	redraw
    endwhile

    call popup_close(s:popid)
    let s:popid = -1
    return v:char
endfunction

