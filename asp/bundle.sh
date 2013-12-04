#!/bin/sh


ls -1 exports/*.txt | sed 's/exports\///' > exports/bundle.dat

