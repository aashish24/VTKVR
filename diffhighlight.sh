git-latexdiff \
  --config=/home/sankhesh/Projects/vtkvr/latexdiff.cfg --latexmk --verbose \
  --preamble=/home/sankhesh/Projects/vtkvr/latexdiff_preamble.tex --no-cleanup \
  --ignore-latex-errors --verbose --main VTKVR.tex fefff4a HEAD -o \
  diff_fefff4a_$(git rev-parse --short HEAD).pdf
