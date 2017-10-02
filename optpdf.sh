#!/usr/bin/env bash
#
# optpdf file.pdf
#   This script will attempt to optimize the given pdf
#
file=$1
filebase=$(basename $file .pdf)
optfile=/tmp/$$-${filebase}_opt.pdf
#/usr/local/bin/gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH \
/usr/local/Cellar/ghostscript/9.21_2/bin/gs -dCompatibilityLevel=1.4 \
    -sDEVICE=pdfwrite -dPDFSETTINGS=/default -dNOPAUSE -dQUIET -dBATCH \
    -sOutputFile=${optfile} ${file}
if [ $? == '0' ]; then
    optsize=$(stat -f "%z" ${optfile})
    orgsize=$(stat -f "%z" ${file})
    if [ "${optsize}" -eq 0 ]; then
        echo "No output!  Keeping original"
        rm -f ${optfile}
        exit;
    fi
    if [ ${optsize} -ge ${orgsize} ]; then
        echo "Didn't make it smaller! Keeping original"
        rm -f ${optfile}
        exit;
    fi
    bytesSaved=$(expr $orgsize - $optsize)
    percent=$(expr $optsize '*' 100 / $orgsize)
    echo Saving $bytesSaved bytes \(now ${percent}% of old\)
    rm ${file}
    mv ${optfile} ${file}
fi