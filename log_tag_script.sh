#!/bin/bash
set -e

if [ -z "$1" ]; then
	    echo usage: $0 TAG
	        exit 1
fi

if [ -n "$(git tag -l $1)" ]; then
	    echo $1 tag exists run
	        echo "    " git tag -d $1
		    exit 1
fi

# The submodule tagging screws up ./hack/update-codegen.sh so make sure the script find a valid
# semver tag
while true; do
TAG=$(git describe --tags HEAD)
if ! git tag -d "$TAG" 2>/dev/null; then
    break
  fi
done

git tag $1
for i in staging/src/k8s.io/*; do
      git tag -d $i/$1 2>/dev/null || true
    git tag $i/$1
  done

  for i in staging/src/k8s.io/*; do
        echo git push '$REMOTE' $i/$1
done
echo git push '$REMOTE' $1
