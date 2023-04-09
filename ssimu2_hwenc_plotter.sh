#!/bin/bash

# Constant bitrate
Q_BEGIN=500
Q_END=8500
Q_INC=500

infile="$1"
extension=${1##*.}
noextension=${1%.*}
noextension=${noextension##*/}
noextension2=${2%.*}
noextension2=${noextension2##*/}

cur_q=$Q_BEGIN
outdir=$noextension2

# Also edit per codec
hwenc () {
	ffmpeg -copyts -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device /dev/dri/renderD128 -i "$infile" -b:v "$1"K -c:v hevc_vaapi -compression_level 7 "$outdir/$noextension-$1K.mkv"
	# ffmpeg -copyts -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device /dev/dri/renderD128 -i "$infile" -b:v "$1"K -c:v h264_vaapi -compression_level 7 "$outdir/$noextension-$1K.mkv"
	# ffmpeg -copyts -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device /dev/dri/renderD128 -i "$infile" -b:v "$1"K -c:v vp9_vaapi -compression_level 7 "$outdir/$noextension-$1K.mkv"
	# ffmpeg -i "$infile" -copyts -b:v "$1"K -c:v libx264 -preset slower -g:v 250 "$outdir/$noextension-$1K.mkv"
}

get_bitrate () {
	ffprobe -show_format "$1" | grep bit_rate | tr -dc ".0123456789-"
}

do_ssimu2 () {
    # first arg is source
    # second arg is cringe
    ssimulacra2_rs video -f 14 "$1" "$2" | grep Mean | tr -dc ".0123456789-"
}

mkdir "$outdir"

done=0
while [[ $done -eq 0 ]] ; do
    $(hwenc $cur_q)
    echo -n "$cur_q " >> $2
    fname="$outdir/$noextension-"$cur_q"K.mkv"
    bitrate=$(get_bitrate "$fname")
    echo -n "$bitrate " >> $2
    ssim2=$(do_ssimu2 "$infile" "$fname")
    echo $ssim2 >> $2
    if [[ $cur_q -eq $Q_END ]] ; then
        done=1
    fi
    cur_q=$(($cur_q + $Q_INC))
done
