# TODO

- [x] Update `cv.tex` inputs to match existing section files (`04-honors.tex`, `05-publications.tex`, `06-professionalservice.tex`, `07-credentials.tex`) so XeLaTeX can compile without missing-file errors.
- [ ] Replace placeholder bullets (`\item {}`) in `cv/02-professionalexperience.tex` with actual accomplishments or remove the empty items to avoid blank list entries.
- [x] Correct the Education entry in `cv/01-education.tex` (fix "California Statue University" to "California State University" and align the BA completion date with the career timeline).
- [x] Clean up spelling/wording issues in `cv/02-professionalexperience.tex` (e.g., "Data Coordintor", "Curriculum and Instruction Coordintor", "Collegeboard", "utilzing", "Reporting services").
- [x] Fix typos in presentation listings in `cv/03-presentations.tex` ("Excellence Though", "Leadership Institude", "resouces").
- [x] Address remaining typos and geography issues (`cv/04-honors.tex`, `cv/05-publications.tex`, `cv/06-professionalservice.tex`), such as "Educaiton", "Las Vegas, CA", and "Riverside Country".
- [x] Re-run XeLaTeX after corrections to confirm the document builds cleanly and nothing else regresses. (Current warning: FontAwesome font missing in TeX Live image.)

## Auto-deploy CV PDF to GitHub Pages repo

- [ ] **Create a fine-grained GitHub PAT** scoped to `nickchitwood/nickchitwood.github.io` with **Contents: Read and write** permission.
- [ ] **Add the PAT as a repo secret** in `nickchitwood/cv` named `PAGES_DEPLOY_TOKEN`.
- [ ] **Add a deploy step** to `.github/workflows/cv-build.yml` after the PDF upload:

```yaml
      - name: Deploy CV to GitHub Pages repo
        if: github.ref == 'refs/heads/master' && github.event_name == 'push'
        run: |
          git clone https://x-access-token:${{ secrets.PAGES_DEPLOY_TOKEN }}@github.com/nickchitwood/nickchitwood.github.io.git pages-repo
          cp cv.generated.pdf pages-repo/assets/cv.pdf
          cd pages-repo
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add assets/cv.pdf
          git diff --cached --quiet || git commit -m "Update CV PDF (from cv repo ${GITHUB_SHA::7})"
          git push
```

- [ ] **Test** by pushing a small change to `data/cv.yaml` and verifying the Pages repo gets an automated commit.
