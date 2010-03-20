# Driver Makefile
# Requirement: GNU make

softwares_common := dotfiles git opera sh vim

softwares := \
	$(softwares_common) \
	$(softwares_$(ENV_WORKING)) \
	$(softwares_$(ENV_WORKING)_$(USER))




all: build

%:
	for i in $(softwares); do \
	  $(MAKE) -C "./$$i" '$@'; \
	done

# __END__
