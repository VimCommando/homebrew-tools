#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT_DIR}/dist/bottles"
REMOTE_DIR="${REMOTE_DIR:-/tmp/homebrew-tools-bottles-$(date +%s)-$$}"
FORMULAE=(${BOTTLE_FORMULAE:-espipe kibob})

if [[ -f "${ROOT_DIR}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT_DIR}/.env"
  set +a
fi

: "${LINUX_SSH_HOST:?Set LINUX_SSH_HOST in .env}"
: "${BOTTLE_ROOT_URL:?Set BOTTLE_ROOT_URL in .env}"
: "${LINUX_PODMAN_IMAGE:=docker.io/homebrew/brew:latest}"
if [[ "${LINUX_PODMAN_IMAGE}" == homebrew/brew:* ]]; then
  LINUX_PODMAN_IMAGE="docker.io/${LINUX_PODMAN_IMAGE}"
fi

TAP="${HOMEBREW_TAP:-VimCommando/tools}"
if [[ "${TAP}" != */* ]]; then
  echo "HOMEBREW_TAP must look like owner/name, got: ${TAP}" >&2
  exit 1
fi
TAP_USER="${TAP%%/*}"
TAP_REPO="${TAP#*/}"
TAP_FORMULA_PREFIX="${TAP_USER}/${TAP_REPO}"
LOCAL_TAP_DIR="${LOCAL_TAP_DIR:-$(brew --repository)/Library/Taps/${TAP_USER}/homebrew-${TAP_REPO}}"

mkdir -p "${OUT_DIR}"
rm -f "${OUT_DIR}"/*.bottle*.tar.gz "${OUT_DIR}"/*.json

sync_local_tap() {
  mkdir -p "${LOCAL_TAP_DIR}"
  rsync -a --delete \
    --exclude .git \
    --exclude .env \
    --exclude dist \
    "${ROOT_DIR}/" "${LOCAL_TAP_DIR}/"
}

build_macos_bottles() {
  sync_local_tap

  (
    cd "${LOCAL_TAP_DIR}"
    for formula in "${FORMULAE[@]}"; do
      formula_name="${TAP_FORMULA_PREFIX}/${formula}"
      if brew list --formula "${formula_name}" >/dev/null 2>&1; then
        brew uninstall --force "${formula_name}"
      fi
      brew install --build-bottle "${formula_name}"
      brew bottle --json --root-url "${BOTTLE_ROOT_URL}" "${formula_name}"
    done
    mv ./*.bottle*.tar.gz ./*.json "${OUT_DIR}/"
  )
}

stage_remote_repo() {
  local archive
  archive="$(mktemp -t homebrew-tools.XXXXXX.tar.gz)"

  (
    cd "${ROOT_DIR}"
    tar \
      --exclude .git \
      --exclude .env \
      --exclude dist \
      -czf "${archive}" .
  )

  ssh "${LINUX_SSH_HOST}" "if command -v podman >/dev/null 2>&1; then podman unshare rm -rf '${REMOTE_DIR}'; else rm -rf '${REMOTE_DIR}'; fi && mkdir -p '${REMOTE_DIR}' && chmod 777 '${REMOTE_DIR}'"
  scp "${archive}" "${LINUX_SSH_HOST}:${REMOTE_DIR}/repo.tar.gz"
  ssh "${LINUX_SSH_HOST}" "cd '${REMOTE_DIR}' && tar -xzf repo.tar.gz && rm repo.tar.gz && chmod -R a+rwX '${REMOTE_DIR}'"
  rm -f "${archive}"
}

build_linux_bottles() {
  local formula_list
  formula_list="${FORMULAE[*]}"

  ssh "${LINUX_SSH_HOST}" "cd '${REMOTE_DIR}' && podman run --rm --pull=missing --platform linux/amd64 -v '${REMOTE_DIR}:/work:Z' -w /work -e HOMEBREW_NO_INSTALL_FROM_API=1 '${LINUX_PODMAN_IMAGE}' bash -lc '
    set -euo pipefail
    git config --global init.defaultBranch main
    git -C /work init
    git config --global --add safe.directory /work
    git config --global user.name bottle-builder
    git config --global user.email bottle-builder@example.invalid
    git -C /work add .
    git -C /work commit -m bottle-build-tap
    brew tap --custom-remote ${TAP_FORMULA_PREFIX} file:///work
    tap_dir=\"\$(brew --repo ${TAP_FORMULA_PREFIX})\"
    cd \"\${tap_dir}\"
    brew install pkgconf openssl@3
    command -v pkg-config
    for formula in ${formula_list}; do
      formula_name=\"${TAP_FORMULA_PREFIX}/\${formula}\"
      if brew list --formula \"\${formula_name}\" >/dev/null 2>&1; then
        brew uninstall --force \"\${formula_name}\"
      fi
      brew install --build-bottle \"\${formula_name}\"
      brew bottle --json --root-url \"${BOTTLE_ROOT_URL}\" \"\${formula_name}\"
    done
    cp ./*.bottle*.tar.gz ./*.json /work/
  '"

  scp "${LINUX_SSH_HOST}:${REMOTE_DIR}/*.bottle*.tar.gz" "${OUT_DIR}/"
  scp "${LINUX_SSH_HOST}:${REMOTE_DIR}/*.json" "${OUT_DIR}/"
}

merge_bottle_blocks() {
  (
    cd "${ROOT_DIR}"
    brew bottle --merge --write --no-commit "${OUT_DIR}"/*.json
  )

  local merged_tap_dir
  merged_tap_dir="$(brew --repo "${TAP_FORMULA_PREFIX}")"
  for formula in "${FORMULAE[@]}"; do
    cp "${merged_tap_dir}/Formula/${formula}.rb" "${ROOT_DIR}/Formula/${formula}.rb"
  done
}

build_macos_bottles
stage_remote_repo
build_linux_bottles
merge_bottle_blocks

cat <<EOF
Bottles are in:
  ${OUT_DIR}

Formula bottle blocks were merged locally. Upload the bottle tarballs in
${OUT_DIR} to:
  ${BOTTLE_ROOT_URL}
EOF
