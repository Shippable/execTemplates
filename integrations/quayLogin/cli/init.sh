#!/bin/bash -e

readonly ROOT_DIR="$(dirname "$0")/../../.."
readonly COMMON_DIR="$ROOT_DIR/integrations/common"
readonly HELPERS_PATH="$COMMON_DIR/_helpers.sh"
readonly LOGGER_PATH="$COMMON_DIR/_logger.sh"

# shellcheck source=integrations/common/_helpers.sh
source "$HELPERS_PATH"
# shellcheck source=integrations/common/_logger.sh
source "$LOGGER_PATH"

export RESOURCE_NAME=""
export SCOPES=""
export QUAY_USERNAME=""
export QUAY_PASSWORD=""
export QUAY_EMAIL=""
export RESOURCE_VERSION_PATH=""

help() {
  echo "
  Usage:
    $SCRIPT_NAME <resource_name> [scopes]
  "
}

check_params() {
  _log_msg "Checking params"

  QUAY_USERNAME="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "username" )"
  QUAY_PASSWORD="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "password" )"
  QUAY_EMAIL="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "email" )"
  RESOURCE_VERSION_PATH="$(shipctl get_resource_meta "$RESOURCE_NAME")/version.json"

  if _is_empty "$QUAY_USERNAME"; then
    _log_err "Missing 'username' value in $RESOURCE_NAME's integration."
    exit 1
  fi

  if _is_empty "$QUAY_PASSWORD"; then
    _log_err "Missing 'password' value in $RESOURCE_NAME's integration."
    exit 1
  fi

  if _is_empty "$QUAY_EMAIL"; then
    _log_err "Missing 'email' value in $RESOURCE_NAME's integration."
    exit 1
  fi

  _log_success "Successfully checked params"
}

init_scope_quay() {
  _log_msg "Initializing scope quay.io"

  if _is_docker_email_deprecated; then
    docker_login_cmd=$( docker s -u "$QUAY_USERNAME" -p "$QUAY_PASSWORD" quay.io )
  else
    docker_login_cmd=$( docker login -u "$QUAY_USERNAME" -p "$QUAY_PASSWORD" -e "$QUAY_EMAIL" quay.io )
  fi

  $docker_login_cmd

  _log_success "Successfully initialized scope quay.io"
}

init() {
  RESOURCE_NAME=${ARGS[0]}
  SCOPES=${ARGS[1]}

  _log_grp "Initializing Quay.io login for resource $RESOURCE_NAME"

  check_params
  init_scope_quay
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
