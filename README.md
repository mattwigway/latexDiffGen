### LaTeX Diff Gen for Git: generate PDFs of LaTeX papers stored in Git
where differences between commits are highlighted

I use this to store my papers in Git, and when I show a revised version to my
professor, I have a note (either in .latexdiffgen or just reconstructed from git log)
of what she saw last, so I can generate a custom PDF with the additions and removals.

Usage: latexDiffGen.sh input.tex output.tex [from-object] [to-object]
If to-object is omitted, the current HEAD is used (not the current working
file!)
If from-object is omitted, we try to find it in .latexdiffgen, or throw an
error
