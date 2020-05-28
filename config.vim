" config.vim	vim: ts=8 sw=4 fdm=marker
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2020-05-29 01:33:03

" keys that are valid for input composing.
if !exists('g:im_valid_keys')
    let g:im_valid_keys = split('a b c d e f g h i j k l m n o p q r s t u v w x y z')
endif

" keys to select from candidates
if !exists('g:im_select_keys')
    let g:im_select_keys = [' ', ';', "'", '4', '5', '6', '7', '8', '9', '0']
endif

" if 1, use <Enter> to submit the code itself.
" if 0, <Enter> submit the first candidate, and then insert a <Enter> itself.
if !exists('g:im_enter_submit')
    let g:im_enter_submit = 1
endif

" Chinese punctuation.
" the toggle key must not be one of the valid_keys or select_keys.
if !exists('g:im_disable_chinese_punct')
    let g:im_disable_chinese_punct = 0
endif

if !exists('g:im_toggle_chinese_punct')
    let g:im_toggle_chinese_punct = "\<C-b>"
endif

if !exists('g:im_chinese_puncts')
let g:im_chinese_puncts = {
	\',': '，',
	\'.': '。',
	\'?': '？',
	\'!': '！',
	\'\': '、',
	\'^': '……',
	\'_': '——',
	\'<': '《',
	\'>': '》',
	\'(': '（',
	\')': '）',
	\'$': '¥',
	\'`': '·',
	\'~': '〜',
	\}
endif

" path to the table definition.
if !exists('g:im_table_def')
    let g:im_table_def = expand('<sfile>:p:h') .. '/table/wubi86.txt'
endif

