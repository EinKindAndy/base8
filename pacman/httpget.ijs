NB. httpget

NB. =========================================================
NB. httpget, storing file in temp
NB. y is file[;retries]
NB. retries are set for initial read of revision.txt
NB. result is returncode (0=OK);filename or message
NB. any error message is displayed
httpget=: 3 : 0
'f t'=. 2 {. (boxxopen y),a:
n=. f #~ -. +./\. f e. '=/'
p=. jpath '~temp/',n
q=. jpath '~temp/httpget.log'
t=. ":{.t,3
ferase p;q
fail=. 0
cmd=. HTTPCMD rplc '%O';(dquote p);'%L';(dquote q);'%t';t;'%T';(":TIMEOUT);'%U';f
try.
  if. IFIOS +. UNAME-:'Android' do.
    require 'socket'
    1!:55 ::0: <p
    rc=. 0 [ e=. pp=. ''
    whilst. 0 do.
      'rc sk'=. sdsocket_jsocket_''
      if. 0~:rc do. break. end.
      rc=. sdconnect_jsocket_ sk;PF_INET_jsocket_;'23.21.67.48';80
      if. 0~:rc do. break. end.
      'rc sent'=. ('GET ',f,' HTTP/1.0',LF2) sdsend_jsocket_ sk;0
      if. 0~:rc do. break. end.
      while. ((0=rc)*.(*#m)) [[ 'rc m'=. sdrecv_jsocket_ sk,1024 do.
        pp=. pp,m
      end.
    end.
    if. 0~:rc do. fail=. 1
    elseif. 1 -.@e. '200 OK' E. (20{.pp) do. fail=. 1 [ e=. ({.~ i.&LF) pp
    elseif. #p1=. I. (CRLF,CRLF) E. 500{.pp do. p2=. 4
    elseif. #p1=. I. LF2 E. 500{.pp do. p2=. 2
    elseif. do. fail=. 1
    end.
    if. 0=fail do.
      ((p2+{.p1)}.pp) 1!:2 <p
    else.
      if. 0~:rc do. e=. sderror_jsocket_ rc end.
    end.
  elseif. do.
    e=. shellcmd cmd
  end.
catch. fail=. 1 end.
if. fail +. 0 >: fsize p do.
  if. _1-:msg=. freads q do.
    if. 0=#msg=. e do. msg=. 'Unexpected error' end. end.
  log 'Connection failed: ',msg
  info 'Connection failed:',LF2,msg
  r=. 1;msg
  ferase p;q
else.
  r=. 0;p
  ferase q
end.
r
)

NB. =========================================================
NB. httpget, returning result
httpgetr=: 3 : 0
res=. httpget y
if. 0 = 0 pick res do.
  f=. 1 pick res
  txt=. freads f
  ferase f
  0;txt
end.
)
