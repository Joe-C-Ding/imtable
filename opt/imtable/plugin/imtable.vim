" imtable.vim	vim: ts=8 sw=4 fdm=marker
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2020-05-30 11:34:12

if &cp || exists("g:loaded_imtable")
    finish
elseif v:version < 802
    " Mainly depends on
    "	feedkeys()	introduced from 7.0
    "	InsertCharPre	introduced from 7.4
    "	Vim packages	introduced from 8.0
    "	Lambda expression introduced from 8.0
    "	Popup-windows	introduced from 8.2
    "	Method call	introduced from 8.2
    " So the newer the better. :)
    echoerr 'Error: imtable only supports Vim-8.2 or later.'
    finish
endif
let g:loaded_imtable = 1

let s:save_cpo = &cpo
set cpo&vim

augroup im_autocmd
    au!
    au VimEnter * call imtable#LoadTable()
    au InsertCharPre * call imtable#TableConvert()
augroup END

command IMRebuildTable call imtable#build#BuildTable()

let &cpo = s:save_cpo
unlet s:save_cpo
