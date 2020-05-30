" config.vim	vim: ts=8 sw=4 fdm=marker
" Language:	Vim-script
" Maintainer:	Joe Ding
" Version:	0.1
" Last Change:	2020-05-30 11:57:04

" for wubi, max code length should be 4.
if !exists('g:im_max_code_length')
    let g:im_max_code_length = 4
endif

" keys that are valid for input composing.
if !exists('g:im_valid_keys')
    let g:im_valid_keys = split('a b c d e f g h i j k l m n o p q r s t u v w x y z')
endif

" keys to select from candidates
if !exists('g:im_select_keys')
    let g:im_select_keys = [' ', ';', "'", '4', '5', '6', '7', '8', '9', '0']
endif

" key used to start temporary English mode.
if !exists('g:im_temp_english_key')
    let g:im_temp_english_key = ';'
endif

" if 1, use <Enter> to submit the code itself.
" if 0, <Enter> submit the first candidate, and then insert a <Enter> itself.
if !exists('g:im_enter_submit')
    let g:im_enter_submit = 1
endif

" Chinese punctuation.
" the toggle key should not be one of the valid_keys or select_keys, or
" overwrites them.
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
	\}
endif

" path to the table definition.
" if set this to another file or the file contents are changed, the table needs
" to be rebuild before it can take effects.
" to rebuild it, execute
"   :IMRebuildTable
"
" the format of each line the table file is:
"   code	word	frequent
" `code` must be at first column, and fields are split by "\t"
" if different `word`s share the same `code`, the higher the `frequent` the
"   closer it will be to the top of the candidates during typing.
"
" NOTE: the maximum of `frequent` is 2^31 - 1 = 2147483647
if !exists('g:im_table_def')
    let g:im_table_def = expand('<sfile>:p:h') .. '/table/wubi86.txt'
endif

