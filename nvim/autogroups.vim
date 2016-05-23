function! SetCursorToLastKnownPosition()
    if &filetype !~ 'git\|commit\c'
        if line("'\"") > 1 && line("'\"") <= line("$")
            exe "normal! g`\""
        endif
    endif
endfunction

augroup Essentials
    au!
    au FileType text setlocal textwidth=80
    au BufReadPost * call SetCursorToLastKnownPosition()
    au FileType vim setlocal foldmethod=marker
    au BufEnter * silent! lcd %:p:h " Eqv to `set autochdir`
augroup END

augroup RainbowParens
    au!
    let rp_blacklist = ['javascript']
    au VimEnter * if index(rp_blacklist, &ft) < 0 | RainbowParenthesesToggle
    au Syntax * if index(rp_blacklist, &ft) < 0 | RainbowParenthesesLoadRound
    au Syntax * if index(rp_blacklist, &ft) < 0 | RainbowParenthesesLoadSquare
    au Syntax * if index(rp_blacklist, &ft) < 0 | RainbowParenthesesLoadBraces
augroup END

augroup FileTypes
    au BufNewFile,BufRead .eslintrc set filetype=json
augroup END

augroup Terminal
    au TermOpen * set bufhidden=hide
    au TermOpen * redraw
augroup END