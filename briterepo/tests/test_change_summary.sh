#!/usr/bin/env bash

# test_change_summary.sh - comprehensive change-summary helper tests.
#
# Copyright (c) 2026 Paul Sinclair
# SPDX-License-Identifier: MIT
# For license details, see LICENSE in the repository root.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../bin/helpers/git_helpers.sh
source "$SCRIPT_DIR/../bin/helpers/git_helpers.sh"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

[[ -z "$(bt_git_format_tracking_relation_tag local 0 0 0)" ]] || \
  fail "zero-difference tracking tag should be omitted"
[[ "$(bt_git_format_tracking_relation_tag local 2 0 1)" == \
  "[remote behind by 1]" ]] || fail "local-ahead tracking tag"
[[ "$(bt_git_format_tracking_relation_tag remote 2 0 1)" == \
  "[local ahead by 1]" ]] || fail "remote-behind tracking tag"
[[ "$(bt_git_format_tracking_relation_tag local 2 3 4)" == \
  "[remote differs by 4]" ]] || \
  fail "local tracking divergence tag"
[[ "$(bt_git_format_tracking_relation_tag remote 2 3 4)" == \
  "[local differs by 4]" ]] || \
  fail "remote tracking divergence tag"
[[ "$(bt_git_format_parent_relation_tags v1.0.0 2 3 true 4)" == \
  "[parent v1.0.0 differs by 4]" ]] || \
  fail "parent divergence tags"
[[ "$(bt_git_format_parent_relation_tags v2.0.0 0 0 false)" == \
  "[parent unavailable v2.0.0]" ]] || fail "unavailable parent tag"
if bt_git_collect_ref_change_summary missing-ref HEAD; then
  fail "invalid ref comparison should fail"
fi

cat > "$TMPDIR/old-files" <<'EOF'
same.txt
deleted-root.txt
rename-old/pure.txt
rename-mod-old/changed.txt
split-old/one.txt
split-old/two.txt
gone-dir/file.txt
EOF
cat > "$TMPDIR/new-files" <<'EOF'
same.txt
added-root.txt
rename-new/pure.txt
rename-mod-new/changed.txt
split-new-a/one.txt
split-new-b/two.txt
new-dir/file.txt
EOF
printf 'M\0same.txt\0D\0deleted-root.txt\0A\0added-root.txt\0' \
  > "$TMPDIR/status"
printf 'R100\0rename-old/pure.txt\0rename-new/pure.txt\0' \
  >> "$TMPDIR/status"
printf 'R075\0rename-mod-old/changed.txt\0rename-mod-new/changed.txt\0' \
  >> "$TMPDIR/status"
printf 'R100\0split-old/one.txt\0split-new-a/one.txt\0' \
  >> "$TMPDIR/status"
printf 'R100\0split-old/two.txt\0split-new-b/two.txt\0' \
  >> "$TMPDIR/status"
printf 'D\0gone-dir/file.txt\0A\0new-dir/file.txt\0' \
  >> "$TMPDIR/status"

bt_git_collect_change_summary_from_files \
  "$TMPDIR/status" "$TMPDIR/old-files" "$TMPDIR/new-files"

[[ "$BT_CHANGE_MODIFIED_FILES" -eq 1 ]] || fail "modified file count"
[[ "$BT_CHANGE_DELETED_FILES" -eq 2 ]] || fail "deleted file count"
[[ "$BT_CHANGE_ADDED_FILES" -eq 2 ]] || fail "added file count"
[[ "$BT_CHANGE_RENAMED_FILES" -eq 3 ]] || fail "renamed file count"
[[ "$BT_CHANGE_RENAMED_MODIFIED_FILES" -eq 1 ]] || \
  fail "renamed/modified file count"
[[ "$BT_CHANGE_DELETED_DIRECTORIES" -eq 2 ]] || \
  fail "deleted directory count"
[[ "$BT_CHANGE_ADDED_DIRECTORIES" -eq 3 ]] || \
  fail "added directory count"
[[ "$BT_CHANGE_RENAMED_DIRECTORIES" -eq 2 ]] || \
  fail "renamed directory count"

expected_directory_rows=$'gone-dir|Deleted\nsplit-old|Deleted\nnew-dir|Added\nsplit-new-a|Added\nsplit-new-b|Added\nrename-mod-new|Renamed (was rename-mod-old)\nrename-new|Renamed (was rename-old)'
[[ "$(printf '%s\n' "${BT_CHANGE_DIRECTORY_ROWS[@]}")" == \
  "$expected_directory_rows" ]] || fail "directory row order"

expected="1 modified file, 2 deleted files, 2 added files, 3 renamed files, 1 renamed/modified file, 2 deleted directories, 3 added directories and 2 renamed directories"
[[ "$(bt_format_change_summary)" == "$expected" ]] || \
  fail "comprehensive summary formatting"

bt_git_reset_change_summary
BT_CHANGE_ADDED_FILES=1
[[ "$(bt_format_change_summary)" == "1 added file" ]] || \
  fail "zero suppression and singular formatting"

# Ref and worktree wrappers resolve their own inputs, so exercise them against
# a real repository rather than prepared file lists.
REPO="$TMPDIR/repo"
git init -q -b main "$REPO"
git -C "$REPO" config user.name "Change Summary Test"
git -C "$REPO" config user.email "change-summary@example.com"

mkdir -p "$REPO/keep" "$REPO/old-dir" "$REPO/skip-dir" "$REPO/space dir"
printf 'same\n' > "$REPO/keep/same.txt"
printf 'moved\n' > "$REPO/old-dir/moved.txt"
printf 'gone\n' > "$REPO/keep/deleted.txt"
printf 'skip\n' > "$REPO/skip-dir/ignored.txt"
printf 'spaced\n' > "$REPO/space dir/spaced name.txt"
git -C "$REPO" add -A
git -C "$REPO" commit -qm base
base_ref="$(git -C "$REPO" rev-parse HEAD)"

mkdir -p "$REPO/new-dir"
git -C "$REPO" mv old-dir/moved.txt new-dir/moved.txt
git -C "$REPO" rm -q keep/deleted.txt
printf 'changed\n' >> "$REPO/keep/same.txt"
printf 'added\n' > "$REPO/keep/added.txt"
printf 'changed\n' >> "$REPO/space dir/spaced name.txt"
printf 'skipped\n' >> "$REPO/skip-dir/ignored.txt"
git -C "$REPO" add -A
git -C "$REPO" commit -qm change
head_ref="$(git -C "$REPO" rev-parse HEAD)"

cd "$REPO"

bt_git_collect_ref_change_summary "$base_ref" "$head_ref" || \
  fail "ref change summary should succeed for valid refs"
[[ "$BT_CHANGE_MODIFIED_FILES" -eq 3 ]] || \
  fail "ref summary modified count (got $BT_CHANGE_MODIFIED_FILES)"
[[ "$BT_CHANGE_DELETED_FILES" -eq 1 ]] || \
  fail "ref summary deleted count (got $BT_CHANGE_DELETED_FILES)"
[[ "$BT_CHANGE_ADDED_FILES" -eq 1 ]] || \
  fail "ref summary added count (got $BT_CHANGE_ADDED_FILES)"
[[ "$BT_CHANGE_RENAMED_FILES" -eq 1 ]] || \
  fail "ref summary renamed count (got $BT_CHANGE_RENAMED_FILES)"
[[ "$BT_CHANGE_RENAMED_DIRECTORIES" -eq 1 ]] || \
  fail "ref summary renamed directory count (got $BT_CHANGE_RENAMED_DIRECTORIES)"
[[ "$BT_CHANGE_DELETED_DIRECTORIES" -eq 0 ]] || \
  fail "renamed source directory must not count as deleted"
[[ "$BT_CHANGE_ADDED_DIRECTORIES" -eq 0 ]] || \
  fail "renamed target directory must not count as added"

# Excluded pathspecs drop matching files from the counts.
bt_git_collect_ref_change_summary "$base_ref" "$head_ref" "skip-dir" || \
  fail "ref change summary should succeed with exclusions"
[[ "$BT_CHANGE_MODIFIED_FILES" -eq 2 ]] || \
  fail "excluded path should not be counted (got $BT_CHANGE_MODIFIED_FILES)"

# Directory renames are only inferred for unambiguous one-to-one moves.
git checkout -q -b split-case "$base_ref"
mkdir -p "$REPO/split-a" "$REPO/split-b"
printf 'one\n' > "$REPO/old-dir/two.txt"
git add -A
git commit -qm "second file in old-dir"
split_base="$(git rev-parse HEAD)"
git mv old-dir/moved.txt split-a/moved.txt
git mv old-dir/two.txt split-b/two.txt
git add -A
git commit -qm "split old-dir"
bt_git_collect_ref_change_summary "$split_base" "$(git rev-parse HEAD)" || \
  fail "split summary should succeed"
[[ "$BT_CHANGE_RENAMED_DIRECTORIES" -eq 0 ]] || \
  fail "ambiguous split must not be reported as a directory rename"
[[ "$BT_CHANGE_DELETED_DIRECTORIES" -eq 1 ]] || \
  fail "split source directory should count as deleted"
[[ "$BT_CHANGE_ADDED_DIRECTORIES" -eq 2 ]] || \
  fail "split target directories should count as added"

# The worktree wrapper counts uncommitted and untracked changes.
git checkout -q main
printf 'dirty\n' >> "$REPO/keep/same.txt"
printf 'untracked\n' > "$REPO/keep/untracked.txt"
bt_git_collect_worktree_change_summary
[[ "$BT_CHANGE_MODIFIED_FILES" -eq 1 ]] || \
  fail "worktree modified count (got $BT_CHANGE_MODIFIED_FILES)"
[[ "$BT_CHANGE_ADDED_FILES" -eq 1 ]] || \
  fail "worktree untracked file should count as added (got $BT_CHANGE_ADDED_FILES)"

cd "$SCRIPT_DIR"

echo "All change summary tests passed."

echo "All change summary tests passed."