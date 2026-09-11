# 2301368 Image Processing

การบ้านวิชาการประมวลผลภาพ

- Assignment #1: [Simple Image Interpolation](src/assignment01/workfile.ipynb)
- Assignment #2: [Image Enhancement](src/assignment02/lab.ipynb)

## Convert to PDF

```
mkdir -p output/pdf

uvx --from nbconvert jupyter nbconvert \
  --to html \
  --output lab.html \
  --output-dir output/pdf \
  src/assignment02/lab.ipynb

google-chrome --headless --no-sandbox --disable-gpu \
  --print-to-pdf="$PWD/output/pdf/assignment02-lab.pdf" \
  "file://$PWD/output/pdf/lab.html"
```
