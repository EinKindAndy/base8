
NB. =========================================================
NB. viewimage
NB.
NB. open image filename
viewimage=: 3 : 0
cmd=. absolutepath dltb y
if. -.fexist cmd do. EMPTY return. end.
if. IFJHS do.
  redirecturl_jijxm_=: (' ';'%20') stringreplace cmd
  EMPTY return.
elseif. IFIOS do.
  jh '<a href="file://',(iospath cmd),'"</a>'
  EMPTY return.
end.
select. UNAME
case. 'Win' do.
  ShellExecute=. 'shell32 ShellExecuteW > i x *w *w *w *w i'&cd
  SW_SHOWNORMAL=. 1
  NULL=. <0
  r=. ShellExecute 0;(uucp 'open');(uucp cmd);NULL;NULL;SW_SHOWNORMAL
  if. r<33 do. sminfo 'view image error: ',cmd,LF2,1{::cderx'' end.
case. 'Android' do.
  if. -. isURL cmd do.
    cmd=. 'file://',cmd
  end.
  android_exec_host 'android.intent.action.VIEW';(utf8 cmd);'image/*';0
case. do.
  if. -. isURL cmd do.
    cmd=. 'file://',cmd
  end.
  browser=. Browser_j_
  if. 0 = #browser do.
    browser=. dfltbrowser''
  end.
  browser=. dquote (browser;Browser_nox_j_){::~ nox=. (UNAME-:'Linux') *. (0;'') e.~ <2!:5 'DISPLAY'
  cmd=. browser,' ',dquote cmd
  try.
    2!:1 cmd, (0=nox)#' >/dev/null 2>&1 &'
  catch.
    msg=. 'Could not run the browser with the command:',LF2
    msg=. msg, cmd,LF2
    if. IFQT do.
      msg=. msg, 'You can change the browser definition in Edit|Configure|Base',LF2
    end.
    sminfo 'Run Browser';msg
  end.
end.
EMPTY
)
