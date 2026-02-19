# AGENTS.md

## Purpose
This repository builds a professional CV from structured YAML data using an ERB LaTeX template.

## Canonical Files
- Data source: `/Users/nchitwood/Documents/GitHub/cv/data/cv.yaml`
- Template: `/Users/nchitwood/Documents/GitHub/cv/templates/cv.tex.erb`
- Renderer: `/Users/nchitwood/Documents/GitHub/cv/scripts/render_cv.rb`
- Build commands: `/Users/nchitwood/Documents/GitHub/cv/Makefile`

## Build Workflow
1. Edit content in `data/cv.yaml`.
2. Run `make render` to generate `cv.generated.tex`.
3. Run `make pdf` to compile `cv.generated.pdf`.
4. Run `make release` to:
   - create a dated archive snapshot, and
   - copy `cv.generated.pdf` to `Chitwood-CV.pdf`.

## Editing Conventions
- Keep content changes in YAML, not directly in generated TeX.
- Preserve section order unless explicitly requested.
- Use concise, impact-first bullets with numbers where available.
- For long URLs in publications, prefer `\\href{url}{label}` over raw `\\url{...}`.
- For credentials, current format uses single-line credential text in `credential` and leaves `level`/`dates` empty by design.

## Section-Specific Notes
- Publications section title is `Selected Professional Work`.
- Publications entries may include optional `scope_note`; template renders it only when present.
- Professional/Civic Service uses `cvhonors` (date column can wrap if dates are too long).

## Validation
After content/template edits:
1. `make render`
2. `make pdf`
3. Check `cv.generated.log` for serious errors.

Notes:
- Small `Overfull \\hbox` warnings (about 1–2pt) may be acceptable if visual output is good.
- FontAwesome ToUnicode warnings in this environment are known and non-blocking.

## Git/Release Practice
- If asked to snapshot everything, include generated/archival files explicitly.
- Otherwise, prefer committing source-of-truth files (`data/`, `templates/`, `scripts/`, build config) and the release PDF only when requested.
