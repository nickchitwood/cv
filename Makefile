INPUT := data/cv.yaml
TEMPLATE := templates/cv.tex.erb
GENERATED_TEX := cv.generated.tex
GENERATED_PDF := cv.generated.pdf
DATE := $(shell date +%F)

# Resume variant — same template + class, different YAML source.
RESUME_INPUT := data/resume.yaml
RESUME_TEX := resume.generated.tex
RESUME_PDF := resume.generated.pdf

.PHONY: render pdf release archive clean \
        resume-render resume-pdf resume-release resume-archive resume-clean \
        letter-pdf letter-release letter-archive letter-clean

render:
	ruby scripts/render_cv.rb $(INPUT) $(GENERATED_TEX) $(TEMPLATE)

pdf: render
	@if command -v latexmk >/dev/null 2>&1; then \
		latexmk -xelatex -interaction=nonstopmode -halt-on-error $(GENERATED_TEX); \
	else \
		xelatex -interaction=nonstopmode -halt-on-error $(GENERATED_TEX); \
	fi

release: archive
	cp $(GENERATED_PDF) Chitwood-CV.pdf

archive: pdf
	@archive_file="Chitwood-CV-$(DATE).pdf"; \
	if [ -e "$$archive_file" ]; then \
		archive_file="Chitwood-CV-$(DATE)-$$(date +%H%M%S).pdf"; \
	fi; \
	cp $(GENERATED_PDF) "$$archive_file"; \
	echo "Archived $$archive_file"

clean:
	@if command -v latexmk >/dev/null 2>&1; then \
		latexmk -C $(GENERATED_TEX); \
	fi
	rm -f $(GENERATED_TEX) $(GENERATED_PDF)

#--- Resume targets ------------------------------------------------------------
resume-render:
	ruby scripts/render_cv.rb $(RESUME_INPUT) $(RESUME_TEX) $(TEMPLATE)

resume-pdf: resume-render
	@if command -v latexmk >/dev/null 2>&1; then \
		latexmk -xelatex -interaction=nonstopmode -halt-on-error $(RESUME_TEX); \
	else \
		xelatex -interaction=nonstopmode -halt-on-error $(RESUME_TEX); \
	fi

resume-release: resume-archive
	cp $(RESUME_PDF) Chitwood-Resume.pdf

resume-archive: resume-pdf
	@archive_file="Chitwood-Resume-$(DATE).pdf"; \
	if [ -e "$$archive_file" ]; then \
		archive_file="Chitwood-Resume-$(DATE)-$$(date +%H%M%S).pdf"; \
	fi; \
	cp $(RESUME_PDF) "$$archive_file"; \
	echo "Archived $$archive_file"

resume-clean:
	@if command -v latexmk >/dev/null 2>&1; then \
		latexmk -C $(RESUME_TEX); \
	fi
	rm -f $(RESUME_TEX) $(RESUME_PDF)

#--- Letter targets ------------------------------------------------------------
# Cover letter — self-contained letter.tex (no YAML / ERB), Atelier preamble
# inline. xelatex builds; make letter-release copies to Chitwood-Letter.pdf
# and creates a dated archive.
LETTER_TEX := letter.tex
LETTER_PDF := letter.pdf

letter-pdf:
	@if command -v latexmk >/dev/null 2>&1; then \
		latexmk -xelatex -interaction=nonstopmode -halt-on-error $(LETTER_TEX); \
	else \
		xelatex -interaction=nonstopmode -halt-on-error $(LETTER_TEX); \
	fi

letter-release: letter-archive
	cp $(LETTER_PDF) Chitwood-Letter.pdf

letter-archive: letter-pdf
	@archive_file="Chitwood-Letter-$(DATE).pdf"; \
	if [ -e "$$archive_file" ]; then \
		archive_file="Chitwood-Letter-$(DATE)-$$(date +%H%M%S).pdf"; \
	fi; \
	cp $(LETTER_PDF) "$$archive_file"; \
	echo "Archived $$archive_file"

letter-clean:
	@if command -v latexmk >/dev/null 2>&1; then \
		latexmk -C $(LETTER_TEX); \
	fi
	rm -f $(LETTER_PDF)
