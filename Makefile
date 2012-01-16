# Makefile to generate the documents of Vim plugins for GitHub Pages.
#
# Requirement
# ===========
#
# GNU make 3.81 or later
#
#
# Structure
# =========
#
# $(doc_dir)
# vim/index.html        The table of contents for available documents.
# vim/*.html            HTML-format document for a Vim plugin.
#
# $(tmp_dir)
# tmp/*.txt             :help-format document for a Vim plugin.
#
# submodules/*          Submodules to track changes of a Vim plugins.
#
# Makefile              Utility to maintain the documents.
# scripts/*              Misc. utilities for Makefile.

SHELL := /bin/bash

toplevel_dir := $(shell git rev-parse --show-toplevel)
doc_dir := $(toplevel_dir)/vim
tmp_dir := $(toplevel_dir)/tmp




.PHONY: all
all:
	$(MAKE) fetch
	$(MAKE) generate
	rm -f tmp/msg
	echo "Update documents to $$(date '+%Y-%m-%d %H:%M:%S %Z')" >>tmp/msg
	echo '' >>tmp/msg
	git submodule status | sed 's/^.//' >>tmp/msg
	git commit --file tmp/msg
	git push github gh-pages




.PHONY: fetch
fetch:
	git submodule foreach ' \
	  git fetch origin master --tags && \
	  git checkout master && \
	  git reset --hard FETCH_HEAD && \
	  git submodule update --init --recursive && \
	  cd $(toplevel_dir) && \
	  git add $$path \
	'




.PHONY: generate
generate:
	rm -rf $(doc_dir) $(tmp_dir)
	mkdir -p $(doc_dir) $(tmp_dir)
	git submodule foreach ' \
	  $(MAKE) 'INSTALLATION_DIR=$(tmp_dir)' install \
	'
	-vim -e -s -c 'helptags $(tmp_dir)/doc | quit'  # BUGS: (*1)
	./scripts/generate-vimhelp-index \
	  scripts/index.txt.in \
	  $(tmp_dir)/doc/*.txt \
	  >$(tmp_dir)/doc/index.txt
	$(MAKE) $$(ls $(tmp_dir)/doc/*.txt | sed 's/\.txt$$/.html/')
	cp $(tmp_dir)/doc/*.html $(doc_dir)
	git add $(doc_dir)

%.html: %.txt
	./scripts/convert-vimhelp-to-html $< >$@

# (*1): The vim(1) command always exits with 1 if it starts in Ex mode.
#       For convenience, the exit status is simply ignored,
#       but essentially, it should not be ignored.




# __END__
