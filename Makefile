test:
	@if [ ! $(TEST) ] ; then TEST="*.t" ; fi
	@PATH=/usr/sbin:$(PATH) \
	prove -r "t/$(TEST)"
