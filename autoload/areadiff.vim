"
" init
"
let s:txtarea1=''
let s:txtarea2=''
let s:catcmd_eof='CATCMDEOF'
if exists('g:vdiff_diffcmd') | let s:vdiff_diffcmd = g:vdiff_diffcmd
else                         | let s:vdiff_diffcmd = 'diff'
endif



"
" local functions
"


function! s:make_diffcmd() abort
  if s:txtarea1 == s:txtarea2
    redraw | echohl Comment | echom 'Same text' | echohl None
    return ''
  endif
  let cmd = s:vdiff_diffcmd .  " <(cat <<'" . s:catcmd_eof . "'\n". s:txtarea1 . "\n" . s:catcmd_eof . "\n) <(cat <<'" . s:catcmd_eof . "'\n". s:txtarea2 . "\n" . s:catcmd_eof . "\n)"
  return cmd
endfunction


function! s:read_text_in_selected_area() abort
  let save_reg = @@
  silent normal! gvy
  let selected = @@
  let @@ = save_reg
  return selected
endfunction


function! s:save_txtarea(nr) abort
  let save_curpos = getcurpos()
  if a:nr == 1 | let s:txtarea1 = s:read_text_in_selected_area()
  else         | let s:txtarea2 = s:read_text_in_selected_area()
  endif
  call setpos('.', save_curpos)
endfunction





"
" global functions
"

function! areadiff#save_txtarea1() abort
  call s:save_txtarea(1)
endfunction
function! areadiff#save_txtarea2() abort
  call s:save_txtarea(2)
endfunction


function! areadiff#insert_diffout() abort
  let diffout = areadiff#exe_diff() | if diffout ==# '' | return '' | endif
  let save_curpos = getcurpos()
  " FIXME: no use registor
  let [save_reg, save_regtype] = [getreg('a'), getregtype('a')]
  let @a = diffout
  normal! "a]p
  call setreg('a', save_reg, save_regtype)
  call setpos('.', save_curpos)
endfunction


function! areadiff#exe_diff() abort
  let cmd = s:make_diffcmd() | if cmd ==# '' | return '' | endif
  return system(cmd)
endfunction


function! areadiff#exe_diff_with_exclam() abort
  let cmd = s:make_diffcmd() | if cmd ==# '' | return '' | endif
  " FIXME: execute shell command without temporary file
  let tempfile = tempname()
  execute ':redir! > ' . tempfile
"     NOTE: 'echo' makes an empty line at the first line, so
"           I use 'echon' and add '\n' to the last
    silent! echon cmd . "\n"
  redir END
  exe '!bash ' . tempfile
  call delete(expand(tempfile))
endfunction




" old version {{{
"       function! areadiff#exe_diff_with_exclam() abort
"         if s:txtarea1 == s:txtarea2
"           redraw | echohl Comment | echom 'Same text' | echohl None
"           return ''
"         endif
"         let tempfile1 = tempname()
"         let tempfile2 = tempname()
"         execute ':redir! > ' . tempfile1
"           silent! echon s:txtarea1."\n"
"         redir END
"         execute ':redir! > ' . tempfile2
"           silent! echon s:txtarea2."\n"
"         redir END
"         let cmd = '! '. g:vdiff_diffcmd . ' ' . tempfile1 . ' ' . tempfile2
"         exe cmd
"         call delete(expand(tempfile1))
"         call delete(expand(tempfile2))
"       endfunction

"
"  let cmd= "cat << 'EOFFF'\n" . diffout . "\nEOFFF\n"
"  exe '!' cmd
"  return ''

"  }}}
