NB. PDFReader

NB. =========================================================
NB. viewpdf
NB.
NB. open filename in PDFReader
viewpdf=: 3 : 0
cmd=. dlb@dtb y
isURL=. 1 e. '://'&E.
if. IFJHS do.
  cmd=. '/' (I. cmd='\') } cmd
  if. -.fexist cmd do. EMPTY return. end.
  redirecturl_jijxm_=: (' ';'%20') stringreplace cmd
  EMPTY return.
elseif. IFIOS do.
  jh '<a href="file://',(iospath y),'" >',cmd,'</a>'
  EMPTY return.
end.
PDFReader=. PDFReader_j_
select. UNAME
case. 'Win' do.
  ShellExecute=. 'shell32 ShellExecuteW > i x *w *w *w *w i'&cd
  SW_SHOWNORMAL=. 1
  NULL=. <0
  cmd=. '/' (I. cmd='\') } cmd
  if. -.fexist cmd do. EMPTY return. end.
  if. 0 = #PDFReader do.
    r=. ShellExecute 0;(uucp 'open');(uucp cmd);NULL;NULL;SW_SHOWNORMAL
  else.
    r=. ShellExecute 0;(uucp 'open');(uucp PDFReader);(uucp dquote cmd);NULL;SW_SHOWNORMAL
  end.
  if. r<33 do. sminfo 'view pdf error:',PDFReader,' ',cmd,LF2,1{::cderx'' end.
case. 'Android' do.
  cmd=. '/' (I. cmd='\') } cmd
  if. ('/'~:{.cmd)>isURL cmd do.
    cmd=. (1!:43''),'/',cmd
  end.
  if. -. isURL cmd do.
    cmd=. 'file://',cmd
  end.
  android_exec_host 'android.intent.action.VIEW';(utf8 cmd);'application/pdf';0
case. do.
  if. 0 = #PDFReader do.
    PDFReader=. dfltpdfreader''
  end.
  PDFReader=. dquote PDFReader
  cmd=. '/' (I. cmd='\') } cmd
  cmd=. PDFReader,' ',dquote cmd
  try.
    2!:1 cmd
  catch.
    msg=. 'Could not run the PDFReader with the command:',LF2
    msg=. msg, cmd,LF2
    if. IFQT do.
      msg=. msg, 'You can change the PDFReader definition in Edit|Configure|Base',LF2
    end.
    sminfo 'Run PDFReader';msg
  end.
end.
EMPTY
)

NB. =========================================================
NB. dfltpdfreader ''
NB.     return default PDFReader, or ''
dfltpdfreader=: verb define
select. UNAME
case. 'Win' do. ''
case. 'Darwin' do. 'open'
case. do.
  try.
    2!:0'which evince'
    'evince' return. catch. end.
  try.
    2!:0'which kpdf'
    'kpdf' return. catch. end.
  try.
    2!:0'which xpdf'
    'xpdf' return. catch. end.
  try.
    2!:0'which okular'
    'okular' return. catch. end.
  try.
    2!:0'which acroread'
    'acroread' return. catch. end.
  '' return.
end.
)
