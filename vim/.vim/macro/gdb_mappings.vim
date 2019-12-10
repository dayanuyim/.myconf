" Mappings example for use with gdb
" Maintainer:	<xdegaye at users dot sourceforge dot net>
" Last Change:	Mar 6 2006

if ! has("gdb")
    finish
endif

let s:gdb_k = 1

function! ToggleGDB()
    if getwinvar(0,'&statusline') != ""
        :set autochdir
        :cd %:p:h
        :only
        "set statusline=
        :call <SID>Toggle()
    else
        "set statusline+=%F%m%r%h%w\ [POS=%04l,%04v]\ [%p%%]\ [LEN=%L]\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]
        :set noautochdir
        :call <SID>Toggle()
    endif
endfunction

function! SToggleGDB()
    :MiniBufExplorer
    "set statusline+=%F%m%r%h%w\ [POS=%04l,%04v]\ [%p%%]\ [LEN=%L]\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]
    :call <SID>Toggle()
endfunction

nmap <F7>  :call ToggleGDB()<cr>
nmap <S-F7>  :call <SID>Toggle()<cr>

" nmap <S-F7>  :call SToggleGDB()<cr>
" nmap <F7>  :call <SID>Toggle()<CR>

" Toggle between vim default and custom mappings
function! s:Toggle()
    if s:gdb_k
		let s:gdb_k = 0

		set laststatus=0

		"gdb file
		if ! exists("g:vimgdb_debug_file")
			let g:vimgdb_debug_file = ""
		elseif g:vimgdb_debug_file == ""
			call inputsave()
			let g:vimgdb_debug_file = input("GDB file: ", "", "file")
			call inputrestore()
		endif
		call gdb("file " . g:vimgdb_debug_file)

		map <Space> :call gdb("")<CR>
		nmap <silent> <C-Z> :call gdb("\032")<CR>

		nmap <silent> B :call gdb("info breakpoints")<CR>
		nmap <silent> L :call gdb("info locals")<CR>
		nmap <silent> A :call gdb("info args")<CR>
		nmap <silent> S :call gdb("step")<CR>
		nmap <silent> I :call gdb("stepi")<CR>
		nmap <silent> <C-N> :call gdb("next")<CR>
		nmap <silent> X :call gdb("nexti")<CR>
		nmap <silent> F :call gdb("finish")<CR>
		nmap <silent> R :call gdb("run")<CR>
		nmap <silent> Q :call gdb("quit")<CR>
		nmap <silent> C :call gdb("continue")<CR>
		nmap <silent> W :call gdb("where")<CR>
		nmap <silent> <C-U> :call gdb("up")<CR>
		nmap <silent> <C-D> :call gdb("down")<CR>

		" set/clear bp at current line
		nmap <silent> <C-B> :call <SID>Breakpoint("break")<CR>
		nmap <silent> <C-E> :call <SID>Breakpoint("clear")<CR>

		" print value at cursor
		nmap <silent> <C-P> :call gdb("print " . expand("<cword>"))<CR>

		" display Visual selected expression
		vmap <silent> <C-P> y:call gdb("createvar " . "<C-R>"")<CR>

		" print value referenced by word at cursor
		nmap <silent> <C-X> :call gdb("print *" . expand("<cword>"))<CR>

		" setl ctrl+v show variable window in button
		nmap <silent> <C-V> :bel 40 vsplit gdb-variables<CR>  

		echohl ErrorMsg
		echo "gdb keys mapped"
		echohl None

    " Restore vim defaults
    else
		let s:gdb_k = 1

		call gdb("quit")

		set laststatus=2

		nunmap <Space>
		nunmap <C-Z>

		nunmap B
		nunmap L
		nunmap A
		nunmap S
		nunmap I
		nunmap <C-N>
		nunmap X
		nunmap F
		nunmap R
		nunmap Q
		nunmap C
		nunmap W
		nunmap <C-U>
		nunmap <C-D>

		nunmap <C-B>
		nunmap <C-E>
		nunmap <C-P>
		nunmap <C-X>
		nunmap <C-V>

		echohl ErrorMsg
		echo "gdb keys reset to default"
		echohl None
    endif
endfunction

" Run cmd on the current line in assembly or symbolic source code
" parameter cmd may be 'break' or 'clear'
function! s:Breakpoint(cmd)
    " An asm buffer (a 'nofile')
    if &buftype == "nofile"
	" line start with address 0xhhhh...
	let s = substitute(getline("."), "^\\s*\\(0x\\x\\+\\).*$", "*\\1", "")
	if s != "*"
	    call gdb(a:cmd . " " . s)
	endif
    " A source file
    else
	let s = "\"" . fnamemodify(expand("%"), ":p") . ":" . line(".") . "\""
	call gdb(a:cmd . " " . s)
    endif
endfunction

" map vimGdb keys ==================================
"" vimgdb setting
set splitright                  " set gdb windows split in right side
set splitbelow                  " set gdb windows split in below side
set previewheight=8        " set gdb window initial height or width(if you set splitright)
set asm=0                    " don't show any assembly stuff
set gdbprg=gdb              " set GDB invocation string (default 'gdb')
