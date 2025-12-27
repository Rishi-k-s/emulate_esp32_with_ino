#!/usr/bin/env bash

# Usage: ./ino_to_running.sh <input.ino>
set -e

if [ $# -ne 1 ]; then
	echo "Usage: $0 <input.ino>"
	exit 1
fi

INO_FILE="$1"
TARGET_FILE="$(dirname "$0")/main/main.cpp"

if [ ! -f "$INO_FILE" ]; then
	echo "Input file $INO_FILE does not exist."
	exit 2
fi

{
	echo "//file: main.cpp"
	echo "#include \"Arduino.h\""
	echo
	cat "$INO_FILE"
} > "$TARGET_FILE"

# Import ESP-IDF environment
if [ -z "$IDF_PATH" ]; then
	if [ -f "$HOME/esp/esp-idf/export.sh" ]; then
		. "$HOME/esp/esp-idf/export.sh"
	elif [ -f "/opt/esp/idf/export.sh" ]; then
		. "/opt/esp/idf/export.sh"
	else
		echo "Could not find esp-idf export.sh. Please set up ESP-IDF environment."
		exit 3
	fi
fi

# Build the project
idf.py build


# Now using esptools to merge the bootloader, partition table, and app binary to a flashable binary
BUILD_DIR="$(dirname "$0")/build"
APP_BIN="build/arduino_to_esp.bin"
BOOTLOADER_BIN="build/bootloader/bootloader.bin"
PARTITION_TABLE_BIN="build/partition_table/partition-table.bin"
FLASHABLE_BIN="build/flash_image.bin"

esptool.py --chip esp32 merge_bin -o "$FLASHABLE_BIN" \
	0x1000 "$BOOTLOADER_BIN" \
	0x8000 "$PARTITION_TABLE_BIN" \
	0x10000 "$APP_BIN"

# This is optional, but truncating the image into 4MB so it will run without any errors in QEMU
truncate -s 4M "$FLASHABLE_BIN"
echo "Created flashable binary at $FLASHABLE_BIN"


echo "Now emulating it via QEMU..."

# Finally running it in QEMU

set -e # Exit if it gets errors

qemu-system-xtensa -nographic -machine esp32 \
	-drive file=build/flash_image.bin,if=mtd,format=raw > output.txt 2>&1 &

echo "QEMU PID: $QEMU_PID"

QEMU_PID=$!

sleep 6

kill "$QEMU_PID"
wait "$QEMU_PID" 2>/dev/null