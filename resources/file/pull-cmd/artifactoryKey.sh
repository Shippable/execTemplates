#!/bin/bash -e

readonly ROOT_DIR="$(dirname "$0")/../../.."
readonly COMMON_DIR="$ROOT_DIR/resources/common"
readonly HELPERS_PATH="$COMMON_DIR/_helpers.sh"
readonly LOGGER_PATH="$COMMON_DIR/_logger.sh"

# shellcheck source=resources/common/_helpers.sh
source "$HELPERS_PATH"
# shellcheck source=resources/common/_logger.sh
source "$LOGGER_PATH"

export FILE_URI=""
export OUTPUT_FOLDER=""

help() {
  echo "
  Usage:
    $SCRIPT_NAME <file_uri> <output_folder>
  "
}

check_params() {
  _log_msg "Checking params"

  if _is_empty "$FILE_URI"; then
    _log_err "File URI to download from is required."
    exit 1
  fi

  if _is_empty "$OUTPUT_FOLDER"; then
    _log_err "A path to save file to is required."
    exit 1
  fi

  _log_success "Successfully checked params"
}

get_file() {
  _log_msg "Starting to fetch file"

  # The target path should end with a slash for it to be treated as directory.
  # ref: https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-DownloadingFiles
  jfrog rt dl "$FILE_URI" "$OUTPUT_FOLDER/"

  _log_success "Successfully fetched file"
}

init() {
  FILE_URI=${ARGS[0]}
  OUTPUT_FOLDER=${ARGS[1]}

  check_params
  get_file
}

main() {
  if [[ "${#ARGS[@]}" -gt 0 ]]; then
    case "${ARGS[0]}" in
      --help)
        help
        exit 0
        ;;
      *)
        init
        ;;
    esac
  else
    help
    exit 1
  fi
}

main
