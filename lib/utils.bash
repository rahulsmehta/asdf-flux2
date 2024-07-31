#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/fluxcd/flux2"
TOOL_NAME="flux"
TOOL_TEST="flux version --client"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version release_filename checksum_filename
	local url_base release_url checksum_url platform arch variant

	version="$1"
	release_filename="$2"
	checksum_filename="$3"
	platform="$(uname | tr '[:upper:]' '[:lower:]')"
	arch="$(arch)"
	if [ "$arch" == "x86_64" ] || [ "$arch" == "i386" ]; then
		arch="amd64"
	fi
	variant="${platform}_${arch}"
	RELEASE_ARTIFACT_FILENAME="flux_${version}_${variant}.tar.gz"

	url_base="$GH_REPO/releases/download/v${version}"
	release_url="${url_base}/flux_${version}_${variant}.tar.gz"
	checksum_url="${url_base}/flux_${version}_checksums.txt"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$release_filename" -C - "$release_url" || fail "Could not download $release_url"

	echo "* Downloading checksums..."
	curl "${curl_opts[@]}" -o "$checksum_filename" -C - "$checksum_url" || fail "Could not download $checksum_url"
}

compute_sha256sum() {
	local cmd
	cmd=$(which sha256sum shasum | head -n 1)
	case $(basename "$cmd") in
	sha256sum)
		sha256sum "$1" | cut -f 1 -d ' '
		;;
	shasum)
		shasum -a 256 "$1" | cut -f 1 -d ' '
		;;
	*)
		fail "Can not find sha256sum or shasum to compute checksum"
		;;
	esac
}

verify_release() {
	local release_filename checksum_filename
	local expected_checksum release_checksum

	release_filename="$1"
	checksum_filename="$2"

	expected_checksum=$(grep "$RELEASE_ARTIFACT_FILENAME" "$checksum_filename" | cut -d' ' -f1)
	release_checksum=$(compute_sha256sum "$release_filename")

	if [[ "$expected_checksum" != "$release_checksum" ]]; then
		fail "Expected sha256sum does not match $expected_checksum, got $release_checksum"
	fi
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
