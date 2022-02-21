@echo off 
color 02 
setLocal EnableDelayedExpansion
set "STR=WELCOME TO HAJI ENCODER^!"
set "SIZE=80"
set "STR2=BY MOHAMMADREZA AND EGHBAL"
set "SIZE=50"
set "STR3=VERSION 1.3"
set "SIZE=50"

set "LEN=0"
:strLen_Loop
   if not "!!STR:~%LEN%!!"=="" set /A "LEN+=1" & goto :strLen_Loop

set "stars=****************************************************************************************************"
set "spaces=                                                                                                    "

call echo %%stars:~0,%SIZE%%%
set /a "pref_len=%SIZE%-%LEN%-2"
set /a "pref_len/=2"
set /a "suf_len=%SIZE%-%LEN%-2-%pref_len%"
call echo %%spaces:~0,%pref_len%%%%%STR%%%%spaces:~0,%suf_len%%%
call echo %%spaces:~0,%pref_len%%%%%STR2%%%%spaces:~0,%suf_len%%%
call echo %%spaces:~0,%pref_len%%%%%STR3%%%%spaces:~0,%suf_len%%%
call echo %%stars:~0,%SIZE%%%

endLocal

timeout 5
color 07

powershell -command "set-content handler.txt '0'"

set /a var = 0

echo @echo off>>encoder.bat

echo for %%%%a in ("*.mp4" "*.m4v") do (>>encoder.bat

  echo call:sslrand>>encoder.bat

  (
  echo ffmpeg -i "%%%%a" -hls_key_info_file temp.keyinfo -filter_complex "[v:0]split=4[vtemp001][vtemp002][vtemp003][vtemp004];[vtemp001]scale=w=640:h=360[vout001];[vtemp002]scale=w=960:h=540[vout002];[vtemp003]scale=w=1280:h=720[vout003];[vtemp004]scale=w=1920:h=1080[vout004]" -preset veryfast -crf 16 -r 24 -sc_threshold 0 -map [vout001] -c:v:0 libx264 -map [vout002] -c:v:1 libx264 -map [vout003] -c:v:2 libx264 -map [vout004] -c:v:3 libx264 -map a:0 -map a:0 -map a:0 -map a:0 -f hls -hls_time 10 -hls_playlist_type vod -master_pl_name playlist.m3u8 -hls_segment_filename stream_%%%%v/data%%%%06d.ts -var_stream_map "v:0,a:0 v:1,a:1 v:2,a:2 v:3,a:3" stream_%%%%v.m3u8

  echo if exist ../handler.txt powershell -command "$p = get-content ../handler.txt; $m = [int]$p; $m = $m - 1; set-content ../handler.txt $m"

  echo powershell -command "(gc stream_0.m3u8) -replace 'stream_0/', '' | Out-File lq.m3u8 -encoding utf8"
  echo powershell -command "(gc lq.m3u8) -replace 'enc.key', '../enc.key' | Out-File lq.m3u8 -encoding utf8"

  echo powershell -command "(gc stream_1.m3u8) -replace 'stream_1/', '' | Out-File mq.m3u8 -encoding utf8"
  echo powershell -command "(gc mq.m3u8) -replace 'enc.key', '../enc.key' | Out-File mq.m3u8 -encoding utf8"

  echo powershell -command "(gc stream_2.m3u8) -replace 'stream_2/', '' | Out-File hq.m3u8 -encoding utf8"
  echo powershell -command "(gc hq.m3u8) -replace 'enc.key', '../enc.key' | Out-File hq.m3u8 -encoding utf8"

  echo powershell -command "(gc stream_3.m3u8) -replace 'stream_3/', '' | Out-File hd.m3u8 -encoding utf8"
  echo powershell -command "(gc hd.m3u8) -replace 'enc.key', '../enc.key' | Out-File hd.m3u8 -encoding utf8"

  echo powershell -command "(gc playlist.m3u8) -replace 'stream_0', 'lq/playlist' | Out-File playlist.m3u8 -encoding utf8"
  echo powershell -command "(gc playlist.m3u8) -replace 'stream_1', 'mq/playlist' | Out-File playlist.m3u8 -encoding utf8"
  echo powershell -command "(gc playlist.m3u8) -replace 'stream_2', 'hq/playlist' | Out-File playlist.m3u8 -encoding utf8"
  echo powershell -command "(gc playlist.m3u8) -replace 'stream_3', 'hd/playlist' | Out-File playlist.m3u8 -encoding utf8"
  
  echo ren playlist.m3u8 haji.m3u8

  echo ren lq.m3u8 playlist.m3u8
  echo ren stream_0 lq
  echo move playlist.m3u8 "%%cd%%"/lq
  echo del stream_0.m3u8

  echo ren mq.m3u8 playlist.m3u8
  echo ren stream_1 mq
  echo move playlist.m3u8 "%%cd%%"/mq
  echo del stream_1.m3u8

  echo ren hq.m3u8 playlist.m3u8
  echo ren stream_2 hq
  echo move playlist.m3u8 "%%cd%%"/hq
  echo del stream_2.m3u8

  echo ren hd.m3u8 playlist.m3u8
  echo ren stream_3 hd
  echo move playlist.m3u8 "%%cd%%"/hd
  echo del stream_3.m3u8

  echo ren haji.m3u8 playlist.m3u8

  ) >>encoder.bat

 echo ) >>encoder.bat

(
echo move *.mp4 ../Completed
echo move *.m4v ../Completed
echo echo:
echo echo:
echo powershell write-host -fore Green Rendering Completed
echo echo:
)>>encoder.bat
echo del temp.keyinfo>>encoder.bat
(
echo set /a var = %%var%% + 1
)>>encoder.bat
powershell -command "Add-Content encoder.bat 'del encoder.bat & exit'"


echo :sslrand>>encoder.bat
echo for /f "tokens=* USEBACKQ" %%%%f in (`openssl rand -out enc.key 16`) do (set var=%%%%f)>>encoder.bat
(
echo EXIT /B 0
)>>encoder.bat

echo enc.key>> temp.keyinfo
echo enc.key>> temp.keyinfo

mkdir Completed

for %%a in ("*.mp4" "*.m4v") do (

echo "%%~na"
call:current_process "%%~na" "%%a"
)
del encoder.bat
powershell write-host -fore Green "RENDERING COMPLETED"
del handler.txt
del temp.keyinfo
exit

:current_process
:pointer
SET /A timerand=%RANDOM% * 5 / 32768 + 1
for /f %%i IN (handler.txt) do set /a c=%%i
if %c% GEQ 3 (
  timeout 5
  powershell write-host -fore Green "WAITING FOR CURRENT STACK TO FINISH"
  goto :pointer
)
  set directory_name=%~1
  set file_name=%~2
  mkdir "%cd%\%~1"
  powershell -command "$d = $env:directory_name ; $f = $env:file_name ; $c = ' - ' + -join ((48..57) + (65..90) + (97..122) | get-random -Count 10 | %%%{[char]$_}) ; rename-item $d $d$c ; move-item $f $d$c ; copy-item encoder.bat $d$c ; copy-item temp.keyinfo $d$c ; cd $d$c ; $p = get-content ../handler.txt; $m = [int]$p; $m = $m + 1; set-content ../handler.txt $m ; start-process encoder.bat"
exit /b 0
