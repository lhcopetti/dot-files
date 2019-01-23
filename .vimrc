"""""" Function definitions """""" 
function! CreateDir (dir)
	if isdirectory(a:dir)
		return
	endif
	
	call mkdir(a:dir, "p")
	echom "Created directory: " . a:dir
endfunction


"""""" The most SIMPLE Vim commands """""" 

" Display line numbers by default
set number

" Hide the unsaved buffer, instead of closed 
" (which might show the message: No write since last change)
set hidden

" Do not wrap lines by default
set nowrap

" Disable arrow keys
inoremap <Up>		<NOP>
nnoremap <Up>		<NOP>
inoremap <Down>		<NOP>
nnoremap <Down>		<NOP>
inoremap <Left>		<NOP>
nnoremap <Left>		<NOP>
inoremap <Right>	<NOP>
nnoremap <Right>	<NOP>

" Use CapsLock key as 'Exit insert mode'

" Search for the word under cursor
nnoremap K :silent :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Disable menu, toolbar and scrolls
:set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

" Attempt to automatically install Plug
"if empty(glob('~/.vim/autoload/plug.vim'))
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif



" Plugin declarations
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'

" Disabling you complete me because its classpath are not always correct
" Favoring eclim instead
Plug 'valloric/youcompleteme'
Plug 'airblade/vim-gitgutter'
Plug 'janko-m/vim-test'
Plug 'sjl/badwolf'

" Themes
"Plug 'dracula/vim'
Plug 'altercation/vim-colors-solarized'

call plug#end()


"""""" Vim-Test Plugin Configuration """""" 
nnoremap t<C-n> :TestNearest<CR>
nnoremap t<C-f> :TestFile<CR>
nnoremap t<C-s> :TestSuite<CR>
nnoremap t<C-l> :TestLast<CR>
nnoremap t<C-g> :TestVisit<CR>


"""""" Airline Plugin Configuration """""" 
let g:airline#extensions#tabline#enabled = 1


"""""" YouCompleteMe Plugin Configuration """""" 
" Remember to run install.py or follow the installation instructions as this
" plugin depends on compiled libraries to get fast completions
let g:ycm_always_populate_location_list = 1
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_signs = 0 
let g:ycm_enable_diagnostic_highlighting = 0
let g:syntastic_java_checkers = []


"""""" TagBar Plugin Configuration """""" 
" Remember to install universal-ctags (mantained ctags implementation)
nnoremap <F8> :TagbarToggle<CR>


"""""" NERDTree Plugin Configuration """""" 

" Remapping NERDTree to an easier shortcut
nnoremap <Leader>f :NERDTreeFocus<CR>
nnoremap <Leader>v :NERDTreeFind<CR>

" Automatically open NERDTree on vim load
autocmd vimenter * NERDTree

" Hide the Press '?' for help
let NERDTreeMinimalUI = 1

" Close NERDTree if it is the last buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"""""" THEMES """""""""

" Instructions to enable the dracula theme from: https://vimawesome.com/plugin/vim
"syntax on
"color dracula

" Instructions to enable the solarized theme: https://vimawesome.com/plugin/vim-colors-solarized-ours
syntax enable
set background=dark
colorscheme badwolf

" Airline theme configuration
autocmd VimEnter * :AirlineTheme badwolf

"""""" CtrlP Plugin Configuration """""" 

"  Default mapping for the CtrlP plugin
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Increase max file count and depth so that CtrlP finds all files on big projects
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=100

" Ignore these files so that CtrlP does not list them
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe

" Use an external scanner to ignore files that are ignored by git (.gitignore)
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" The Silver Searcher
" https://robots.thoughtbot.com/faster-grepping-in-vim
"if executable('ag')
"  set grepprg=ag\ --nogroup\ --nocolor
"
"  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
"  let g:ctrlp_user_command = 'ag %s -l --follow --nocolor -g ""'
"
"  " ag is fast enough that CtrlP doesn't need to cache
"  let g:ctrlp_use_caching = 0
"endif

" The ripgrep (honors .gitiginore, unlike ag)
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat^=%f:%l:%c:%m

  " Use rg in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'

  " rg is fast enough that CtrlP doesn't need to cache
  " Do we really need to turn off caching?
"  let g:ctrlp_use_caching = 0
endif

" Set CtrlP to follow symlinks
" This is not taken into consideration if the g:ctrlp_user_command variable is
" set
let g:ctrlp_follow_symlinks = 1

let g:ctrlp_working_path_mode = ''
let g:ctrlp_root_markers = [ 'ctrlp_root.marker' ]


"""""" Ack.vim Plugin Configuration """""" 
"if executable('ag')
"  let g:ackprg = 'ag --vimgrep --follow'
"endif
" Not using ag anymore because it doesn't do a good job of ignoring files or
" patterns that are present in the .gitignore file.

if executable('rg')
    let g:ackprg = 'rg --vimgrep --no-heading'
endif


"""""" Helper Ack Functions """"""
fun! AckJS( args ) "{{{
   execute 'Ack -g"*.js" -g"!node/" -g"!node_modules/" -g"!vendor/"' a:args

endfunction "}}}

command! -nargs=* Ackjs call AckJS(' <args> ')

"""""" Other Configurations """""" 

" Set GUI font
" Use the command: :set guifont=* to select a font using the system's font
" picker, then to print the selected font, use: :set &guifont or :set guifont?
if has("gui_running")
    if has("gui_win32")
        " For YCM, didn't work though. don't want to install cmake to run install.py
        " I'm just going to leave it here because it doesn't hurt.
        set encoding=utf-8
        set guifont=Consolas:h11:cANSI
    elseif has("gui_gtk3")
        " If you don't have this font installed, add it using the commands
        " below (Ubuntu):
        "
        " sudo apt-get install fonts-inconsolata -y
        " sudo fc-cache -fv
        " 
        set guifont="Inconsolata Medium 11"
    else
        echom "Could not detect system, using default font"
    endif
endif

" Curious exercises from learnvimscriptthehardway.com
" redraw | echo ">^.^<"
autocmd VimEnter * echom ">^.^<"

" The line numbers are relative to the cursor position
" Never used it, I don't think it as useful as I once though
" :set relativenumber


" Move swp files to a different location (better git diffs)
" No more .swp files hanging around
call CreateDir($HOME . "/.vim/backup/")
call CreateDir($HOME . "/.vim/swap/")
call CreateDir($HOME . "/.vim/undo/")

set backupdir=~/.vim/swap//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Hate tabs, only ever use spaces
set tabstop=4
set shiftwidth=4
set expandtab


" .template files should be treated as html (filetype and syntax highlighting)
autocmd BufNewFile,BufRead *.template set filetype=html


" Add leader mapping to make it super easy to edit and source the ~/.vimrc
" file
nnoremap <leader>ev :belowright split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Let's use smartcase, shall we?
set ignorecase
set smartcase

" Highlight the searching patterns
set hlsearch

" Remap the <esc> key to the 'jk' pattern
inoremap jk <esc>
inoremap <esc> <nop>

" Remap ; (next f, F, t or T) to be the colon command
" Is is a lot more ergonomic to get to go to command mode without having to
" stretch your pinky :)
nnoremap ; :
nnoremap : ;


"""""" Eclim Plugin Configuration """""" 
let g:EclimJavaValidate = 1
let g:EclimMakeLCD = 1

" I'm still haven't figure it out how to be effective using eclim
" but when the time comes, I might use this mapping again.
" nnoremap <Leader>ev :Validate<CR>
