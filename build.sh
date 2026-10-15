#!/bin/bash
set -e

echo "=== 1. Checking Python dependencies ==="
if which pip > /dev/null; then
    pip install -r requirements.txt
elif which pip3 > /dev/null; then
    pip3 install -r requirements.txt
else
    echo "Warning: pip not found, using existing environment."
fi

mkdir -p source/_static

echo "=== 2. Building PDF version of the book ==="
if which latexmk > /dev/null || which pdflatex > /dev/null; then
    echo "LaTeX toolchain found. Generating LaTeX sources..."
    rm -rf _build_pdf
    sphinx-build -b latex source _build_pdf
    echo "Compiling PDF with LaTeX..."
    (cd _build_pdf && make LATEXMKOPTS="-silent" lepl1402.pdf)
    if [ -f "_build_pdf/lepl1402.pdf" ] && [ -s "_build_pdf/lepl1402.pdf" ]; then
        echo "PDF build succeeded! Output size: $(ls -lh _build_pdf/lepl1402.pdf | awk '{print $5}')"
        cp -f _build_pdf/lepl1402.pdf source/_static/lepl1402.pdf
        rm -rf _build_pdf
    else
        echo "Error: _build_pdf/lepl1402.pdf was not successfully produced."
        exit 1
    fi
else
    echo "Notice: LaTeX toolchain (latexmk/pdflatex) not found."
    if [ -f "source/_static/lepl1402.pdf" ]; then
        echo "Using existing pre-built PDF: source/_static/lepl1402.pdf"
    else
        echo "Error: LaTeX is missing and no pre-built PDF is available in source/_static/lepl1402.pdf."
        exit 1
    fi
fi

# Verify the PDF exists and is valid
if [ ! -f "source/_static/lepl1402.pdf" ] || [ ! -s "source/_static/lepl1402.pdf" ]; then
    echo "Error: source/_static/lepl1402.pdf is missing or empty!"
    exit 1
fi

echo "=== 3. Building HTML website ==="
rm -rf _build
sphinx-build -b html source _build

# Guarantee that the PDF is available in the web build output
mkdir -p _build/_static
cp -f source/_static/lepl1402.pdf _build/_static/lepl1402.pdf

echo "=== Build completed successfully! Website and PDF are ready. ==="