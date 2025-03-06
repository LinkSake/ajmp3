#!/bin/bash

OUTPUT="index.html"

cat <<EOF > $OUTPUT
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Musica</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
            text-align: center;
            max-width: 600px;
        }

        .column {
            flex: 1;
            min-width: 250px;
        }

        ul {
            list-style: none;
            padding: 0;
        }

        li {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 5px 0;
        }
    </style>
</head>
<body>
    <div class="container">
EOF

for dir in audio/*/; do
    playlist_name=$(basename "$dir")

    echo "        <div class=\"column\">" >> $OUTPUT
    echo "            <h2>$playlist_name</h2>" >> $OUTPUT
    echo "            <ul>" >> $OUTPUT

    for file in "$dir"*.mp3; do
        [ -e "$file" ] || continue  # Skip if no MP3 files

        filename=$(basename "$file")

        duration=$(ffprobe -i "$file" -show_entries format=duration -v quiet -of csv="p=0" 2>/dev/null)
        duration_formatted=$(printf "%02d:%02d" $((${duration%.*} / 60)) $((${duration%.*} % 60)))

        echo "                <li><a href=\"$file\">$filename</a> <span>$duration_formatted</span></li>" >> $OUTPUT
    done

    echo "            </ul>" >> $OUTPUT
    echo "        </div>" >> $OUTPUT
done

cat <<EOF >> $OUTPUT
    </div>
</body>
</html>
EOF

echo "index.html generated successfully!"
