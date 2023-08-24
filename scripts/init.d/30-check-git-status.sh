#!/bin/bash
# NOTE: This part assumes you are working under the meta-workspace enviroment, and thus, some
# implicit assumptions are made. As example, the fact that the git diff will show you not only the
# meta-workspace diff, but also the status of the submodules

# Log the current git-state of the meta-workspace
meta_workspace_hash="$(git rev-parse HEAD)$(
  $(git diff-index --quiet HEAD &&
    git ls-files --others --exclude-standard) ||
    echo "-dirty"
)"
echo $meta_workspace_hash >$LATEST/git.hash

# Log any difference in the code (if any)
if [ -n "$(git diff origin/main)" ]; then
  git diff main >$LATEST/git.patch
fi
