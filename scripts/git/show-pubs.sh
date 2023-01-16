#!/bin/bash
# Shows the content of every pub file that contains the ".com" string in the name
ls -l -a ~/.ssh | grep .pub | grep .com | awk -v home="$HOME" '{print home"/.ssh/"$9}' | xargs cat | sed 's/$/\n/'
