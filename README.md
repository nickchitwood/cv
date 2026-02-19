# CV Workflow

This repository now supports a data-driven build path:

1. Edit content in `data/cv.yaml`.
2. Render LaTeX with `make render`.
3. Build PDF with `make pdf`.

The rendered file is `cv.generated.tex` and compiled output is `cv.generated.pdf`.

## Commands

- `make render`: Render YAML data into LaTeX.
- `make pdf`: Render + compile with `latexmk` (falls back to `xelatex` if `latexmk` is unavailable).
- `make archive`: Save a dated snapshot to `Chitwood-CV-YYYY-MM-DD.pdf`.
- `make release`: Create an archive snapshot, then copy `cv.generated.pdf` to `Chitwood-CV.pdf`.
- `make clean`: Remove generated artifacts.

## Notes

- Existing files like `cv.tex` remain untouched as a fallback.
- `data/cv.yaml` is the canonical source for the generated path.
- CI workflow: `.github/workflows/cv-build.yml` renders and compiles `cv.generated.tex` on pushes and pull requests, then uploads `cv.generated.pdf` as an artifact.
