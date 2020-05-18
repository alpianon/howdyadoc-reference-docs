# Makefile
#
# SPDX-FileCopyrightText: 2020 Alberto Pianon <pianon@array.eu>
# SPDX-License-Identifier: GPL-3.0-only
#
# 'make' or 'make model': compile (pack) OOXML and OpenDocument source dirs 
# within SRCDIR into docx or odt files within BUILDDIR (source dirs must have
# the same extension of the corresponding target file, like 'document.docx')
# 
# 'make source': decompile (unpack and pretty format) OOXML and Opendocument
# files within BUILDDIR into source dirs within SRCDIR (source dirs will have
# the same extension of the corresponding file in BUILDDIR, like 
# 'document.docx')
#
# There is no 'make clean' because it could be dangerous

# https://stackoverflow.com/a/12959764
# Make does not offer a recursive wildcard function, so here's one:
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

SRCDIR=src
BUILDDIR=build

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

models: $(DIRECT_TARGET)

sources: $(REVERSE_TARGET)

$(DIRECT_TARGET): $(DIRECT_SRC)
	cd $(SRCDIR)/$(notdir $@); $(ZIP) -r $(ABSPATH)/$@ .

$(REVERSE_TARGET): $(REVERSE_SRC)
	- rm -Rf $@
	$(MKDIR) $@; cd $@; $(UNZIP) $(ABSPATH)/$(BUILDDIR)/$(notdir $@); \
	$(FIND) . -type f \( -name "*.xml" -o -name "*.rels" -o -name ".rels" -o -name ".rdf" \) -exec $(XMLLINT) --output '{}' --format '{}' \;
