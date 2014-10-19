###############################################################################
#	genscertifies.tocards.net/Makefile
#	This makefile compiles some shit into some other shit.
#
# Copyright 2013 Remi "calops" Labeyrie <calops@tocards.net>
#
# This work is free. You can redistribute it and/or modify it under the terms
# of the Do What The Fuck You Want To Public License, Version 2, as published
# by Sam Hocevar.
# See the LICENSE file (http://genscertifies.tocards.net/LICENSE) for more
# details.
###############################################################################

#####################################################################
# This variable contains the path separator used to
# separate directories in a path.
#####################################################################

SLASH		= /

#####################################################################
# This variable contains the radical of the target file.
#####################################################################

RADICAL_TARGET	= index
INTERPUNCT		= .

#####################################################################
# This variable contains the extension of the target file.
#####################################################################

HTML_EXTENSION	= html
HTML_FILES	= $(INTERPUNCT)$(HTML_EXTENSION)

#####################################################################
# This variable contains the file extension of the source file.
#####################################################################

MD_EXTENSION		= md
MD_FILES	= $(INTERPUNCT)$(MD_EXTENSION)

#####################################################################
# This variable contains the full name of the target file.
#####################################################################

TARGET_NAME	= $(RADICAL_TARGET)$(HTML_FILES)

#####################################################################
# This variable contains the full name of the source file. 
# Tricky part: it's  actually computed from the variable containing
# the full name of the target file.
#####################################################################

ALL_FILES_OBJ	= $(subst $(HTML_FILES),$(MD_FILES),$(TARGET_NAME))

###############################################################################
# These variables contain backend-related stuff in order to abstract OS
# interactions from the actual compiling code.
# TODO: according to the certifiedmakefile coding style, every variable
# declaration should have its own verbose and excplicit comment describing its
# behavior.
# TODO: write the certifiedmakefile coding style
###############################################################################

ifeq '${/usr/bin/env python2 && echo "python2 is here" || echo "python2 is not here"}' 'python2 is here'
PYTHON_V		= python2
else
PYTHON_V		= python
endif
PYTHON_INTERPRETER	= $(SLASH)usr$(SLASH)bin$(SLASH)env $(PYTHON_V)
SED_COMMAND		= $(SLASH)bin$(SLASH)sed
MD_MODULE		= markdown
RM_COMMAND		= $(SLASH)bin$(SLASH)rm
TEST_DIR		= t
DIFF_COMMAND		= $(SLASH)usr$(SLASH)bin$(SLASH)diff
CD_COMMAND		= cd
MAKE_COMMAND		= $(MAKE)

#####################################################################
# TODO i18n these strings
# TODO adjust to the naming convention if these stay here
#####################################################################

SPACE_STR		= " "
TEST_NAME_STR		= "Test"
TEST_NAME_SCHEME	= $(TEST_NAME)$(SPACE)
SUCCESS_STR		= "Success"
FAILURE_STR		= "Failure"
SUCCESS_STATUT		= $($TEST_NAME_SCHEME)$(SUCCESS_STR)
FAILURE_STATUT		= $($TEST_NAME_SCHEME)$(FAILURE_STR)

#####################################################################
# This is the default rule that tepens only on the target file.
#####################################################################

all: $(TARGET_NAME)

###############################################################################
# This is the rule that does all the work. 
# It compiles the source file into the target file,
# and then modifies the target file to be exactly like we wanted it
# to be in the first place and are too lazy to configure the markdown module
# before calling it.
#
# Line by line :
# - compiles the source file as a markdown file into an html file,
#   which happens to be our target file
# - adds a header to the target file to put a decent charset and shit.
# - helps formatting the entries that are interpreted as code due 
#   to markdown syntax but actually we just wanted a <pre> mark.
#   But, that doesn't do exactly what we want so we sed the shit out of it.
#
###############################################################################

$(TARGET_NAME): $(ALL_FILES_OBJ)
	@$(PYTHON_INTERPRETER) -m $(MD_MODULE) $< > $@
	@$(SED_COMMAND) -i '1i<meta http-equiv="content-type" content="text/html; charset=utf-8" />' $@
	@$(SED_COMMAND) -i 's/<pre>/<pre style="white-space: pre-wrap;">/' $@

#####################################################################
# This rule implements a basic unit test
# TODO: every line should have its own comment
#####################################################################

test:
	@$(CD_COMMAND) $(TEST_DIR); $(MAKE_COMMAND)
	# FIXME: there are hardcoded strings in this command. This is unacceptable. >> Okay, fix it dude, but delete this damn comment... (no comment in corpus)
	@$(DIFF_COMMAND) $(TEST_DIR)$(SLASH)index.html $(TEST_DIR)$(SLASH)index.html.ref && echo $(SUCCESS_STATUT) || echo $(FAILURE_STATUT)

###############################################################################
# This rule helps clean the project by removing every generated file.
# Ideally, the command deletes the target file
###############################################################################

clean:
	@$(RM_COMMAND) -f $(TARGET_NAME)

###############################################################################
# Yes, the number of occurrences of the word "shit" in this file is way too
# high.
###############################################################################
