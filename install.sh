#!/bin/sh

# This is a convenience script that can be downloaded from GitHub and
# piped into "sh" for conveniently downloading the latest GitHub release
# of the drop CLI:
#
# curl -fsSL https://raw.githubusercontent.com/quarksgroup/dropctl/main/install.sh | sh
#
# Warning: It may not be advisable to pipe scripts from GitHub directly into
# a command line interpreter! If you do not fully trust the source, first
# download the script, inspect it manually to ensure its integrity, and then
# run it:
#
# curl -fsSL https://raw.githubusercontent.com/quarksgroup/dropctl/main/install.sh > install.sh
# vim install.sh
# ./install.sh

DROPCLI_REPO="quarksgroup/drop-cli"
ARCH="$(uname -m)"

# Detect architecture
case $ARCH in
x86_64) ARCH="amd64" ;;
arm64) ARCH="arm64" ;;
*)
    echo "Unsupported architecture"
    exit 1
    ;;
esac

# Detect OS system type. (Windows not supported.)
case $ARCH in
Darwin) OSTYPE="darwin" ;;
*) OSTYPE="linux" ;;
esac

# Fetch download URL for the architecture from the GitHub API
ASSET_URL=$(curl -s https://api.github.com/repos/$DROPCLI_REPO/releases/latest |
    grep -o "https:\/\/github\.com\/$DROPCLI_REPO\/releases\/download\/.*${OSTYPE}-${ARCH}.*" |
    tr -d '\"')

if [ -z "$ASSET_URL" ]; then
    echo "Could not find a binary for latest version of drop cli release and architecture ${ARCH} on OS type ${OSTYPE}"
    exit 1
fi

# Download and install
curl -L ${ASSET_URL} | tar xz
chmod +x ./dropctl

echo
echo "Download complete. Please move the binary to a directory in your PATH."
echo "For example:"
echo "  mv ./dropctl /usr/local/bin"
echo
echo "You can now run:"
echo "  dropctl --help"
echo "to get started."
echo "Enjoy!"
