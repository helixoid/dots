function ytm --description "Youtube Music Downloader with embedded metadata"
    yt-dlp -x --embed-metadata $argv 2>| rg -i "error|warning|failed" | tee error.txt
end
