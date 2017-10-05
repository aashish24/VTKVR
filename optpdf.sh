#!/usr/bin/env bash
#
# optpdf file.pdf
#   This script will attempt to optimize the given pdf
#
file=$1
filebase=$(basename $file .pdf)
optfile=/tmp/$$-${filebase}_opt.pdf
#/usr/local/bin/gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH \
ghostscriptexe=""
statexe=""
if [ "$(uname)" == "Darwin" ]; then
  ghostscriptexe=/usr/local/Cellar/ghostscript/9.21_2/bin/gs
  statexe="stat -f %z"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  ghostscriptexe=/usr/bin/gs
  statexe="stat --format=%s"
else
  echo "Only Mac or Linux systems supported."
  exit 1
fi

$ghostscriptexe -dCompatibilityLevel=1.4 \
    -sDEVICE=pdfwrite -dPDFSETTINGS=/default -dNOPAUSE -dQUIET -dBATCH \
    -sOutputFile=${optfile} ${file}
if [ $? == '0' ]; then
    optsize=$($statexe ${optfile})
    orgsize=$($statexe ${file})
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
