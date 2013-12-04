#!/bin/sh

#clingo *.lp storyspec.txt | tee solution.txt | perl pretty_print.pl > answerset.txt

clingo *.lp storyspec.txt | tee solution.txt | tr ' ' '\n' > answerset.txt

#clingo *.lp storyspec.txt | tee solution.txt > answerset.txt
