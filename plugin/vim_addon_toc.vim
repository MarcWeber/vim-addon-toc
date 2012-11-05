if !exists('g:vim_addon_toc') | let g:vim_addon_toc = {} | endif | let s:c = g:vim_addon_toc

let s:c.lhs_by_regex = get(s:c, 'lhs_by_regex', '<m-r><m-o>')
let s:c.lhs_by_ft = get(s:c, 'lhs_by_ft', '<m-t><m-o>')

" the (e)grep regex will be created from the vim regex if its not set
let s:c.js = get(s:c, 'js', {'vim': '\%(\<function\>\|\<Class\>\|^var\>\|^\S\+\s\)'})
let s:c.vim = get(s:c, 'vim', {'vim': '^\s*\%(fun\|com\|au\S*\)'})
let s:c.php = get(s:c, 'php', {'vim': '^\(\%(static\|public\|abstract\|protected\|private\)\s\+\)*\%(function\|class\)'})
let s:c.ruby = get(s:c, 'ruby', {'vim': '^\s*\%(def\|class\)'})
let s:c.ant = get(s:c, 'ant', {'vim': '^\s*<target'})
let s:c.sql = get(s:c, 'sql', {'vim': '^\s*\c\%(\SELECT\|CREATE\|UPDATE\|DESCRIBE\|DROP\|ALTER\|INSERT\).*'})
let s:c.perl = get(s:c, 'perl', {'vim': '^\s*sub'})
let s:c.python = get(s:c, 'python', {'vim': '^\s*\%(def\|class\)'})
let s:c.haskell = get(s:c, 'haskell', {'vim': '^\s*\%(\%(\zs\%(where\)\@!\%(\l\w*\)\ze\%(\s\+\%(\S\+\)\)*\s*=\)\|\%(\%(\S\+\)\s*`\zs\%(where\)\@!\%(\l\w*\)\ze`\s*\%(\S\+\)\s*=\)\)'})
let s:c.javascript = get(s:c, 'javascript', {'vim': 'function'})
" actionscript isn't prfect yet ..
let s:c.actionscript = get(s:c, 'actionscript', {'vim': 'private\|public\|include\|class\|interface\|propert\%(y\|ies\)'})
let s:c.make = get(s:c, 'make', {'vim': '^[^: ]\+\s*:.*\|include'})


exec 'noremap '.s:c.lhs_by_regex .' :call vim_addon_toc#ToC({"vim": input("regex for toc:")})<cr>'
exec 'noremap '.s:c.lhs_by_ft .' :call vim_addon_toc#ToCFiletype()<cr>'
