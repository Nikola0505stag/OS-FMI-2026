#!/bin/bash

if ! [ $# -eq 2 ]; then 
	echo "Expected 2 arguments!"
	exit 1
fi

# $1 = repository 
# $2 = package


# add the package to the repository
# if it has the same version => replace with the new version
# else => add the new version 

if ! ./valid_package.sh "$2"; then 
	exit 1
fi

if ! ./valid_repository.sh "$1"; then
	exit 1
fi

REPO=$1
PKG_DIR=$2

PKG_NAME=$(basename "$PKG_DIR")
PKG_VERSION=$(cat "$PKG_DIR/version" | tr -d '[:space:]')
FULL_NAME="${PKG_NAME}-${PKG_VERSION}"

TEMP_ARCHIVE=$(mktemp)
tar -cJf "$TEMP_ARCHIVE" -C "$PKG_DIR/tree" .

HASH=$(sha256sum "$TEMP_ARCHIVE" | cut -d ' ' -f 1)
FINAL_ARCHIVE_NAME="${HASH}.tar.xz"

cp "$TEMP_ARCHIVE" "$REPO/packages/$FINAL_ARCHIVE_NAME"
rm "$TEMP_ARCHIVE"

DB_FILE="$REPO/db"

grep -v "^${FULL_NAME} " "$DB_FILE" > "${DB_FILE}.tmp"

echo "${FULL_NAME} ${HASH}" >> "${DB_FILE}.tmp"

sort "${DB_FILE}.tmp" > "$DB_FILE"
rm "${DB_FILE}.tmp"

echo "Package $FULL_NAME added successfully!"
