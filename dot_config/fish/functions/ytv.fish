function ytv --description "Download YouTube video avoiding AV1 codec"
    yt-dlp -f "bestvideo[vcodec^=avc]+bestaudio/best" --embed-chapters $argv
end
