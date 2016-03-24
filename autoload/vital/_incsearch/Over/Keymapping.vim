" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not mofidify the code nor insert new lines before '" ___vital___'
let s:___vital_function___ = 'function'
if !(v:version > 703 || v:version == 703 && has('patch1170'))
  let s:___vital_function___ = 's:___vital_function___'
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:___vital_sfunc_prefix___ = '<SNR>' . s:_SID() . '_'
  delfunction s:_SID

  function! s:___vital_function___(fstr) abort
    return function(substitute(a:fstr, '^s:', s:___vital_sfunc_prefix___, ''))
  endfunction
endif

function! vital#_incsearch#Over#Keymapping#import() abort
  return map({'_vital_depends': '', 'unmapping': '', 'as_key_config': '', 'match_key': '', '_vital_loaded': ''},  '{s:___vital_function___}("s:" . v:key)')
endfunction
" ___vital___
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim



function! s:_vital_loaded(V)
	let s:V = a:V
	let s:String  = s:V.import("Over.String")
endfunction


function! s:_vital_depends()
	return [
\		"Over.String",
\	]
endfunction


function! s:as_key_config(config)
	let base = {
\		"noremap" : 0,
\		"lock"    : 0,
\		"expr"    : 0,
\	}
	return type(a:config) == type({}) ? extend(base, a:config)
\		 : extend(base, {
\		 	"key" : a:config,
\		 })
endfunction


function! s:match_key(keymapping, key)
	let keys = sort(keys(a:keymapping))
	return get(filter(keys, 'stridx(a:key, v:val) == 0'), -1, '')
endfunction


function! s:_safe_eval(expr, ...)
	call extend(l:, get(a:, 1, {}))
	let result = get(a:, 2, "")
	try
		let result = eval(a:expr)
	catch
		echohl ErrorMsg | echom v:exception | echohl None
	endtry
	return result
endfunction


function! s:_get_key(conf)
" 	call extend(l:, a:conf)
	let self = a:conf
	return get(a:conf, "expr", 0) ? s:_safe_eval(a:conf.key, l:) : a:conf.key
endfunction


function! s:unmapping(keymapping, key, ...)
	let is_locking = get(a:, 1, 0)
	let key = s:match_key(a:keymapping, a:key)
	if key == ""
		return s:String.length(a:key) <= 1 ? a:key : s:unmapping(a:keymapping, a:key[0], is_locking) . s:unmapping(a:keymapping, a:key[1:], is_locking)
	endif

	let map_conf = s:as_key_config(a:keymapping[key])

	let next_input = s:unmapping(a:keymapping, a:key[len(key) : ], is_locking)
	if map_conf.lock == 0 && is_locking
		return key . next_input
	elseif map_conf.lock
		return s:unmapping(a:keymapping, s:_get_key(map_conf), is_locking) . next_input
	else
		return s:unmapping(a:keymapping, s:_get_key(map_conf), map_conf.noremap) . next_input
	endif
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
