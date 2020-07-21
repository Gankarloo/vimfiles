"=== define some variables
if has('win64')                     "| Windows
  " path to user vim dir
  let g:vimfiles = $HOME . '\vimfiles\'
  " location of minpac
  let g:minpacdir = g:vimfiles . 'pack\minpac\opt\minpac'
else                                "| Unix
  " path to user vim dir
  let g:vimfiles = $HOME . '/.vim/'
  " location of minpac
  let g:minpacdir = g:vimfiles . 'pack/minpac/opt/minpac'
endif

" coc extensions. data_home needs to be defined before coc is loaded.
let g:coc_data_home = vimfiles . 'coc-data'
let g:coc_global_extensions=[
  \ 'coc-lists',
  \ 'coc-powershell',
  \ 'coc-json',
  \ 'coc-snippets',
  \ 'coc-python',
  \ 'coc-yaml',
  \ 'coc-xml',
  \ 'coc-sh',
  \ 'coc-markdownlint',
  \ 'coc-vimlsp'
  \ ]

"=== Auto install package manager
if empty(glob(g:minpacdir))         "| if dir is empty
  execute 'silent !git clone https://github.com/k-takata/minpac.git ' . g:minpacdir
  let g:minpacFirstRun = 1
endif

"=== Load package manager
packadd minpac

call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})       "| Package manager
" Add other plugins here.
call minpac#add('lifepillar/vim-solarized8')              "| Colorscheme 
call minpac#add('itchyny/lightline.vim')                  "| Status line
call minpac#add('drmikehenry/vim-fontsize')               "| Zoom
call minpac#add('tpope/vim-surround')                     "| make surround easier
call minpac#add('tpope/vim-unimpaired')                   "| lot of nice mappings
call minpac#add('tpope/vim-fugitive')                     "| Git wrapper
call minpac#add('tpope/vim-dispatch')                     "| Async dispatcher
"call minpac#add('tpope/vim-apathy')                       "| intelligent path
"call minpac#add('tpope/vim-sensible')
call minpac#add('dhruvasagar/vim-table-mode')             "| make tables easy
"call minpac#add('retorillo/airline-tablemode.vim')
call minpac#add('neoclide/coc.nvim', {'branch': 'release'}) "| lsp and autocomplete + a lot more 
call minpac#add('josa42/vim-lightline-coc')                 "| coc integration to lightline
call minpac#add('honza/vim-snippets')                       "| basic snippets
call minpac#add('sheerun/vim-polyglot')                     "| language packs

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

" if firstrun fire off PackUpdate
if exists('g:minpacFirstRun')
  " to avoid coc creating default data dir.
  let g:coc_data_home = vimfiles . 'coc-data'
  echom('First run detected, running PackUpdate')
  call minpac#update()
  !echo 'Plugin installation done, exiting...'
  unlet g:minpacFirstRun
  echom('######### RESTART VIM....############')
  finish
endif

"=== viminfo
" set location of viminfo
let viminfofile = g:vimfiles . 'viminfo'

" Store all swapfiles in user vim directory/swapfiles
if !isdirectory(g:vimfiles . 'swapfiles')
  "execute 'silent !mkdir ' . g:vimfiles . 'swapfiles'
  execute mkdir(g:vimfiles . 'swapfiles', "p", 0700)
endif
let &directory = g:vimfiles . 'swapfiles//'

"set backupdir
if !isdirectory(g:vimfiles . 'backup')
  "execute 'silent !mkdir ' . g:vimfiles . 'backup'
  execute mkdir(g:vimfiles . 'backup', "p", 0700)
endif
let &backupdir = g:vimfiles . 'backup//'
set backup

"=== undodir
if !isdirectory(g:vimfiles . 'undo')
  "execute 'silent !mkdir ' . g:vimfiles . 'undo'
  execute mkdir(g:vimfiles . 'undo', "p", 0700)
endif
let &undodir = g:vimfiles . 'undo//'
set undofile

"=== Fugitive settings
" load on demand
function LoadFugitive()
  :packadd vim-fugitive
  :edit
  :call LightlineFugitive()
  :call lightline#update()
  echo "Fugitive loaded..."
endfunction

nmap <F1> :call LoadFugitive()<CR>

set encoding=utf-8
"=== force load all plugins, to avoid problems with functions not available
"until after vimrc has been processed.
packloadall

"=== Lightline settings

set noshowmode
set laststatus=2
let g:lightline = {}
let g:lightline.active = {}
"    \ 'active': {
"    \     'left': [ [ 'mode','paste' ],[ 'cocstatus','currentfunction','readonly', 'filename', 'modified' ] ],
"    \     'right': [ [ 'lineinfo' ],[ 'percent' ],[ 'fileformat', 'fileencoding', 'filetype' ] ],
"    \ },
"    \ 'component_function': {
"    \     'cocstatus': 'coc#status',
"    \     'currentfunction': 'CocCurrentFunction'
"    \ },
"    \ }
let g:lightline.active.left = [[ 'mode','paste' ],[ 'coc_errors','coc_warnings','coc_ok' ],[ 'coc-status','readonly','filename','modified','currentfunction' ]]
let g:lightline.component_function = {}
let g:lightline.component_function.currentfunction = 'CocCurrentFunction'
let g:lightline.component_function.gitbranch = 'FugitiveHead'
"let g:lightline.component_function.fugitive = 'LightlineFugitive'
"register components
call lightline#coc#register()

"try fancy fugitive integration from https://github.com/itchyny/lightline.vim/issues/96
"function! LightlineFugitive() abort
"  if &filetype ==# 'help'
"    return ''
"  endif
"  if has_key(b:, 'lightline_fugitive') && reltimestr(reltime(b:lightline_fugitive_)) =~# '^\s*0\.[0-5]'
"    return b:lightline_fugitive
"  endif
"  try
"    if exists('*fugitive#head')
"      let head = fugitive#head()
"    else
"      return ''
"    endif
"    let b:lightline_fugitive = head
"    let b:lightline_fugitibe_ = reltime()
"    return b:lightline_fugitive
"  catch
"  endtry
"  return ''
"endfunction

"=== Colorscheme
if has("gui_running")       " Gvim settings
  set background=light
  let g:lightline.colorscheme = 'solarized'
  colorscheme solarized8_flat
  set cursorcolumn
  set cursorline
elseif has('win64')         " Windows settings
  if empty($ConEmuDir)      " cmd or powershell consol settings
    set background=dark
    let g:lightline.colorscheme = 'default'
    colorscheme ron
    set nocursorcolumn
    set nocursorline
  else                      " ConEmu settings
    set notermguicolors
    set t_Co=16
    set background=dark
    let g:lightline.colorscheme = 'solarized'
    colorscheme solarized8_flat
    set nocursorcolumn
    set nocursorline
  endif
else                        " Linux settings
  set background=dark
  let g:lightline.colorscheme = 'solarized'
  colorscheme solarized8_flat
  set cursorcolumn
  set cursorline
endif


"=== Font settings
set guifont=DejaVu_Sans_Mono_Unifont:h11:cDEFAULT:qDEFAULT

"=== Must have settings
set guioptions-=T                 " Disable toolbar
set guioptions+=a                 " Autoselect visual to system clipboard
set guioptions+=!                 " run external commands in vim terminal window
set nocompatible                  " don't be compatible with old vi
filetype plugin indent on         " enable filetype plugin indent detection
syntax enable                     " enable syntax highlighting
set hidden                        " allow hidden buffers
set number                        " show line numbers
set hlsearch                      " highlight searches
set backspace=indent,eol,start    " more useful backspace
set sidescroll=1                  " smoother sidescroll
set signcolumn=yes                " enable signcolumn
set autoindent                    " copy indent from previous line
set smartindent
set showmatch                     " Highlight matching braces and such
set ignorecase                    " Ignore case in searches
set smartcase                     " override ignorecase is pattern contains uppercase
set history=1000                  " longer history
set langmenu=none                 " defaults to english
language en_US.utf8
language messages en_US.utf8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set wildmode=longest:full,list:longest,full
"set path+=**
" keep buffer of lines above and below cursor
set scrolloff=5
" display incomplete commands
set showcmd

" No tabs only 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

"=== Nice to have
" Toggle 'set list'
nmap <leader>l :set list!<CR>

" Set local working dir to directory of current file.
nmap <leader>cd :lcd $:p:h

" Turn of hlsearch with space in normal mode
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Calculate row. ex. 8*8 C-A yields 8*8=64
ino <C-A> <C-O>yiW<End>=<C-R>=<C-R>0<CR>

"=== coc-vimlsp
let g:markdown_fenced_languages = [
  \ 'vim',
  \ 'help'
  \ ]

"=== Coc.nvim settings

nmap <silent><leader>cd <Plug>(coc-definition)
nmap <silent><leader>ci <Plug>(coc-implementation)
nmap <silent><leader>cr <Plug>(coc-reference)
nmap <silent><leader>cre <Plug>(coc-rename)
nmap <silent><leader>ca <Plug>(coc-codeaction)
nmap <silent><leader>cdn <Plug>(coc-diagnostic-next)
nmap <silent><leader>cdp <Plug>(coc-diagnostic-prev)
nmap <silent><leader>ci <Plug>(coc-diagnostic-info)
nmap <leader>= <Plug>(coc-format)
vmap <leader>p <Plug>(coc-format-selected)
nmap <leader>p <Plug>(coc-format-selected)
nnoremap <leader>cl :CocList <C-d>
nnoremap <leader>clb :CocList buffers<CR>
nnoremap <leader>cls :CocList symbols<CR>
nnoremap <leader>cld :CocList diagnostics<CR>
nnoremap <leader>cla :CocList actions<CR>

"Start or refresh completion at current cursor position
inoremap <silent><expr> <c-space> coc#refresh()

" Use K to show documentation in preview window
nnoremap K :call Show_documentation()<CR>

function! Show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" for lightline integration
function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction

augroup Coc
  autocmd!
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup End

"=== Markdown settings
augroup Markdown
  autocmd!
  autocmd FileType markdown :setlocal ts=4 sw=4 sts=4
augroup End

" TODO
" add comment to all relevant places
" Test fugitive on a smb share to se if it still slows everything down. if so
"   report issue. ref https://github.com/tpope/vim-fugitive/issues/365
