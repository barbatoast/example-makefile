#!/bin/bash
#set -x
#--output-sync=recurse

declare -A STATUS

case $1 in
all)
    for file in rules/rules-*.mk
    do
        echo "============================================================"
        echo "===== Making $file "
        echo "============================================================"
        make RULES_FILE=$file
        STATUS[$file]=$?
        echo "============================================================"
        echo "===== DONE with $file "
        echo "============================================================"
    done

    echo "============================================================"
    echo "===== Make summary status: "
    echo "============================================================"
    for file in "${!STATUS[@]}"
    do
        echo " > ${STATUS[$file]} : $file"
    done
    for file in `find build/ -name "*.o"`
    do
        rm -f $file
    done
    ;;
all-fast)
    for file in rules/rules-*.mk
    do
        echo "============================================================"
        echo "===== Making $file "
        echo "============================================================"
        make -j RULES_FILE=$file
        STATUS[$file]=$?
        echo "============================================================"
        echo "===== DONE with $file "
        echo "============================================================"
    done

    echo "============================================================"
    echo "===== Make summary status: "
    echo "============================================================"
    for file in "${!STATUS[@]}"
    do
        echo " > ${STATUS[$file]} : $file"
    done
    for file in `find build/ -name "*.o"`
    do
        rm -f $file
    done
    ;;
clean)
    rm -rf build/debug/
    rm -rf build/release/
    ;;
*)
    echo "usage $0 all|all-fast|clean"
    ;;
esac
