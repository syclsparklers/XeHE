# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SOURCEDIR     = source
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

clean: Makefile
	@$(SPHINXBUILD) -M clean "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

latex: Makefile
	@$(SPHINXBUILD) -M latex "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@mkdir -p "$(BUILDDIR)"/latex 
	@-cp -p source/_images/SYCL*.png   "$(BUILDDIR)"/latex
	@-cp -p source/_images/Barcode*    "$(BUILDDIR)"/latex
	@-cp -p source/_images/399264*     "$(BUILDDIR)"/latex
	@-cp -p source/_images/by-eps*pdf  "$(BUILDDIR)"/latex
	@mv "$(BUILDDIR)"/latex/Sparkler-XeHE.v001.tex "$(BUILDDIR)"/latex/originalTexoutput
	@-sed -e 's@\\usepackage{hyperref}@\\usepackage\[hyphens\]{url}\\usepackage{hyperref}@' > "$(BUILDDIR)"/latex/Sparkler-XeHE.v001.tex < "$(BUILDDIR)"/latex/originalTexoutput

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
