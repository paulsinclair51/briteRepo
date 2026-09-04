#!/usr/bin/env bash

# test_rmclone.sh - smoke tests for briterepo/bin/rmclone.
#
# Copyright (c) 2026 Paul Sinclair
# SPDX-License-Identifier: MIT
# For license details, see LICENSE in the repository root.

set -euo pipefail
export LC_ALL=C

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
# shellcheck source=common_test_helpers.sh
source "$SCRIPT_DIR/common_test_helpers.sh"

RMCLONE_SRC="$REPO_ROOT/briterepo/bin/rmclone"
COMMON_HELPER_SRC="$REPO_ROOT/briterepo/bin/helpers/common.sh"
GIT_HELPER_SRC="$REPO_ROOT/briterepo/bin/helpers/git_helpers.sh"
HISTORY_HELPER_SRC="$REPO_ROOT/briterepo/bin/helpers/history_log.sh"

for required in "$RMCLONE_SRC" "$COMMON_HELPER_SRC" "$GIT_HELPER_SRC" \
  "$HISTORY_HELPER_SRC"; do
  [[ -f "$required" ]] || fail "missing source file: $required"
done

TMPDIR="$(mktemp -d)"
cleanup() {
  chmod -R u+w "$TMPDIR" 2>/dev/null || true
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

git_quiet() {
  git -c init.defaultBranch=main -c user.name=tester \
    -c user.email=tester@example.com "$@"
}

# rmclone appends a workflow note to the repository it is run from, so every
# run must happen inside this fixture rather than the real repository.
RUNNER="$TMPDIR/runner"
mkdir -p "$RUNNER/briterepo/bin" "$RUNNER/briterepo/bin/helpers"
cp "$RMCLONE_SRC" "$RUNNER/briterepo/bin/rmclone"
cp "$COMMON_HELPER_SRC" "$RUNNER/briterepo/bin/helpers/common.sh"
cp "$GIT_HELPER_SRC" "$RUNNER/briterepo/bin/helpers/git_helpers.sh"
cp "$HISTORY_HELPER_SRC" "$RUNNER/briterepo/bin/helpers/history_log.sh"
chmod +x "$RUNNER/briterepo/bin/rmclone"
(
  cd "$RUNNER"
  git_quiet init -q .
  echo runner > runner.txt
  git_quiet add -A
  git_quiet commit -qm "runner fixture"
)

ORIGIN="$TMPDIR/origin.git"
git_quiet init -q --bare "$ORIGIN"
SEED="$TMPDIR/seed"
git_quiet clone -q "file://$ORIGIN" "$SEED" 2>/dev/null
(
  cd "$SEED"
  echo seed > seed.txt
  git_quiet add -A
  git_quiet commit -qm "seed commit"
  git_quiet push -q origin HEAD:main
)

# Create a clean clone whose commits all exist on a reachable origin.
make_clone() {
  local path="$1"
  rm -rf "$path"
  git_quiet clone -q "file://$ORIGIN" "$path"
}

run_rmclone() {
  local outfile="$1"
  shift
  run_capture "$outfile" env HOME="$TMPDIR" bash -c \
    "cd '$RUNNER' && bash ./briterepo/bin/rmclone $*"
}

# Like run_rmclone, but feeds a single line of input to the confirmation
# prompt (rmclone always requires interactive confirmation before removing).
run_rmclone_confirm() {
  local outfile="$1"
  local response="$2"
  shift 2
  set +e
  printf '%s\n' "$response" | env HOME="$TMPDIR" bash -c \
    "cd '$RUNNER' && bash ./briterepo/bin/rmclone $*" >"$outfile" 2>&1
  local status=$?
  set -e
  echo "$status"
}

# 1) Help output documents the supported options.
rc=$(run_rmclone "$TMPDIR/help.out" -h)
[[ "$rc" -eq 0 ]] || fail "rmclone -h should exit 0 (got $rc)"
assert_contains "Usage:" "$TMPDIR/help.out"
assert_contains "-d          Dry-run." "$TMPDIR/help.out"
assert_contains "the valid case-insensitive responses (remove, cancel)" \
  "$TMPDIR/help.out"
pass "help output"

# 2) Undocumented aliases are rejected.
for removed_alias in -O --dry-run; do
  rc=$(run_rmclone "$TMPDIR/alias.out" "$removed_alias" "$TMPDIR/seed")
  [[ "$rc" -eq 1 ]] || fail "rmclone $removed_alias should exit 1 (got $rc)"
  assert_contains "Unknown option: $removed_alias" "$TMPDIR/alias.out"
done
pass "undocumented option aliases rejected"

# 3) Exactly one clone path is required.
rc=$(run_rmclone "$TMPDIR/noargs.out")
[[ "$rc" -eq 1 ]] || fail "rmclone without a path should exit 1 (got $rc)"
assert_contains "Expected exactly 1 argument" "$TMPDIR/noargs.out"

rc=$(run_rmclone "$TMPDIR/twoargs.out" "$TMPDIR/seed" "$TMPDIR/runner")
[[ "$rc" -eq 1 ]] || fail "rmclone with two paths should exit 1 (got $rc)"
assert_contains "Expected exactly 1 argument" "$TMPDIR/twoargs.out"
pass "argument count validation"

# 4) Timeout validation rejects non-positive values.
rc=$(run_rmclone "$TMPDIR/timeout.out" -t 0 "$TMPDIR/seed")
[[ "$rc" -eq 1 ]] || fail "rmclone -t 0 should exit 1 (got $rc)"
assert_contains "SEC for -t must be an integer greater than 0" \
  "$TMPDIR/timeout.out"
pass "timeout validation"

# 5) A missing target path is an argument error.
rc=$(run_rmclone "$TMPDIR/missing.out" "$TMPDIR/does-not-exist")
[[ "$rc" -eq 1 ]] || fail "rmclone on a missing path should exit 1 (got $rc)"
assert_contains "Clone path not found or not a directory" "$TMPDIR/missing.out"
pass "missing target path"

# 6) Dry-run reports the plan and leaves the clone in place.
make_clone "$TMPDIR/clone-dry"
rc=$(run_rmclone "$TMPDIR/dryrun.out" -d "$TMPDIR/clone-dry")
[[ "$rc" -eq 0 ]] || fail "rmclone -d should exit 0 on a clean clone (got $rc)"
assert_contains "Safety checks passed." "$TMPDIR/dryrun.out"
assert_contains "Dry-run mode enabled. No files were removed." \
  "$TMPDIR/dryrun.out"
assert_contains "Would remove clone directory" "$TMPDIR/dryrun.out"
[[ -d "$TMPDIR/clone-dry" ]] || fail "rmclone -d must not remove the clone"
pass "dry-run leaves the clone in place"

# 7) Safety checks warn about a dirty clone but do not block it; 'cancel'
# leaves the clone in place.
make_clone "$TMPDIR/clone-dirty"
echo "uncommitted" > "$TMPDIR/clone-dirty/dirty.txt"
rc=$(run_rmclone_confirm "$TMPDIR/dirty-cancel.out" "cancel" \
  "$TMPDIR/clone-dirty")
[[ "$rc" -eq 3 ]] || fail "cancelled dirty clone removal should exit 3 (got $rc)"
assert_contains "Working tree is not clean" "$TMPDIR/dirty-cancel.out"
assert_contains "Operation cancelled" "$TMPDIR/dirty-cancel.out"
[[ -d "$TMPDIR/clone-dirty" ]] || fail "cancelled removal must keep the clone"
pass "dirty clone warning does not block cancellation"

# 8) Confirming 'remove' removes a dirty clone despite the warning.
rc=$(run_rmclone_confirm "$TMPDIR/dirty-remove.out" "remove" \
  "$TMPDIR/clone-dirty")
[[ "$rc" -eq 0 ]] || fail "confirmed dirty clone removal should exit 0 (got $rc)"
assert_contains "Working tree is not clean" "$TMPDIR/dirty-remove.out"
assert_contains "Removed clone" "$TMPDIR/dirty-remove.out"
[[ ! -e "$TMPDIR/clone-dirty" ]] || fail "confirmed removal should remove the clone"
pass "confirmed removal proceeds despite warnings"

# 9) A non-Git directory is reported as unsafe.
mkdir -p "$TMPDIR/plain-dir"
rc=$(run_rmclone "$TMPDIR/plain.out" "$TMPDIR/plain-dir")
[[ "$rc" -eq 2 ]] || fail "non-Git target should exit 2 (got $rc)"
assert_contains "Target is not a valid Git repository" "$TMPDIR/plain.out"
pass "non-Git target blocked"

# 10) Removing the repository rmclone runs from relocates to a temporary
# copy and completes the removal, rather than refusing, once confirmed.
SELF_RUNNER="$TMPDIR/self-runner"
mkdir -p "$SELF_RUNNER/briterepo/bin/helpers"
cp "$RMCLONE_SRC" "$SELF_RUNNER/briterepo/bin/rmclone"
cp "$COMMON_HELPER_SRC" "$SELF_RUNNER/briterepo/bin/helpers/common.sh"
cp "$GIT_HELPER_SRC" "$SELF_RUNNER/briterepo/bin/helpers/git_helpers.sh"
cp "$HISTORY_HELPER_SRC" "$SELF_RUNNER/briterepo/bin/helpers/history_log.sh"
chmod +x "$SELF_RUNNER/briterepo/bin/rmclone"
(
  cd "$SELF_RUNNER"
  git_quiet init -q .
  echo runner > runner.txt
  git_quiet add -A
  git_quiet commit -qm "runner fixture"
)

set +e
printf 'remove\n' | env HOME="$TMPDIR" bash -c \
  "cd '$TMPDIR' && bash '$SELF_RUNNER/briterepo/bin/rmclone' '$SELF_RUNNER'" \
  >"$TMPDIR/self.out" 2>&1
rc=$?
set -e
[[ "$rc" -eq 0 ]] || fail "removing own repository should exit 0 via relocation (got $rc)"
assert_contains "continuing from a temporary copy" "$TMPDIR/self.out"
assert_contains "Removed clone" "$TMPDIR/self.out"
[[ ! -e "$SELF_RUNNER" ]] || fail "self-removal via relocation should remove the repository"
pass "repository root is removed via temporary relocation"

# 11) A clean clone is removed once confirmed.
make_clone "$TMPDIR/clone-clean"
rc=$(run_rmclone_confirm "$TMPDIR/clean.out" "remove" "$TMPDIR/clone-clean")
[[ "$rc" -eq 0 ]] || fail "clean clone removal should exit 0 (got $rc)"
assert_contains "Safety checks passed." "$TMPDIR/clean.out"
assert_contains "Removed clone" "$TMPDIR/clean.out"
[[ ! -e "$TMPDIR/clone-clean" ]] || fail "clean clone should be removed"
pass "clean clone removed"

echo "All rmclone smoke tests passed."
