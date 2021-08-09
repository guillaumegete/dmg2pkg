#!/bin/bash

# Dmg2Pkg
# Author : Guillaume Gète
# consulting@gete.net
# www.gete.net

# Version : 1.0

# This script will generate a DMG from PKG files dropped in the Source_DMGs folder.

# It relies on quickpkg (https://github.com/scriptingosx/quickpkg/) to create its magic.
# Install quickpkg first! Future versions may download quickpkg automatically in the future. Who knows.

MYCOMMAND="quickpkg"

if ! command -v $MYCOMMAND &> /dev/null
then
	echo "$MYCOMMAND could not be found. Please install quickpkg first. Exiting…"
	exit 1
	
else
	echo "$MYCOMMAND exists. Let's keep going on…"
fi


# Where all the files will be located. 
# /Users/Shared seems the easiest to me, but your mileage may of course vary.

ROOT_FOLDER="/Users/Shared"

# Path to folder to check for new DMG files. If it does not exist, it will be created.

WATCH_FOLDER="$ROOT_FOLDER/Dmg2Pkg/Source_DMGs"

if [ ! -d $WATCH_FOLDER ]; then
	mkdir -p "$WATCH_FOLDER"
	echo "$WATCH_FOLDER created!"
fi

# Directory where the different generated PKGs will be created

PACKAGES_FOLDER="$ROOT_FOLDER/Dmg2Pkg/Packages"

if [ ! -d $PACKAGES_FOLDER ]; then
	mkdir -p "$PACKAGES_FOLDER"
	echo "$PACKAGES_FOLDER created!"
fi

# Répertoire dans lequel seront déplacés les DMG après traitement

PROCESSED_DMG_FOLDER="$ROOT_FOLDER/Dmg2Pkg/Processed_DMGs"

if [ ! -d $PROCESSED_DMG_FOLDER ]; then
	mkdir -p "$PROCESSED_DMG_FOLDER"
	echo "$PROCESSED_DMG_FOLDER created!"
fi

# Where the log file will be. Just in case.

LOGFILE="$ROOT_FOLDER/Dmg2Pkg/Activity.log"

if [ ! -f $LOGFILE ]; then
	touch "$LOGFILE"
	echo "$LOGFILE created!"
fi

# Your developer signing identity (i.e. Developer ID Installer). 
# You can leave it empty, but your packages won't be signed.
# You can find your signature using the following command:           security find-identity -p basic -v
# The signing identity must be something like:

# "Developer ID Installer: Peter Parker (ARACHN1D3)"


CODE_SIGNATURE="Developer ID Installer: Guillaume Gete (2U4ZFMT67D)"

# Everything's ready. Let's do our stuff!

APP_NAME=$(ls "$WATCH_FOLDER" | head -1)

if [ "$(ls "$WATCH_FOLDER")" ]; then
	
	echo "File to convert : $APP_NAME" >> "$LOGFILE"

# The DMG may not mount if the quarantine is still present on the file.
	
	xattr -d com.apple.quarantine "$WATCH_FOLDER/$APP_NAME"
	

	
	if [ -z "$CODE_SIGNATURE" ]; then
		quickpkg --output "$PACKAGES_FOLDER" "$WATCH_FOLDER/$APP_NAME" >> "$LOGFILE"
	else
		quickpkg --output "$PACKAGES_FOLDER" --sign "$CODE_SIGNATURE" "$WATCH_FOLDER/$APP_NAME" >> "$LOGFILE"
	fi

#	rm -rf /Users/Shared/Dmg2Pkg_MakePKG/.DS_Store
	
	mv "$WATCH_FOLDER/$APP_NAME" "$PROCESSED_DMG_FOLDER"

# This will open the Packages folder in the Finder, each time a new PKG is generated. If it bothers you, just comment the next line.
	
	open "$PACKAGES_FOLDER"
else
	echo "$WATCH_FOLDER is empty." >> $LOGFILE
	echo "$WATCH_FOLDER is empty. Exiting."

fi

