let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#708090'
let g:indentLine_char = '¦'

"----------------------------------------
" 検索
"----------------------------------------
" 検索するときに大文字小文字を区別しない
set ignorecase
" 小文字で検索すると大文字と小文字を無視して検索
set smartcase
" 検索がファイル末尾まで進んだら、ファイル先頭から再び検索
set wrapscan
" インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set incsearch
" 検索結果をハイライト表示
set hlsearch

"----------------------------------------
" 表示設定
"----------------------------------------
" シンタックスハイライト
syntax on
" 行番号の表示
set number
" タイトルを表示
set title
set guioptions+=R
set shiftwidth=4
set autoindent
set ruler
set showmatch
set cursorline
" タブと行末の空白を可視化する
set list
set listchars=tab:>_,trail:~,extends:>,precedes:<
" ファイル内にあるタブ文字の表示幅
set tabstop=4

function! s:ClosePair(char) abort
    return getline('.')[col('.') - 1] ==# a:char ? "\<Right>" : a:char
endfunction

function! s:InsertQuote(char) abort
    let before = strpart(getline('.'), 0, col('.') - 1)
    if strlen(matchstr(before, '\\*$')) % 2 == 1
        return a:char
    endif
    if getline('.')[col('.') - 1] ==# a:char
        return "\<Right>"
    endif
    if before =~# '\k$'
        return a:char
    endif
    return a:char . a:char . "\<Left>"
endfunction

inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap } <C-R>=<SID>ClosePair('}')<CR>
inoremap ] <C-R>=<SID>ClosePair(']')<CR>
inoremap ) <C-R>=<SID>ClosePair(')')<CR>
inoremap " <C-R>=<SID>InsertQuote('"')<CR>
inoremap ' <C-R>=<SID>InsertQuote("'")<CR>
