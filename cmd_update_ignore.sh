#!/bin/bash
echo "update .gitignore 🚀"
git rm -r --cached .
git add .
git commit -m "Apply .gitignore"
