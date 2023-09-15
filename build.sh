#! /bin/bash
set -e

if ! which pip > /dev/null;
then
    echo -e "pip not found. Please install pip before building the book."
    exit 1
fi

pip install -r requirements.txt

make clean
# First, we build the pdf version of the book
sphinx-build -b latex source/ _build
cd _build && make && cd ..
# We move the pdf version of the book in the static files, for download
mv _build/lepl1402.pdf source/_static/
rm -r _build
# Now we build the html version
sphinx-build source _build