#!/bin/zsh
echo "loop"
while read file event; do
   echo $file
   filename=$file:t:r
   filepath=$file:h
   poetry run python -m pixyverse.pixy -p $file -o $filepath/$filename.py
   poetry run python pixyverse/dev/__init__.py | tee build/index.html
done
