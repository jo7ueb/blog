#!/bin/bash
echo -e "\033[0;32mUndrafting $1 ...\033[0m"

# add to git
git add $1

# undraft
hugo undraft $1
