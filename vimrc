set nocompatible
syntax on
set number
set cursorline
set mouse=a
set ttymouse=xterm2

" Default Whitespace
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
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
call plug#end()

map <C-t> :NERDTreeToggle<CR>
noremap <F3> :Autoformat.<CR>

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
