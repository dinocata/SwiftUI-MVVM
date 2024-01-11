#!/bin/sh

SELF=`basename $0`
HOOKS_DIR=`dirname $PWD/$0`

for F in $HOOKS_DIR/*; do
    HOOK_NAME=`basename $F`
    if [ $SELF != $HOOK_NAME ] && [ -x $F ]; then
        HOOK_LOCATION=.git/hooks/$HOOK_NAME
        echo "installing $F as $HOOK_LOCATION"
        ln -sf $F $HOOK_LOCATION
    fi
done
