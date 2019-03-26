" Default options
" Broeser cmd
if !exists('g:openurl_browsercmd')
	let g:openurl_browsercmd = 'qutebrowser --target tab'
endif
" Map keys
if !exists('g:openurl_open_map')
	let g:openurl_open_map = 'gx'
endif

" Maps
" Brief translation
if g:openurl_open_map != ''
	exe 'nnoremap <silent> ' . g:openurl_open_map
				\ . ' :call <SID>OpenInBrowser(expand("<cWORD>"))<CR>'
	exe 'vnoremap <silent> ' . g:openurl_open_map .' :<C-U>exe'
				\ . ' "call <SID>OpenInBrowser(<SID>get_visual_selection())"<CR>'
endif

" Open pattern in browser
func s:OpenInBrowser(pattern)
	" Chek if pattern is url or search request
	let url = matchstr(a:pattern, '[a-z]*:\/\/[^ \n>,;]*')
	if url != ''
		let query = url
	else
		let query = a:pattern
	endif
	"Open browser
	call job_start(g:openurl_browsercmd . ' ' . query, {"stoponexit": ""})
endfunc

" This function is modified version of written by xolox and published on
" StackOverflow.
" Link: https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
function! s:get_visual_selection()
    if mode()==#"v" || mode()==#"V" || mode()==?"CTRL-V"
        let [line_start, column_start] = getpos("v")[1:2]
        let [line_end, column_end] = getpos(".")[1:2]
    else
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
    end
    if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
        let [line_start, column_start, line_end, column_end] =
        \   [line_end, column_end, line_start, column_start]
    end
    let lines = getline(line_start, line_end)
    if len(lines) == 0
            return ''
    endif
    let lines[-1] = lines[-1][: column_end - 1]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
