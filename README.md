# SD Card Auto Backup Script - SDCard-Watch

A **Bash script** for macOS that automatically detects an SD card, copies its contents to a backup folder with **MD5 verification**, and ejects the SD card after a successful transfer. It waits for the SD card to be removed before running again.

This script was created to streamline my own photography workflow. As someone who frequently works with multiple SD cards, I needed a way to quickly transfer files while ensuring their integrity, without requiring manual intervention. This script automates the process, making file management seamless and reliable.

## Features

✅ **Automatic SD Card Detection** – Starts backup when an SD card is inserted.\
✅ **MD5 Verification** – Ensures copied files are not corrupted.\
✅ **Organized Backups** – Saves files in a timestamped folder (`SD_Name_YYYY-MM-DD_HH-MM-SS`).\
✅ **Automatic Ejection** – Ejects the SD card after a successful backup.\
✅ **Waits for Removal** – Doesn't rerun until the SD card is unplugged and reinserted.

## Installation

1. **Download the script**

   ```sh
   git clone https://github.com/yourusername/sd-card-watcher.git
   cd sd-card-watcher
   ```

2. **Make the script executable**

   ```sh
   chmod +x sd_card_watcher.sh
   ```

## Usage

Run the script manually:

```sh
./sd_card_watcher.sh
```

Once running, it will:

- Detect an inserted SD card.
- Copy files to `~/SD_Backups/SD_Name_YYYY-MM-DD_HH-MM-SS/`.
- Verify file integrity using MD5.
- Eject the SD card automatically.
- Wait for the SD card to be removed before restarting.

## Running on Startup (Optional)

To run the script automatically at startup:

1. Open Terminal and edit your **crontab**:
   ```sh
   crontab -e
   ```
2. Add the following line at the bottom:
   ```sh
   @reboot /path/to/sd_card_watcher.sh
   ```
3. Save and exit.

## Troubleshooting

- **Permission Denied?**
  ```sh
  chmod +x sd_card_watcher.sh
  ```
- **Script Not Running?** Ensure the script is running in the background (`nohup ./sd_card_watcher.sh &`).
- **SD Card Not Ejecting?** Run `diskutil eject /Volumes/YourSDCardName` manually.

## Contributing

Feel free to submit issues and pull requests to improve the script!

## License

MIT License. Free to use and modify.

---

🚀 **Enjoy hassle-free SD card backups on macOS!**

