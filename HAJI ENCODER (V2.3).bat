
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


for %%a in ("*.mp4" "*.m4v") do ( 
mkdir "%cd%\%%~na"
)

echo enc.key>> temp.keyinfo
echo enc.key>> temp.keyinfo



for %%a in ("*.mp4" "*.m4v") do (
  call:sslrand
ffmpeg -i "%cd%\%%a" -hls_key_info_file temp.keyinfo -filter_complex "[v:0]split=4[vtemp001][vtemp002][vtemp003][vtemp004];[vtemp001]scale=w=640:h=360[vout001];[vtemp002]scale=w=960:h=540[vout002];[vtemp003]scale=w=1280:h=720[vout003];[vtemp004]scale=w=1920:h=1080[vout004]" -preset veryfast -crf 16 -r 24 -sc_threshold 0 -map [vout001] -c:v:0 libx264 -map [vout002] -c:v:1 libx264 -map [vout003] -c:v:2 libx264 -map [vout004] -c:v:3 libx264 -map a:0 -map a:0 -map a:0 -map a:0 -f hls -hls_time 10 -hls_playlist_type vod -master_pl_name playlist.m3u8 -hls_segment_filename stream_%%v/data%%06d.ts -var_stream_map "v:0,a:0 v:1,a:1 v:2,a:2 v:3,a:3" stream_%%v.m3u8
  

  powershell -command "(gc stream_0.m3u8) -replace 'stream_0/', '' | Out-File lq.m3u8 -encoding utf8"
  powershell -command "(gc lq.m3u8) -replace 'enc.key', '../enc.key' | Out-File lq.m3u8 -encoding utf8"

  powershell -command "(gc stream_1.m3u8) -replace 'stream_1/', '' | Out-File mq.m3u8 -encoding utf8"
  powershell -command "(gc mq.m3u8) -replace 'enc.key', '../enc.key' | Out-File mq.m3u8 -encoding utf8"

  powershell -command "(gc stream_2.m3u8) -replace 'stream_2/', '' | Out-File hq.m3u8 -encoding utf8"
  powershell -command "(gc hq.m3u8) -replace 'enc.key', '../enc.key' | Out-File hq.m3u8 -encoding utf8"

  powershell -command "(gc stream_3.m3u8) -replace 'stream_3/', '' | Out-File hd.m3u8 -encoding utf8"
  powershell -command "(gc hd.m3u8) -replace 'enc.key', '../enc.key' | Out-File hd.m3u8 -encoding utf8"

  powershell -command "(gc playlist.m3u8) -replace 'stream_0', 'lq/playlist' | Out-File playlist.m3u8 -encoding utf8"
  powershell -command "(gc playlist.m3u8) -replace 'stream_1', 'mq/playlist' | Out-File playlist.m3u8 -encoding utf8"
  powershell -command "(gc playlist.m3u8) -replace 'stream_2', 'hq/playlist' | Out-File playlist.m3u8 -encoding utf8"
  powershell -command "(gc playlist.m3u8) -replace 'stream_3', 'hd/playlist' | Out-File playlist.m3u8 -encoding utf8"
  
  ren playlist.m3u8 haji.m3u8

  ren lq.m3u8 playlist.m3u8
  move stream_0 "%cd%/%%~na"
  ren "%cd%/%%~na"/stream_0 lq
  move playlist.m3u8 "%cd%/%%~na"/lq
  del stream_0.m3u8

  ren mq.m3u8 playlist.m3u8
  move stream_1 "%cd%/%%~na"
  ren "%cd%/%%~na"/stream_1 mq
  move playlist.m3u8 "%cd%/%%~na"/mq
  del stream_1.m3u8

  ren hq.m3u8 playlist.m3u8
  move stream_2 "%cd%/%%~na"
  ren "%cd%/%%~na"/stream_2 hq
  move playlist.m3u8 "%cd%/%%~na"/hq
  del stream_2.m3u8

  ren hd.m3u8 playlist.m3u8
  move stream_3 "%cd%/%%~na"
  ren "%cd%/%%~na"/stream_3 hd
  move playlist.m3u8 "%cd%/%%~na"/hd
  del stream_3.m3u8

  ren haji.m3u8 playlist.m3u8
  move playlist.m3u8 "%cd%/%%~na"
  move enc.key "%cd%/%%~na"

)

del temp.keyinfo
echo:
echo:
powershell write-host -fore Green Rendering Completed
echo:
pause
exit

:sslrand
setlocal
for /f "tokens=* USEBACKQ" %%f in (`openssl rand -out enc.key 16`) do (set var=%%f)
EXIT /B 0




