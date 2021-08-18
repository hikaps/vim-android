let s:entry = "\t<classpathentry kind=\"<kind>\" path=\"<path>\"/>"
let s:entry_sourcepath = "\t<classpathentry kind=\"<kind>\" path=\"<path>\"\n\t\t\tsourcepath=\"<src>\"/>"

" Creates a .classpath file and fills it with dependency entries
function! classpath#generateClasspath() abort
  let l:classes = extend(gradle#classPaths(), android#classPaths())
  let classpath = ['<?xml version="1.0" encoding="UTF-8"?>', '<classpath>']
  for jar in l:classes
    call add(classpath, classpath#NewClasspathEntry('lib', jar))
  endfor
  call add(classpath, '</classpath>')
  call writefile(classpath, 'app/.classpath')
endfunction

" Adds a new entry to the current .classpath file.
function! classpath#NewClasspathEntry(kind, arg)
  let template_name = 's:entry'
  let args = {'kind': a:kind, 'path': substitute(a:arg, '\', '/', 'g')}

  if exists(template_name . '_' . a:kind)
    let template = {template_name}_{a:kind}
  else
    let template = {template_name}
  endif

  for [key, value] in items(args)
    let template = substitute(template, '<' . key . '>', value, 'g')
  endfor

  return template
endfunction
