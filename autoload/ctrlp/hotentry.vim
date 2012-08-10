if exists('g:loaded_ctrlp_hotentry') && g:loaded_ctrlp_hotentry
	finish
endif
let g:loaded_ctrlp_hotentry = 1

let s:hotentry_var = {
\  'init':   'ctrlp#hotentry#init()',
\  'exit':   'ctrlp#hotentry#exit()',
\  'accept': 'ctrlp#hotentry#accept',
\  'lname':  'hotentry',
\  'sname':  'hotentry',
\  'type':   'feed',
\  'sort':   0,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:hotentry_var)
else
	let g:ctrlp_ext_vars = [s:hotentry_var]
endif

function! ctrlp#hotentry#init()
  let url = printf("http://b.hatena.ne.jp/search/tag?q=%s&users=%d&mode=rss",
  \  webapi#http#encodeURIComponent(s:word), get(g:, 'ctrlp#hotentry#users', 3))
  let s:feed = webapi#feed#parseURL(url)
  return map(copy(s:feed), 'v:val.title')
endfunc

function! ctrlp#hotentry#accept(mode, str)
	silent call openbrowser#open(filter(copy(s:feed), 'v:val.title == a:str')[0].link)
	call ctrlp#exit()
endfunction

function! ctrlp#hotentry#exit()
  if exists('s:feed')
    unlet! s:feed
  endif
endfunction

function! ctrlp#hotentry#start(word)
  let s:word = a:word
  call ctrlp#init(ctrlp#hotentry#id())
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#hotentry#id()
	return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
