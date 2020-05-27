" config.vim	vim: ts=8 sw=4 fdm=marker
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2020-05-28 01:30:54

" keys that are valid for input composing.
let g:im_valid_keys = split('a b c d e f g h i j k l m n o p q r s t u v w x y z')

" keys to select from candidates
let g:im_select_keys = [' ', ';', "'", '4', '5', '6', '7', '8', '9', '0']

" Chinese punctuation.
" the toggle key must not be one of the valid_keys or select_keys.
let g:im_disable_chinese_punct = 0
let g:im_toggle_chinese_punct = "\<C-b>"
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

" table definition.
let g:table_def = expand('<sfile>:p:h') .. '/table/wubi86.txt'

