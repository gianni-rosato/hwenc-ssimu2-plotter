# hwenc-ssimu2-plotter
A simple bash script that uses ffmpeg &amp; ssimulacra2_rs to determine the visual quality of hardware encoded video clips.

In order for it to function, you need [ssimulacra2_rs](https://github.com/rust-av/ssimulacra2) & [ffmpeg](https://ffmpeg.org/) as well as a Linux system with vaapi (although you can modify the encoding parameters).

## Usage
`./ssimu2_hwenc_plotter.sh [source] [output.csv]`

For editing the script with ffmpeg vaapi options, check [here](https://ffmpeg.org/ffmpeg-codecs.html#VAAPI-encoders) for ffmpeg's docs on the subject.

## Results
The first column in the csv file will be the target bitrate for each encode, with rows containing corresponding SSIMULACRA2 scores. You can see what those mean [here](https://github.com/cloudinary/ssimulacra2#usage).
