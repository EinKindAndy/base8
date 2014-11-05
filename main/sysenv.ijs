NB. sysenv - System Environment
NB.%sysenv.ijs - system environment utilities
NB.-This script defines text system environment and is included in the J standard library.
NB.-Definitions are loaded into the z locale.

NB. ---------------------------------------------------------
NB. verbs:
NB.*hostpathsep v  converts path name to use host path separator
NB.*jpathsep v     converts path name to use / separator
NB.*winpathsep v   converts path name to use \ separator
NB.*jcwdpath v     adds path to J current working directory
NB.*jsystemdefs v  loads appropriate netdefs or hostdefs
NB.*IFDEF v        if DEFxxx exists

NB. ---------------------------------------------------------
NB. nouns:
NB.*IF64          n if a 64 bit J system
NB.*IFIOS         n if iOS (iPhone/iPad)
NB.*IFJCDROID     n if JConsole for Android
NB.*IFJHS         n if jhs libraries loaded
NB.*IFQT          n if Qt libraries loaded
NB.*IFRASPI       n if Raspberry Pi
NB.*IFUNIX        n if UNIX
NB.*IFWIN         n if Windows (2000 and up)
NB.*IFWINCE       n if Windows CE
NB.*IFWINE        n if Wine (Wine Is Not an Emulator)
NB.*IFWOW64       n if running J32 on a 64 bit o/s
NB.*UNAME         n name of UNIX o/s
NB.*FHS           n filesystem hierarchy: 0=not used  1=linux

18!:4 <'z'

NB. =========================================================
3 : 0 ''

notdef=. 0: ~: 4!:0 @ <
hostpathsep=: ('/\'{~6=9!:12'')&(I. @ (e.&'/\')@] })
jpathsep=: '/'&(('\' I.@:= ])})
winpathsep=: '\'&(('/' I.@:= ])})
PATHJSEP_j_=: '/'                 NB. should not used in new codes
IFDEF=: 3 : '0=4!:0<''DEF'',y,''_z_'''

NB. ---------------------------------------------------------
IF64=: 16={:$3!:3[2
'IFUNIX IFWIN IFWINCE'=: 5 6 7 = 9!:12''
IFJHS=: 0
IFWINE=: (0 ~: 'ntdll wine_get_version >+ x'&(15!:0)) ::0:`0:@.IFUNIX ''

NB. ---------------------------------------------------------
if. notdef 'IFIOS' do.
  IFIOS=: 0
end.

NB. ---------------------------------------------------------
if. notdef 'BINPATH' do.
  BINPATH=: ,'.'
end.

NB. ---------------------------------------------------------
if. notdef 'IFJCDROID' do.
  IFJCDROID=: 0
end.

NB. ---------------------------------------------------------
if. notdef 'FHS' do.
  FHS=: 0
end.

NB. ---------------------------------------------------------
if. notdef 'UNAME' do.
  if. IFUNIX do.
    if. -.IFIOS do.
      UNAME=: (2!:0 'uname')-.10{a.
    else.
      UNAME=: 'Darwin'
    end.
  elseif. do.
    UNAME=: 'Win'
  end.
end.

NB. ---------------------------------------------------------
if. notdef 'IFRASPI' do.
  if. UNAME -: 'Linux' do.
    IFRASPI=: 1 e. 'BCM2708' E. 2!:0 'cat /proc/cpuinfo'
  else.
    IFRASPI=: 0
  end.
end.

NB. ---------------------------------------------------------
if. IF64 +. IFIOS +. IFRASPI +. UNAME-:'Android' do.
  IFWOW64=: 0
else.
  if. IFUNIX do.
    IFWOW64=: '64'-:_2{.(2!:0 'uname -m')-.10{a.
  else.
    IFWOW64=: 'AMD64'-:2!:5'PROCESSOR_ARCHITEW6432'
  end.
end.

NB. ---------------------------------------------------------
if. notdef 'IFQT' do.
  IFQT=: 0
  libjqt=: ((BINPATH,'/')&,)^:(0=FHS) IFUNIX{::'jqt.dll';'libjqt',(UNAME-:'Darwin'){::'.so';'.dylib'
end.
NB. workaround non-ascii file path
if. IFWIN do.
  if. 1 e. 127< a.&i. libjqt do.
    libjqt=: 'jqt.dll'
  end.
end.

NB. ---------------------------------------------------------
if. UNAME-:'Android' do.
  if. IFQT do.
    AndroidLibPath=: ({.~i:&'/') libjqt
  else.
    AndroidLibPath=: '/lib',~ ({.~i:&'/')^:2 BINPATH
  end.
end.

assert. IFQT *: IFJCDROID
)

NB. =========================================================
jcwdpath=: (1!:43@(0&$),])@jpathsep@((*@# # '/'"_),])

NB. =========================================================
jsystemdefs=: 3 : 0
xuname=. UNAME
if. 0=4!:0 <f=. y,'_',(tolower xuname),(IF64#'_64'),'_j_' do.
  0!:100 toHOST f~
else.
  0!:0 <jpath '~system/defs/',y,'_',(tolower xuname),(IF64#'_64'),'.ijs'
end.
)
