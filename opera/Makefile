# Makefile for opera

# NB: Use a symbolic link to avoid paths with spaces,
# because make(1) cannot treat such paths correctly.
INSTALLATION_DIR := ./profile-link

non_configuration_files := \
	Makefile \
	normalize-ini \
	profile-link \
	version-11.10/%
TARGETS_STATIC = $(filter-out $(non_configuration_files),$(all_files_in_repos))




include ../mduem/Makefile

# __END__
