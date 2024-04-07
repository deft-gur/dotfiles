" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype on

" TODO: Load plugins here (pathogen or vundle)
" auto install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
"let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin("~/.config/nvim/plugged")

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
" File navigation
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Plug 'Xuyuanp/nerdtree-git-plugin'

" Using a non-default branch
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" fzf finder telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim'
" Harpoon for file navigation
Plug 'ThePrimeagen/harpoon'

Plug 'airblade/vim-rooter'

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

" add vim-plug support for colorscheme plugins
Plug 'morhetz/gruvbox'
" Initialize plugin system

" add vim airline which gives you a status bar at bottom of vim
Plug 'vim-airline/vim-airline'


" Taglist
Plug 'majutsushi/tagbar', { 'on': 'TagbarOpenAutoClose' }

" Error checking
"Plug 'w0rp/ale'

" Auto Complete
"Plug 'Valloric/YouCompleteMe'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Undo Tree
Plug 'mbbill/undotree/'

" Other visual enhancement
Plug 'nathanaelkane/vim-indent-guides'
Plug 'itchyny/vim-cursorword'

" Git
Plug 'rhysd/conflict-marker.vim'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'gisphm/vim-gitignore', { 'for': ['gitignore', 'vim-plug'] }
Plug 'zivyangll/git-blame.vim'

" HTML, CSS, JavaScript, PHP, JSON, etc.
"Plug 'elzr/vim-json'
"Plug 'hail2u/vim-css3-syntax'
"Plug 'spf13/PIV', { 'for' :['php', 'vim-plug'] }
"Plug 'gko/vim-coloresque', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
"Plug 'pangloss/vim-javascript', { 'for' :['javascript', 'vim-plug'] }
"Plug 'mattn/emmet-vim'

" Python
Plug 'vim-scripts/indentpython.vim'

" Markdown
"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
Plug 'vimwiki/vimwiki'

" Bookmarks
"Plug 'kshenoy/vim-signature'

" Other useful utilities
"Plug 'godlygeek/tabular' " type ;Tabularize /= to align the =
"Plug 'junegunn/goyo.vim' " distraction free writing mode
"Plug 'scrooloose/nerdcommenter' " in <space>cc to comment a line
Plug 'gcmt/wildfire.vim' " in Visual mode, type i' to select all text in '', or type i) i] i} ip
Plug 'jiangmiao/auto-pairs'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround' " type ysks' to wrap the word with '' or type cs'` to change 'word' to `word`
Plug 'pseewald/vim-anyfold'
Plug 'ggandor/leap.nvim'
Plug 'cbochs/portal.nvim'

" Dependencies
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'kana/vim-textobj-user'
Plug 'fadein/vim-FIGlet'

" Tmux 
Plug 'christoomey/vim-tmux-navigator'

" Trouble for vim https://github.com/folke/trouble.nvim
" this is only for nvim
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

" using pywal for vim
Plug 'dylanaraps/wal.vim'

" using latex
Plug 'lervag/vimtex'

" plugin for r like rstudio
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}

" Plugin for NeoMake which makes file by exuecting ':Neomake' asynchronously
"Plug 'neomake/neomake'

" Ctags and CScopes
" The following plugin will not be working for nvim 0.9+ since nvim removed the
" support for cscope options.
"Plug 'brookhong/cscope.vim'
Plug 'dhananjaylatkar/cscope_maps.nvim'
Plug 'ludovicchabant/vim-gutentags'
" This works nicely with gutentags for cscope (maybe cscope.vim is not needed)
Plug 'skywind3000/gutentags_plus'

" For Sage Math.
Plug 'petRuShka/vim-sage'

" checkhealth for vim
if !has('nvim')
    Plug 'rhysd/vim-healthcheck'
endif
call plug#end()


" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

filetype indent on
filetype plugin on

" for vim conflict with terminal conflict 
let &t_ut=''

" TODO: Pick a leader key
let mapleader = " "

" Security
set modelines=0

" Show line numbers
set relativenumber
set number

" Show line cursor
set cursorline

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
" comment out the flash
"set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Show list commands by typing tab under : 
set wildmenu

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
" disable same hlsearch after reload/reopen annother file
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase
set showmatch
noremap <LEADER><CR> :nohlsearch<CR>
map <leader><space> :let @/=''<cr> " clear search

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Textmate holdouts

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
"map <leader>l :set list!<CR> " Toggle tabs and EOL

" Color scheme (terminal)
"set t_Co=256
set background=dark
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1
colorscheme gruvbox 
"colorscheme wal
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
" colorscheme solarized

" set column
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

" <CR> is enter, set 'R' to reload vim Configure 
"map R :source $MYVIMRC<CR>

" set Cap "J" and "K" to scroll 5 times faster
"noremap J 5j
"noremap K 5k

" NOTE: conflict with leap
" settings for spliting screens
" remember ctrl+w <directio> moves curosr
" use :edit <file path> to edit another file
"map sl :set splitright<CR>:vsplit<CR>
"map sh :set nosplitright<CR>:vsplit<CR>
"map sk :set nosplitbelow<CR>:split<CR>
"map sj :set splitbelow<CR>:split<CR>
" map cursor focus keys
"map <LEADER>l <C-w>l
"map <LEADER>h <C-w>h
"map <LEADER>k <C-w>k
"map <LEADER>j <C-w>j

" resize map for splitted windows
map <up> :res +5<CR>
map <down> :res -5<CR>
map <right> :vertical resize+5<CR>
map <left> :vertical resize-5<CR>

" keys for making new tab in vim
map tn :tabe<CR>
map th :tabp<CR>
map tl :tabnext<CR>

" show trailing spaces
set list
"set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<
",space:␣

" tell vim to run command in current directory
"set autochdir

" set cursor to the place where we last closed the file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Config NERDTree
"map tt :NERDTreeToggle<CR>

" NERDTree-git
" ==
" == NERDTree-git
" ==
" let g:NERDTreeIndicatorMapCustom = {
"     \ "Modified"  : "✹",
"     \ "Staged"    : "✚",
"     \ "Untracked" : "✭",
"     \ "Renamed"   : "➜",
"     \ "Unmerged"  : "═",
"     \ "Deleted"   : "✖",
"     \ "Dirty"     : "✗",
"     \ "Clean"     : "✔︎",
"     \ "Unknown"   : "?"
"     \ }
" NERDTree couldn't execute system function in fish 
" so we need to add the following line
" set shell=sh

" Python-syntax
let g:python_highlight_all = 1

" Undotree
noremap <F5> :UndotreeToggle<CR>

set spell

" You Complete ME
"nnoremap gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
"nnoremap g/ :YcmCompleter GetDoc<CR>
"nnoremap gt :YcmCompleter GetType<CR>
"nnoremap gr :YcmCompleter GoToReferences<CR>
"let g:ycm_autoclose_preview_window_after_completion=0
"let g:ycm_autoclose_preview_window_after_insertion=1
"let g:ycm_use_clangd = 1
"let g:ycm_python_binary_path = g:ycm_python_interpreter_path


" COC configurations
let g:coc_global_extensions = [
      \'coc-clang-format-style-options', 
      \'coc-clangd', 
      \'coc-css', 
      \'coc-diagnostic',
      \'coc-eslint', 
      \'coc-git', 
      \'coc-html', 
      \'coc-html-css-support', 
      \'coc-htmlhint', 
      \'coc-json', 
      \'coc-pyright',
      \'coc-r-lsp',
      \'coc-sh',
      \'coc-tsserver', 
      \'coc-vimlsp', 
      \'coc-vimtex',
      \]

set updatetime=300
set shortmess+=c
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
" show all diagnostic
"nnoremap <silent><nowait> <LEADER>L  :<C-u>CocList diagnostics<cr>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Formatting selected code.
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

" use :Prettier to format current buffer
"command! -nargs=0 Prettier :CocCommand prettier.formatFile

" K to show documentation, and the following function enables hover to show
"  documentation
"nnoremap <silent> K :call CocAction('doHover')<CR>
"function! ShowDocIfNoDiagnostic(timer_id)
"  if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
"    silent call CocActionAsync('doHover')
"  endif
"endfunction

"function! s:show_hover_doc()
"  call timer_start(500, 'ShowDocIfNoDiagnostic')
"endfunction

"autocmd CursorHoldI * :call <SID>show_hover_doc()
"autocmd CursorHold * :call <SID>show_hover_doc()

" coc-git settings
" lightline
let g:lightline = {
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'ctrlpmark', 'git', 'diagnostic', 'cocstatus', 'filename', 'method' ]
  \   ],
  \   'right':[
  \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
  \     [ 'blame' ]
  \   ],
  \ },
  \ 'component_function': {
  \   'blame': 'LightlineGitBlame',
  \ }
\ }

function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction

autocmd User CocGitStatusChange {command}

"copy to clip board
map <leader>y "+y 
map <leader>p "+p

"git blame settigns
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>
" for telescope
cmap <C-R> <Plug>(TelescopeFuzzyCommandSearch)
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Harpoon config
nnoremap <leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>, :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>2 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>3 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>4 :lua require("harpoon.ui").nav_file(4)<CR>

map _v :e $MYVIMRC<CR>
map _x :source $MYVIMRC<CR>

nnoremap <leader>l :call ToggleLocationList()<CR>

" These Cscope options will not work for nvim 0.9+
" CScope settings
"nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
"" s: Find this C symbol
"nnoremap  <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
"" g: Find this definition
"nnoremap  <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
"" d: Find functions called by this function
"nnoremap  <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
"" c: Find functions calling this function
"nnoremap  <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
"" t: Find this text string
"nnoremap  <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
"" e: Find this egrep pattern
"nnoremap  <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
"" f: Find this file
"nnoremap  <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
"" i: Find files #including this file
"nnoremap  <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>
"

"let g:cscope_silent = 1
"setup cscope_maps for nvim 0.9+
lua require("cscope_maps").setup({})

" This is to disable coc on certain type files in particular I was having
" trouble to read assembly code .S files
function! s:disable_coc_for_type()
        let l:filesuffix_blacklist = ['S']
  if index(l:filesuffix_blacklist, expand('%:e')) != -1
    let b:coc_enabled = 0
  endif
endfunction
autocmd BufRead,BufNewFile * call s:disable_coc_for_type()

" For alphabet subscripts:
"alphsubs ---------------------- {{{
execute "digraphs as " . 0x2090
execute "digraphs es " . 0x2091
execute "digraphs hs " . 0x2095
execute "digraphs is " . 0x1D62
execute "digraphs js " . 0x2C7C
execute "digraphs ks " . 0x2096
execute "digraphs ls " . 0x2097
execute "digraphs ms " . 0x2098
execute "digraphs ns " . 0x2099
execute "digraphs os " . 0x2092
execute "digraphs ps " . 0x209A
execute "digraphs rs " . 0x1D63
execute "digraphs ss " . 0x209B
execute "digraphs ts " . 0x209C
execute "digraphs us " . 0x1D64
execute "digraphs vs " . 0x1D65
execute "digraphs xs " . 0x2093

execute "digraphs aS " . 0x1d43
execute "digraphs bS " . 0x1d47
execute "digraphs cS " . 0x1d9c
execute "digraphs dS " . 0x1d48
execute "digraphs eS " . 0x1d49
execute "digraphs fS " . 0x1da0
execute "digraphs gS " . 0x1d4d
execute "digraphs hS " . 0x02b0
execute "digraphs iS " . 0x2071
execute "digraphs jS " . 0x02b2
execute "digraphs kS " . 0x1d4f
execute "digraphs lS " . 0x02e1
execute "digraphs mS " . 0x1d50
execute "digraphs nS " . 0x207f
execute "digraphs oS " . 0x1d52
execute "digraphs pS " . 0x1d56
execute "digraphs rS " . 0x02b3
execute "digraphs sS " . 0x02e2
execute "digraphs tS " . 0x1d57
execute "digraphs uS " . 0x1d58
execute "digraphs vS " . 0x1d5b
execute "digraphs wS " . 0x02b7
execute "digraphs xS " . 0x02e3
execute "digraphs yS " . 0x02b8
execute "digraphs zS " . 0x1dbb

execute "digraphs AS " . 0x1D2C
execute "digraphs BS " . 0x1D2E
execute "digraphs DS " . 0x1D30
execute "digraphs ES " . 0x1D31
execute "digraphs GS " . 0x1D33
execute "digraphs HS " . 0x1D34
execute "digraphs IS " . 0x1D35
execute "digraphs JS " . 0x1D36
execute "digraphs KS " . 0x1D37
execute "digraphs LS " . 0x1D38
execute "digraphs MS " . 0x1D39
execute "digraphs NS " . 0x1D3A
execute "digraphs OS " . 0x1D3C
execute "digraphs PS " . 0x1D3E
execute "digraphs RS " . 0x1D3F
execute "digraphs TS " . 0x1D40
execute "digraphs US " . 0x1D41
execute "digraphs VS " . 0x2C7D
execute "digraphs WS " . 0x1D42
"}}}

"" Anyfold configuration:
"autocmd Filetype * AnyFoldActivate
"
"set foldlevel=0
"
"autocmd Filetype cpp set foldignore=#/
"let g:anyfold_identify_comments=2
"
"" activate anyfold by default
"augroup anyfold
"    autocmd!
"    autocmd Filetype <filetype> AnyFoldActivate
"augroup END
"
"" disable anyfold for large files
"let g:LargeFile = 1000000 " file is large if size greater than 1MB
"autocmd BufReadPre,BufRead * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
"function LargeFile()
"    augroup anyfold
"        autocmd! " remove AnyFoldActivate
"        autocmd Filetype <filetype> setlocal foldmethod=indent " fall back to indent folding
"    augroup END
"endfunction

" source init.lua file
lua require('init')
