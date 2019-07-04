set nocompatible
syntax on
set number
set cursorline
set mouse=a
set ttymouse=xterm2
let g:mapleader=","

set hidden
" Default Whitespace
set tabstop=4 "tab size
set shiftwidth=2
set softtabstop=2
set expandtab "пробелы вместо табуляции

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'morhetz/gruvbox'
Plug 'Chiel92/vim-autoformat'
Plug 'mattn/emmet-vim'
Plug 'mxw/vim-jsx'
Plug 'jiangmiao/auto-pairs'
Plug 'epilande/vim-es2015-snippets'
Plug 'epilande/vim-react-snippets'
Plug 'SirVer/ultisnips'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
"Plug 'haya14busa/incsearch-fuzzy.vim'
"Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'osyo-manga/vim-over'
Plug 'scrooloose/nerdcommenter'
call plug#end()

map <C-t> :NERDTreeToggle<CR>
noremap <F3> :Autoformat.<CR>

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \}

" Directories for swp files
set backupdir=~/dotvim/backups//
set directory=~/dotvim/backups//
set viewdir=~/dotvim/backups//

colorscheme gruvbox
set background=dark
let g:jsx_ext_required = 0

" 256 colors for terminal vim
set t_Co=256

" create/open file in current folder
map <Leader>ee :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
cnoremap %% <C-R>=expand("%:p:h") . "/" <CR>

"-------------------- IncSearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

"--------------------- EasyMotion


" You can use other keymappings like <C-l> instead of <CR> if you want to
" use these mappings as default search and somtimes want to move cursor with
" EasyMotion.
"function! s:incsearch_config(...) abort
"  return incsearch#util#deepextend(deepcopy({
"        \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
"        \   'keymap': {
"        \     "\<CR>": '<Over>(easymotion)'
"        \   },
"        \   'is_expr': 0
"        \   }), get(a:, 1, {}))
"endfunction

"noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
"noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
"noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))

"function! s:config_easyfuzzymotion(...) abort
"  return extend(copy({
"        \   'converters': [incsearch#config#fuzzyword#converter()],
"        \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
"        \   'keymap': {"\<CR>": '<Over>(easymotion)'},
"        \   'is_expr': 0,
"        \   'is_stay': 1
"        \   }), get(a:, 1, {}))
"endfunction

"noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key
" binding.
" `s{char}{label}`
"nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)



" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion"

"map  / <Plug>(easymotion-sn)
"omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to
" EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
 "different highlight method and have some other features )
"map  n <Plug>(easymotion-next)
"map  N <Plug>(easymotion-prev)

" =============================================================
"                    AUTOCOMMANDS
" =============================================================

if has("autocmd")
  augroup vimrcEx
    au!

    autocmd BufRead *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal g`\"" |
          \ endif

    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
    autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

    autocmd BufRead,BufNewFile *.asc setfiletype asciidoc

    au BufNewFile,BufReadPost *.md set filetype=markdown
  augroup END
endif

" =============================================================
"                      CUSTOM FUNCTIONS
" =============================================================

" Create folders on file save
" ===========================

function! s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

" Remove whitespaces on save saving cursor position
" =================================================

function! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
