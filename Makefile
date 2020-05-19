# Makefile
#
# SPDX-FileCopyrightText: 2020 Alberto Pianon <pianon@array.eu>
# SPDX-License-Identifier: GPL-3.0-only
#
# How does it work? See comments in 'noaction' and 'clean' sections below

# https://stackoverflow.com/a/12959764
# Make does not offer a recursive wildcard function, so here's one:
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

SRCDIR=src
BUILDDIR=.

MKDIR=/bin/mkdir
ZIP=/usr/bin/zip
UNZIP=/usr/bin/unzip
FIND=/usr/bin/find
TOUCH=/usr/bin/touch
XMLLINT=/usr/bin/xmllint

ABSPATH=$(abspath .)

SRC_MODEL_DIRS_WITH_TRAILING_SLASH=$(sort $(dir $(wildcard $(SRCDIR)/*/*)))
SRC_MODEL_DIRS=$(SRC_MODEL_DIRS_WITH_TRAILING_SLASH:/=)

# source and target to compile sources into document models
DIRECT_SRC=$(foreach d, $(SRC_MODEL_DIRS), $(call rwildcard,$d,*.*) $(call rwildcard,$d,.rels) )
DIRECT_TARGET=$(foreach d, $(SRC_MODEL_DIRS), $(BUILDDIR)/$(notdir $d))

# source and target to decompile document models into sources
REVERSE_SRC=$(wildcard $(BUILDDIR)/*.*)
REVERSE_TARGET=$(foreach d, $(REVERSE_SRC), $(SRCDIR)/$(notdir $d))

noaction:
	# There is no default action here, on purpose. Since here 'make' is used both
	# to compile and to decompile, there is the risk to inadvertently overwrite
	# changes to compiled files you just made with Libreoffice / MS word etc.; so
	# you have to explicitly declare which model file or source folder has to be
	# made via 'make', e.g:
	#   1. if you are willing to make sources from example.docx file you have just
	#      edited in Libreoffice: 
	#      make src/example.docx 
	#   2. if you are willing to make the model file from sources:
	#      make example.docx
	# You can also perform bulk actions, if you know what you are doing:
	#   a. 'make models' will compile all sources to model files, overwriting the
	#      existing ones if they are older than source files (you will lose any 
	#      modifications made with Libreoffice/MS Word!)
	#   b. 'make sources' will decompile all model files to source directories,
	#      overwriting the existing ones

clean:
	# There is no clean action here, on purpose. Since 'make' is used both to
	# compile and to decompile, there is the risk to inadvertently delete the
	# wrong files or directories. Please manually delete what you want to delete.

models: $(DIRECT_TARGET)

sources: $(REVERSE_TARGET)

$(DIRECT_TARGET): $(DIRECT_SRC)
	cd $(SRCDIR)/$(notdir $@); $(ZIP) -r $(ABSPATH)/$@ .

$(REVERSE_TARGET): $(REVERSE_SRC)
	- rm -Rf $@
	$(MKDIR) $@; cd $@; $(UNZIP) $(ABSPATH)/$(BUILDDIR)/$(notdir $@); \
	$(FIND) . -type f \( -name "*.xml" -o -name "*.rels" -o -name ".rels" -o -name ".rdf" \) -exec $(XMLLINT) --output '{}' --format '{}' \;
