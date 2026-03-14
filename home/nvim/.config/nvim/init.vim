let g:polyglot_disabled = ['latex']

" vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
	Plug 'ldx/vim-indentfinder'
	Plug 'junegunn/goyo.vim'
	Plug 'sheerun/vim-polyglot'
	Plug 'junegunn/limelight.vim'
	Plug 'lervag/vimtex'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	Plug 'zhou13/vim-easyescape'
	Plug 'crusoexia/vim-monokai'
	Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()
let g:asmsyntax = 'nasm'

" vimtex
	let g:tex_flavor = 'latex'
	let g:vimtex_compiler_latexmk_engines = {
	\ '_'                : '-pdf',
	\ 'pdflatex'         : '-pdf',
	\ 'dvipdfex'         : '-pdfdvi',
	\ 'lualatex'         : '-lualatex',
	\ 'xelatex'          : '-xelatex',
	\ 'context (pdftex)' : '-pdf -pdflatex=texexec',
	\ 'context (luatex)' : '-pdf -pdflatex=context',
	\ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
	\}
	

" markdown-preview
	let g:mkdp_refresh_slow = 0

" easy-scape
	let g:easyescape_chars = { "j": 1, "k": 1 }
	let g:easyescape_timeout = 100
	cnoremap jk <ESC>
	cnoremap kj <ESC>	

" set *.gv files to dot syntax
	au BufRead,BufNewFile *.gv set filetype=dot	

" misc
	syntax on
	nnoremap c "_c
	set nu
	set showcmd		" ) command in status line.
	set showmatch		" Show matching brackets.
	set matchtime=3
	set ignorecase		" Do case insensitive matching
	set smartcase		" Do smart case matching
	set incsearch		" Incremental search
	set nohlsearch
	set autowrite		" Automatically save before commands like :next and :make
	set hidden		" Hide buffers when they are abandoned
	set mouse=a		" Enable mouse usage (all modes)
	set breakindent
	set breakindentopt=shift:4,sbr
	set sbr=↳
	set linebreak
	set laststatus=1

" cursor 
	:set guicursor=n-v-c-i-ci-ve:block
		\,i-ci-ve:ver25
		\,r-cr:hor20
		\,o:hor50
		\,a:blinkon1-blinkoff1-blinkwait1

" menu for completion
	set wildmenu

" colorscheme
	" monokai
	set termguicolors
	let g:monokai_term_italic = 1
	let g:monokai_gui_italic = 1
	colorscheme monokai

" Goyo
	map <leader>f :Goyo \| set linebreak<CR>

" jump to the last position when reopening a file
	if has("autocmd")
		au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	endif

" identation
	if has("autocmd")
  		filetype plugin indent on
	endif

	set expandtab
	set tabstop=4
	set shiftwidth=4

	set cursorline
	set ttyfast

" easier buffer navigation
	nnoremap <silent> [b :bprevious<CR>
	nnoremap <silent> ]b :bnext<CR>
	nnoremap <silent> [B :bfirst<CR>
	nnoremap <silent> ]B :blast<CR>

" easier split navigation
	nnoremap <C-J> <C-W><C-J>
	nnoremap <C-K> <C-W><C-K>
	nnoremap <C-L> <C-W><C-L>
	nnoremap <C-H> <C-W><C-H>

	set splitbelow
	set splitright

" line navigation
	nnoremap j gj
	nnoremap k gk

" command line mode mappings
	cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" copy/paste
	vnoremap <C-c> "+y
	map <C-p> "+P

" snippets
	nnoremap <leader>lln :-1read ~/.vim/snippets/lecture-notes-template.tex<CR>/\\textbf<CR>f{a

" Source a global configuration file if available
	if filereadable("/etc/vim/vimrc.local")
		source /etc/vim/vimrc.local
	endif


	if empty(v:servername) && exists('*remote_startserver')
		call remote_startserver('VIM')
	endif

