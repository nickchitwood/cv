INPUT := data/cv.yaml
TEMPLATE := templates/cv.tex.erb
GENERATED_TEX := cv.generated.tex
GENERATED_PDF := cv.generated.pdf
DATE := $(shell date +%F)

.PHONY: render pdf release archive clean

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
