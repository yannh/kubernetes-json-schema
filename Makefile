#!/usr/bin/make -f

gen:
	./build.sh

DATA_DIRS := $(shell find -type d -name 'master*' -or -type d -name 'v*')
INDEX_FILES := $(patsubst %,%/index.json,$(DATA_DIRS))

index: $(INDEX_FILES)
	./scripts/update-versions-listing.sh

%/index.json:
	./scripts/update-schema-listing.py -d $(dir $@)
