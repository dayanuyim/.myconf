set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OS-dependent
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("win32")
	source $VIMRUNTIME/vimrc_example.vim
	source $VIMRUNTIME/mswin.vim
	behave mswin
	"set diffexpr=MyDiff()
	set directory=$TEMP,$TMP
	set backupdir=$TEMP,$TMP
	set undodir=$TEMP,$TMP
elseif has("unix")
	"man search priority
	set directory=~/.tmp,~/tmp,/tmp
	set backupdir=~/.tmp,~/tmp,/tmp
	set undodir=~/.tmp,~/tmp,/tmp
	let $MANSECT = '3,2,1,4,5,6,7,8,9'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle
"---------------------------------------------------------------------
"   git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"   Launch VIM and run :PluginInstall
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
"syntax ------------------------
Plugin 'rust-lang/rust.vim'
Plugin 'tomlion/vim-solidity'
Plugin 'leafgarland/typescript-vim'
Plugin 'pangloss/vim-javascript'
Plugin 'elzr/vim-json'
Plugin 'plasticboy/vim-markdown'
"Plugin 'tpope/vim-markdown'
Plugin 'vim-scripts/gdl.vim'
Plugin 'vim-scripts/openvpn'
Plugin 'cespare/vim-toml'
Plugin 'stevearc/vim-arduino'
"Plugin 'WolfgangMehner/bash-support'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set the flag to prevent SuperTab from inserting one more line when keying ENTER.
" But WHY? ref: https://github.com/ervandew/supertab/issues/142
let g:SuperTabCrMapping = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set t_Co=256
colorscheme distinguished
" colorscheme ansi_blows
" colorscheme badwolf
" colorscheme rmnv

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype indent plugin on

" tab width
set cindent
set tabstop=4
set shiftwidth=4
set softtabstop=4  "use space, instead of tab
set expandtab
" local tab settings
autocmd FileType make setlocal noexpandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType js setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType ts setlocal tabstop=2 shiftwidth=2 softtabstop=2

"search
set ignorecase
set smartcase
set incsearch
set hlsearch
" clear current search by 'Ctrl+/'
noremap <silent> <c-_> :let @/ = ""<CR>

"Surrounding
nmap S viwS

"location
set ruler
set nu

"disable bell
autocmd VimEnter * set vb t_vb=

"for :make
set autowrite

"set matchpaire
"cpp set matchpairs+=<:>  "may cause some odds...

" write with sudo
cmap w!! w !sudo tee >/dev/null %

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Compile
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vimgdb
run macros/gdb_mappings.vim
nmap <silent><LEADER>g :run macros/gdb_mappings.vim<cr>


" Compile
map <F3> <ESC>:cprev<CR>
map <F4> <ESC>:cnext<CR>

"F5 -> compile
"F6 -> run
"F7 -> debugger
"F8 -> clean
"F9 -> return back
"
"au BufNewFile,BufRead *.cpp 
au Filetype c call CCompOps()
function CCompOps()
	exec "nnoremap <F5> <ESC>mZ<ESC>:make --silent SRCS='%:p'<CR>"
	nnoremap <F6> <ESC>:!'%:p:r'<CR>
	exec "nnoremap <F8> <ESC>:make --silent SRCS='%:p' clean<CR>"
	nnoremap <F9> `Z
endfunction

au Filetype cpp call CppCompOps()
function CppCompOps()
	set errorformat+=\[%f:%l\]:\ %m "cppcheck
    nnoremap <F5> <ESC>mZ<ESC>:!clear && make --silent SRCS='%:p'<CR>
	nnoremap <F6> <ESC>:!'%:p:r'<CR>
	exec "nnoremap <F8> <ESC>:make --silent SRCS='%:p' clean<CR>"
	nnoremap <F9> `Z
endfunction

au Filetype python call PythonCompOps()
function PythonCompOps()
    "if has("win32") "use 'py' to select python2/3 depending on shebang
        "set makeprg=py\ \"%:p\"
        "map <F6> <ESC>:!py "%:p"<CR>
	"set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    set makeprg=\"%:p\"
	set errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
	nnoremap <F5> <ESC>mZ<ESC>:make<CR>
    if has('gui_running')
        nnoremap <F6> <ESC>:!start cmd /k "%:p"<CR>
    else
        nnoremap <F6> <ESC>:!"%:p"<CR>
    endif
	nnoremap <F8> <ESC>:echo 'No Support for clean'<CR>
	nnoremap <F9> <ESC>`Z
    "python complete
    let g:pydiction_location = '$HOME/.vim/after/ftplugin/pydiction/complete-dict'
endfunction

au Filetype sh call BashCompOps()
function BashCompOps()
    let mkfile = '~/Projects/template.c.mk'
	nnoremap <F5> <ESC>mZ<ESC>:!clear && bash -n '%:p' && shellcheck '%:p'<CR>
	nnoremap <F6> <ESC>:!clear && bash '%:p'<CR>
	nnoremap <F7> <ESC>:!clear && bash -vx '%:p'<CR>
	nnoremap <F9> `Z
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fold
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nofoldenable
set foldcolumn=0
"set foldmethod=syntax
"au BufReadPost *.*   syn region myFold start="{" end="}" transparent fold
"au BufReadPost *.*   syn sync fromstart
"au BufReadPost *.*   set foldmethod=syntax
set foldlevel=0

map <space> zA

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Utilities
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" swap two words
nmap <C-s>  lbdepldebhP
nmap <S-s>  lBdEpldEBhP

" insdert tab in command mode
nmap <tab>		v>
nmap <S-tab>	v<

"focus move
map <C-j>		jz.
map <C-k>		kz.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vimgrep 找下一個  "注意：hide buit-in '#'
map <F2> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

map #           :lnext<CR>

"如果要開一個檔名內有 'vim' 的檔案，下面會有問題
"cabbrev vim
"      \ vim /\<lt><C-R><C-W>\>/j
"      \ *<C-R>=(expand("%:e")=="" ? "" : ".".expand("%:e"))<CR>
"      \ <Bar> cw
"      \ <C-Left><C-Left><C-Left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" split
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitright
set splitbelow

"open syncbind vnew
map <C-W>y <ESC>:set scrollbind<CR>:vnew<CR>:set scrollbind<CR>:syncbind<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab Page Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"gT
nnoremap <C-Left> :tabprevious<CR>
"gt
nnoremap <C-Right> :tabnext<CR>

"tabmove
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>

map <C-t>n		<ESC>:tabnew<CR><ESC>:e 
"map <C-t>n		<ESC>:tabnew<CR><ESC>:NERDTreeMirror<CR><C-W>l<ESC>:e 

"last used tab
let g:lasttab = 1
map <C-t><C-t> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

map <C-t>1		1gt
map <C-t>2		2gt
map <C-t>3		3gt
map <C-t>4		4gt
map <C-t>5		5gt
map <C-t>6		6gt
map <C-t>7		7gt
map <C-t>8		8gt
map <C-t>9		9gt
map <C-t>a		10gt
map <C-t>b		11gt
map <C-t>c		12gt
map <C-t>d		13gt
map <C-t>e		14gt
map <C-t>f		15gt

"autocmd VimEnter * call BufPos_Initialize()

set showtabline=2 " always show tabs in gvim, but not vim
set guitablabel=%{GuiTabLabel()}
set guitabtooltip=%{GuiTabToolTip()}
set tabline=%!SetTabLine()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" netrw
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" tree viw
let g:netrw_liststyle=3

" hidden banner
let g:netrw_banner=0

"1 - open files in a new horizontal split
"2 - open files in a new vertical split
"3 - open files in a new tab
"4 - open in previous window
let netrw_browse_split=4

" width %
let g:netrw_winsize=25

let g:netrw_altv = 1

"augroup ProjectDrawer
"    autocmd!
"    autocmd BufRead * :Vexplore
"augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree Plugin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"autocmd vimenter * NERDTree

autocmd StdinReadPre * let s:std_in=1
" open no files
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" open a saved session
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif
" open dir
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CLang
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("unix")
	imap <c-X><c-X> <c-X><c-U>
	let g:clang_complete_auto=0
	let g:clang_auto_select=1
	let g:clang_complete_copen=1
	let g:clang_periodic_quickfix=0
	let g:clang_snippets=1
	let g:clang_close_preview=1
	let g:clang_use_library=1
	let g:clang_user_options='-stdlib=libc++ -std=c++11 -IIncludePath'
	let g:clang_user_options='|| exit 0'
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup filetypedetect
	"au BufNewFile,BufRead *.cpp set syntax=cpp11
	au BufNewFile,BufRead *.hpp setf cpp
	au BufNewFile,BufRead *.nsh setf nsis
	au BufNewFile,BufRead *.inf setf ppwiz
	au BufNewFile,BufRead *.lrc setf lrc
	au BufNewFile,BufRead *.cue setf cue
	au BufNewFile,BufRead *.ssa setf ssa
	au BufNewFile,BufRead *.ass setf ssa
	au BufNewFile,BufRead *.srt setf srt
	au BufNewFile,BufRead *.ftlh setf html
	au BufNewFile,BufRead *.ipynb setf json
    au BufNewFile,BufRead *.{gdl,vcg} setf gdl
    au BufNewFile,BufRead *.ovpn setf openvpn
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File Format
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"file format
set fileformats=unix,dos,mac  "format detect
if has("win32")
	set fileformat=dos
else
	set fileformat=unix
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Encoding Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"set termencoding=big5
"let $LANG="zh_TW.UTF-8"

if has("multi_byte")
    " UTF-8 編碼
	"set fileencodings=utf-8,utf-16le,ucs-2le,ucs-4le,iso8859-1
	set fileencodings=utf-bom,ucs-bom,utf-8,big5,gbk,euc-jp,sjis,euc-kr,latin1
    set encoding=utf-8
    set termencoding=utf-8
    set formatoptions+=mM
	set nobomb

    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif

    if has("win32")
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
        language messages zh_TW.utf-8
    endif
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

map <F11> <ESC>:set fileencoding=big5<CR>
map <F12> <ESC>:set fileencoding=utf8<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Font Setttings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('gui_running')
    if has("win32") || has("win64")
        "set guifont=Lucida_Console:h11
        "set guifont=consolas:h12
        set guifont=Monaco:h11:cANSI
        set guifontwide=DFKai-SB:h14:cCHINESEBIG5  "標楷, support UNICODE
        "set guifontwide=MingLiU:h12:cCHINESEBIG5   "細明, support UNICODE
        "set guifontwide=華康仿宋體W4:h14:cCHINESEBIG5
    elseif has("macunix")
        set guifont=Monaco:h16
        set guifontwide=STKaitiTC-Regular:h18
    elseif has("unix")
        set guifont=Monaco\ 11
        set guifontwide=AR\ PL\ UKai\ TW\ MBE\ 14   "標楷, support UNICODE
    endif
endif

"微軟正黑體：Microsoft JhengHei //Not Work
"新細明體：PMingLiU //Not Work


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HighLight Color Setttings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Line highlight
set cursorline

" hight light lien & column
"if has("gui_running")
"  set cursorline
"  hi cursorline guibg=#D0D0D0
"  set cursorcolumn
"  hi CursorColumn guibg=#D0D0D0
"endif

"highlight cursorline guibg=blue
"20151003" highlight cursorline cterm=none ctermbg=blue
"20151003" highlight comment ctermfg=blue

"highlight Normal ctermbg=black ctermfg=white
"highlight LineNr term=bold cterm=NONE ctermfg=darkGray ctermbg=none gui=none guifg=darkGray guibg=none

" ins-complete options
"20151003" hi Pmenu ctermbg=darkBlue ctermfg=Gray
"20151003" hi PmenuSel ctermbg=darkGreen ctermfg=white


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bash Support Plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on
let g:BASH_AuthorName = 'TT Tsai'
let g:BASH_Email = 'none'
let g:BASH_Company = 'none'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"狀態行顯示內容
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"狀態行顯示內容
" %F 當前文件名
" %m 當前文件修改狀態
" %r 當前文件是否只讀
" %Y 當前文件類型
" %{&fileformat} 當前文件編碼
" %b 當前光標處字符的 ASCII 碼值
" %B 當前光標處字符的十六進制值
" %l 當前光標行號
" %c 當前光標列號
" %V 當前光標虛擬列號 (根據字符所佔字節數計算)
" %p 當前行佔總行數的百分比
" %% 百分號
" %L 當前文件總行數
" 我的狀態行顯示的內容（包括文件類型和解碼）

"gray
hi User1 guifg=#332A19 guibg=#CAE1FF
"green
hi User2 guifg=#008B00 guibg=#CAE1FF
"orange
hi User3 guifg=#EE9A00 guibg=#CAE1FF

hi User1 ctermfg=black ctermbg=gray
hi User2 ctermfg=darkblue ctermbg=gray
hi User3 ctermfg=darkred ctermbg=gray

set statusline=%2*\ %F%*
set statusline+=%1*%m%r%h\ [%Y:%{&ff}:%{&fenc!=''?&fenc:&enc}]\ %w\ \ %*
set statusline+=%3*CWD:\ %r%{CurDir()}%*
set statusline+=%1*%h\ %=%c%V,%l/%L\ \ %p%%%*

" my_file.ino [arduino:avr:uno] [arduino:usbtinyisp] (/dev/ttyACM0:9600)
""function! MyStatusLine()
""  let port = arduino#GetPort()
""  let line = '%f [' . g:arduino_board . '] [' . g:arduino_programmer . ']'
""  if !empty(port)
""    let line = line . ' (' . port . ':' . g:arduino_serial_baud . ')'
""  endif
""  return line
""endfunction
""setl statusline=%!MyStatusLine()

" 顯示狀態欄 (默認值為 1, 無法顯示狀態欄)
" 譯註:默認情況下,只有兩個以上的窗口才顯示狀態欄.其值定義為
" 本選項的值影響最後一個窗口何時有狀態行:
" 0: 永不
" 1: 只有在有至少兩個窗口時
" 2: 總是
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 函數定義
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" if file not opened, create a new tab, or switch to the opened file
function! SwitchToBuf(filename)
 " find in current tab
 let bufwinnr = bufwinnr(a:filename)
 if bufwinnr != -1
 exec bufwinnr . "wincmd w"
 return
 else
 " search each tab
 tabfirst
 let tb = 1
 while tb <= tabpagenr("$")
 let bufwinnr = bufwinnr(a:filename)
 if bufwinnr != -1
 exec "normal " . tb . "gt"
 exec bufwinnr . "wincmd w"
 return
 endif
 tabnext
 let tb = tb +1
 endwhile
 " not exist, new tab
 exec "tabnew " . a:filename
 endif
endfunction


function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

"function! MyDiff()
"  let opt = '-a --binary '
"  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
"  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
"  let arg1 = v:fname_in
"  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
"  let arg2 = v:fname_new
"  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
"  let arg3 = v:fname_out
"  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
"  let eq = ''
"  if $VIMRUNTIME =~ ' '
"    if &sh =~ '\<cmd'
"      let cmd = '""' . $VIMRUNTIME . '\diff"'
"      let eq = '"'
"    else
"      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
"    endif
"  else
"    let cmd = $VIMRUNTIME . '\diff'
"  endif
"  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
"endfunction


function! BufPos_ActivateBuffer(num)
 let l:count = 1
 for i in range(1, bufnr("$"))
 if buflisted(i) && getbufvar(i, "&modifiable")
 if l:count == a:num
 exe "buffer " . i
 return
 endif
 let l:count = l:count + 1
 endif
 endfor
 echo "No buffer!"
endfunction
function! BufPos_Initialize()
 for i in range(1, 9)
 exe "map <M-" . i . "> :call BufPos_ActivateBuffer(" . i . ")<CR>"
 endfor
 exe "map <M-0> :call BufPos_ActivateBuffer(10)<CR>"
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction


" 譯註:簡單說一下其功能,設置了一個函數CurDir(),該函數調用了getcwd()
" 函數,getcwd()的作用是返回當前路徑這個值.
function! CurDir()
    let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
    return curdir
endfunction


func! Cwd()
  let cwd = getcwd()
  return "e " . cwd
endfunc


"command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GuiTabTool
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set up tab tooltips with every buffer name
function! GuiTabToolTip()
  let tip = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  for bufnr in bufnrlist
    " separate buffer entries
    if tip!=''
      let tip .= " \n "
    endif
    " Add name of buffer
    let name=bufname(bufnr)
    if name == ''
      " give a name to no name documents
      if getbufvar(bufnr,'&buftype')=='quickfix'
        let name = '[Quickfix List]'
      else
        let name = '[No Name]'
      endif
    endif
    let tip.=name
    " add modified/modifiable flags
    if getbufvar(bufnr, "&modified")
      let tip .= ' [+]'
    endif
    if getbufvar(bufnr, "&modifiable")==0
      let tip .= ' [-]'
    endif
  endfor
  return tip
endfunction

function! FileNamePath()
  let tip = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  for bufnr in bufnrlist
    " separate buffer entries
    if tip!=''
      let tip .= " \n "
    endif
    " Add name of buffer
	let name=bufname(bufnr)
	if name == ''
		" give a name to no name documents
		if getbufvar(bufnr,'&buftype')=='quickfix'
			let name = '[Quickfix List]'
		else
			let name = '[No Name]'
		endif
	endif
	let tip.=name
    " add modified/modifiable flags
"    if getbufvar(bufnr, "&modified")
"      let tip .= ' [+]'
"    endif
"    if getbufvar(bufnr, "&modifiable")==0
"      let tip .= ' [-]'
"    endif
  endfor
  return tip
endfunction

" set up tab labels with tab number, buffer name, number of windows
function! GuiTabLabel()
  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let label = '+'
      break
    endif
  endfor
  " Append the tab number
  let label .= v:lnum.': '

  " Append the number of windows in the tab page
  let wincount = tabpagewinnr(v:lnum, '$')

  "let names = FileNamePath()
  let names = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  for bufnr in bufnrlist
    " separate buffer entries
    if names != ''
      let names .= " \n "
    endif
    " Add name of buffer
	let name=bufname(bufnr)
	if name == ''
		" give a name to no name documents
		if getbufvar(bufnr,'&buftype')=='quickfix'
			let name = '[Quickfix List]'
		else
			let name = '[No Name]'
		endif
	endif

	"ignore NERD_tree window
	if name == 'NERD_tree_1'
		let wincount = wincount -1
	else
    	let names.=name
	endif
  endfor

  let label .= names
  let label .= '  [' . wincount . ']'

  return label

endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! SetTabLine()
  " NOTE: left/right padding of each tab was hard coded as 1 space.
  " NOTE: require Vim 7.3 strwidth() to display fullwidth text correctly.

  " settings
  "最小分頁寬度（0: 不限）
  let tabMinWidth = 0
  "最大分頁寬度（0: 不限）
  let tabMaxWidth = 40
  "設定 tabDivideEquel 有效時，採用的最小分頁寬度
  let tabMinWidthResized = 15
  "目前分頁左右至少顯示幾個分頁
  let tabScrollOff = 5
  "分頁過長而被截短時，要顯示的替代文字
  let tabEllipsis = '…'
  "分頁總長超出畫面時，是否自動均分各分頁寬度
  let tabDivideEquel = 0

  let s:tabLineTabs = []

  let tabCount = tabpagenr('$')
  let tabSel = tabpagenr()

  " fill s:tabLineTabs with {n, filename, split, flag} for each tab
  for i in range(tabCount)
    let tabnr = i + 1
    let buflist = tabpagebuflist(tabnr)
    let winnr = tabpagewinnr(tabnr)
    let bufnr = buflist[winnr - 1]

    let filename = bufname(bufnr)
    let filename = fnamemodify(filename, ':p:t')
    let buftype = getbufvar(bufnr, '&buftype')
    if filename == ''
      if buftype == 'nofile'
        let filename .= '[Scratch]'
      else
        let filename .= '[New]'
      endif
    endif
    let split = ''
    let winCount = tabpagewinnr(tabnr, '$')
    if winCount > 1   " has split windows
      let split .= winCount
    endif
    let flag = ''
    if getbufvar(bufnr, '&modified')  " modified
      let flag .= '+'
    endif
    if strlen(flag) > 0 || strlen(split) > 0
      let flag .= ' '
    endif

    call add(s:tabLineTabs, {'n': tabnr, 'split': split, 'flag': flag, 'filename': filename})
  endfor

  " variables for final oupout
  let s = ''
  let l:tabLineTabs = deepcopy(s:tabLineTabs)

  " overflow adjustment
  " 1. apply min/max tabWidth option
  if s:TabLineTotalLength(l:tabLineTabs) > &columns
    unlet i
    for i in l:tabLineTabs
      let tabLength = s:CalcTabLength(i)
      if tabLength < tabMinWidth
        let i.filename .= repeat(' ', tabMinWidth - tabLength)
      elseif tabMaxWidth > 0 && tabLength > tabMaxWidth
        let reserve = tabLength - StrWidth(i.filename) + StrWidth(tabEllipsis)
        if tabMaxWidth > reserve
          let i.filename = StrCrop(i.filename, (tabMaxWidth - reserve), '~') . tabEllipsis
        endif
      endif
    endfor
  endif
  " 2. try divide each tab equal-width
  if tabDivideEquel
    if s:TabLineTotalLength(l:tabLineTabs) > &columns
      let divideWidth = max([tabMinWidth, tabMinWidthResized, &columns / tabCount, StrWidth(tabEllipsis)])
      unlet i
      for i in l:tabLineTabs
        let tabLength = s:CalcTabLength(i)
        if tabLength > divideWidth
          let i.filename = StrCrop(i.filename, divideWidth - StrWidth(tabEllipsis), '~') . tabEllipsis
        endif
      endfor
    endif
  endif
  " 3. ensure visibility of current tab
  let rhWidth = 0
  let t = tabCount - 1
  let rhTabStart = min([tabSel - 1, tabSel - tabScrollOff])
  while t >= max([rhTabStart, 0])
    let tab = l:tabLineTabs[t]
    let tabLength = s:CalcTabLength(tab)
    let rhWidth += tabLength
    let t -= 1
  endwhile
  while rhWidth >= &columns
    let tab = l:tabLineTabs[-1]
    let tabLength = s:CalcTabLength(tab)
    let lastTabSpace = &columns - (rhWidth - tabLength)
    let rhWidth -= tabLength
    if rhWidth > &columns
      call remove(l:tabLineTabs, -1)
    else
      " add special flag (will be removed later) indicating that how many
      " columns could be used for last displayed tab.
      if tabSel <= tabScrollOff || tabSel < tabCount - tabScrollOff
        let tab.flag .= '>' . lastTabSpace
      endif
    endif
  endwhile

  " final ouput
  unlet i
  for i in l:tabLineTabs
    let tabnr = i.n

    let split = ''
    if strlen(i.split) > 0
      if tabnr == tabSel
        let split = '%#TabLineSplitNrSel#' . i.split .'%#TabLineSel#'
      else
        let split = '%#TabLineSplitNr#' . i.split .'%#TabLine#'
      endif
    endif

    let text = ' ' . split . i.flag . i.filename . ' '

    if i.n == l:tabLineTabs[-1].n
       if match(i.flag, '>\d\+') > -1 || i.n < tabCount
        let lastTabSpace = matchstr(i.flag, '>\zs\d\+')
        let i.flag = substitute(i.flag, '>\d\+', '', '')
        if lastTabSpace <= strlen(i.n)
          if lastTabSpace == 0
            let s = strpart(s, 0, strlen(s) - 1)
          endif
          let s .= '%#TabLineMore#>'
          continue
        else
          let text = ' ' . i.split . i.flag . i.filename . ' '
          let text = StrCrop(text, (lastTabSpace - strlen(i.n) - 1), '~') . '%#TabLineMore#>'
          let text = substitute(text, ' ' . i.split, ' ' . split, '')
        endif
       endif
    endif

    let s .= '%' . tabnr . 'T'  " start of tab N

    if tabnr == tabSel
      let s .= '%#TabLineNrSel#' . tabnr . '%#TabLineSel#'
    else
      let s .= '%#TabLineNr#' . tabnr . '%#TabLine#'
    endif

    let s .= text

  endfor

  let s .= '%#TabLineFill#%T'
  return s
endf

function! s:CalcTabLength(tab)
  return strlen(a:tab.n) + 2 + strlen(a:tab.split) + strlen(a:tab.flag) + StrWidth(a:tab.filename)
endf

function! s:TabLineTotalLength(dict)
  let length = 0
  for i in (a:dict)
    let length += strlen(i.n) + 2 + strlen(i.split) + strlen(i.flag) + StrWidth(i.filename)
  endfor
  return length
endf




" }}}2   字串長度（column 數）   {{{2

  function StrWidth(str)
    if exists('*strwidth')
      return strwidth(a:str)
    else
      let strlen = strlen(a:str)
      let mstrlen = strlen(substitute(a:str, ".", "x", "g"))
      if strlen == mstrlen
        return strlen
      else
        " Note: 暫不處理全形字（以下值不正確）
        return strlen
      endif
    endif
  endf

" }}}2   依字串長度（column 數）裁切多餘文字   {{{2

  function! StrCrop(str, len, ...)
    let l:padChar = a:0 > 0 ? a:1 : ' '
    if exists('*strwidth')
      let text = substitute(a:str, '\%>' . a:len . 'c.*', '', '')
      let remainChars = split(substitute(a:str, text, '', ''), '\zs')
      while strwidth(text) < a:len
        let longer = len(remainChars) > 0 ? (text . remove(remainChars, 0)) : text
        if strwidth(longer) < a:len
          let text = longer
        else
          let text .= l:padChar
        endif
      endwhile
      return text
    else
      " Note: 暫不處理全形字（以下值不正確）
      return substitute(a:str, '\%>' . a:len . 'c.*', '', '')
    endif
  endf




hi TabLine           cterm=underline ctermfg=15    ctermbg=242   gui=underline guibg=#6c6c6c guifg=White
hi TabLineSel        cterm=bold      gui=NONE      guifg=White
hi TabLineNr         cterm=underline ctermbg=238   guibg=#444444
hi TabLineNrSel      cterm=bold      ctermfg=45    guifg=#00d7ff
hi TabLineFill       cterm=reverse   gui=reverse
hi TabLineMore       cterm=underline ctermfg=White ctermbg=236   gui=underline guifg=White   guibg=#303030
hi TabLineSplitNr    cterm=underline ctermfg=148 ctermbg=240   gui=underline,italic guifg=#afd700   guibg=#6c6c6c
hi TabLineSplitNrSel cterm=NONE      ctermfg=148 ctermbg=236   gui=NONE,italic      guifg=#afd700   guibg=#303030
