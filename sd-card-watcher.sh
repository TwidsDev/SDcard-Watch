#!/bin/bash

# CONFIGURATION: Set your destination backup folder
DESTINATION_DIR="$HOME/SD_Backups"
SD_PATH="/Volumes"

# Function to compute MD5 checksum of a file
compute_md5() {
    md5 -q "$1"
}

# Function to copy files while verifying integrity
copy_with_verification() {
    local src_file="$1"
    local dest_file="$2"

    # Compute source file MD5
    local original_md5
    original_md5=$(compute_md5 "$src_file")

    # Copy the file
    cp "$src_file" "$dest_file"

    # Compute copied file MD5
    local copied_md5
    copied_md5=$(compute_md5 "$dest_file")

    # Verify integrity
    if [[ "$original_md5" == "$copied_md5" ]]; then
        echo "✅ Successfully copied: $src_file"
    else
        echo "❌ MD5 mismatch! Removing corrupted copy: $dest_file"
        rm "$dest_file"
    fi
}

# Function to detect and process an SD card
process_sd_card() {
    for volume in "$SD_PATH"/*; do
        # Ignore system volumes
        [[ -d "$volume" && "$volume" != "/Volumes/Macintosh HD" && "$volume" != "/Volumes/Recovery" ]] || continue  

        echo "📂 SD Card detected at $volume"

        # Get volume name and current datetime
        volume_name=$(basename "$volume")
        current_date=$(date +%Y-%m-%d_%H-%M-%S)
        sd_card_folder="$DESTINATION_DIR/${volume_name}_${current_date}"  # Folder: volume_name_datetime
        mkdir -p "$sd_card_folder"

        # Copy files from SD card with verification
        find "$volume" -type f | while read -r file; do
            rel_path="${file#$volume/}"  # Get relative path
            dest_file="$sd_card_folder/$rel_path"

            # Skip if already copied
            [[ -f "$dest_file" ]] && echo "Skipping $file, already exists." && continue

            # Ensure subdirectories exist
            mkdir -p "$(dirname "$dest_file")"

            copy_with_verification "$file" "$dest_file"
        done

        # Eject the SD card after copying is complete
        eject_sd_card "$volume"

        echo "✅ SD card backup complete!"
        return 0  # Exit function after processing one SD card
    done
    return 1  # No SD card found
}

# Function to eject the SD card
eject_sd_card() {
    local volume="$1"
    echo "⏳ Ejecting SD card at $volume..."
    diskutil eject "$volume"
    if [[ $? -eq 0 ]]; then
        echo "✅ Successfully ejected SD card: $volume"
    else
        echo "❌ Failed to eject SD card: $volume"
    fi
}

# Function to wait for SD card removal
wait_for_removal() {
    while [ -d "$SD_CARD_PATH" ]; do
        sleep 2
    done
    echo "💾 SD card removed. Waiting for new SD card..."
}

echo "🛠️  Watching for SD card insertions..."

while true; do
    # Wait until an SD card is detected
    while ! process_sd_card; do
        sleep 5
    done

    # Wait for SD card removal before running again
    wait_for_removal
done
