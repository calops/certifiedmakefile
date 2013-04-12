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

# This variable contains the path separator used to separate directories in a
# path.
VARIABLECONTAININGTHEPATHSEPARATOR                       = /
# This variable contains the radical of the target file.
VARIABLECONTAININGTHERADICALOFTHETARGETFILE              = index
VARIABLECONTAININGTHEFILEEXTENSIONSEPARATORFORFILE       = .

# This variable contains the extension of the target file.
VARIABLECONTAININGTHEFILEEXTENSIONFORHTMLFILE            = html
VARIABLECONTAININGTHEFILEEXTENSIONFORTARGETFILE          = $(VARIABLECONTAININGTHEFILEEXTENSIONSEPARATORFORFILE)$(VARIABLECONTAININGTHEFILEEXTENSIONFORHTMLFILE)

# This variable contains the file extension of the source file.
VARIABLECONTAININGTHEFILEEXTENSIONFORMDFILE              = md
VARIABLECONTAININGTHEFILEEXTENSIONFORSOURCEFILE          = $(VARIABLECONTAININGTHEFILEEXTENSIONSEPARATORFORFILE)$(VARIABLECONTAININGTHEFILEEXTENSIONFORMDFILE)

# This variable contains the full name of the target file.
VARIABLECONTAININGTHETARGETNAME                          = $(VARIABLECONTAININGTHERADICALOFTHETARGETFILE)$(VARIABLECONTAININGTHEFILEEXTENSIONFORTARGETFILE)

# This variable contains the full name of the source file. Tricky part: it is
# actually computed from the variable containing the full name of the target
# file.
VARIABLECONTAININGTHESOURCEFILECOMPUTEDFROMTHETARGETNAME = $(subst $(VARIABLECONTAININGTHEFILEEXTENSIONFORTARGETFILE),$(VARIABLECONTAININGTHEFILEEXTENSIONFORSOURCEFILE),$(VARIABLECONTAININGTHETARGETNAME))

# These variables contain backend-related stuff in order to abstract OS
# interactions from the actual compiling code.
# TODO: according to the certifiedmakefile coding style, every variable
# declaration should have its own verbose and excplicit comment describing its
# behavior.
# TODO: write the certifiedmakefile coding style
ifeq '${/usr/bin/env python2 && echo "python2 is here" || echo "python2 is not here"}' 'python2 is here'
VARIABLECONTAININGTHEVERSIONOFPYTHON                   = python2
else
VARIABLECONTAININGTHEVERSIONOFPYTHON                   = python
endif
VARIABLEREFERENCINGTHEPYTHONINTERPRETER                = $(VARIABLECONTAININGTHEPATHSEPARATOR)usr$(VARIABLECONTAININGTHEPATHSEPARATOR)bin$(VARIABLECONTAININGTHEPATHSEPARATOR)env $(VARIABLECONTAININGTHEVERSIONOFPYTHON)
VARIABLECONTAININGTHEPATHTOTHESEDBINARY                = $(VARIABLECONTAININGTHEPATHSEPARATOR)bin$(VARIABLECONTAININGTHEPATHSEPARATOR)sed
VARIABLECONTAININGTHENAMEOFTHEMARKUPMODULE             = markdown
VARIABLECONTAININGTHEPATHTOTHERMBINARY                 = $(VARIABLECONTAININGTHEPATHSEPARATOR)bin$(VARIABLECONTAININGTHEPATHSEPARATOR)rm
VARIABLECONTAININGTHEPATHTOTHETESTDIRECTORY            = t
VARIABLECONTAININGTHEPATHTOTHEDIFFBINARY               = $(VARIABLECONTAININGTHEPATHSEPARATOR)usr$(VARIABLECONTAININGTHEPATHSEPARATOR)bin$(VARIABLECONTAININGTHEPATHSEPARATOR)diff
VARIABLECONTAININGTHEPATHTOTHECDBINARY                 = cd
VARIABLECONTAININGTHECOMMANDTOCREATEANEWINSTANCEOFMAKE = $(MAKE)
VARIABLECONTAININGTHETESTREFERENCEOUTPUTEXTENSION      = .ref
VARIABLECONTAININGTHEECHOCOMMAND		       = echo

# TODO i18n these strings
# TODO adjust to the naming convention if these stay here
VARIABLECONTAININGWHITESPACEFORTHETEST      = " "
VARIABLECONTAININGTHETESTNAME               = "Test"
VARIABLECONTAININGTHETESTNAMESCHEME         = $(VARIABLECONTAININGTHETESTNAME)$(VARIABLECONTAININGWHITESPACEFORTHETEST)
VARIABLECONTAININGTHETESTSUCCESSSTRING      = "Success"
VARIABLECONTAININGTHETESTFAILURESTRING      = "Failure"
VARIABLECONTAININGTHEFULLTESTSUCCESSMESSAGE = $($VARIABLECONTAININGTHETESTNAMESCHEME)$(VARIABLECONTAININGTHETESTSUCCESSSTRING)
VARIABLECONTAININGTHEFULLTESTFAILUREMESSAGE = $($VARIABLECONTAININGTHETESTNAMESCHEME)$(VARIABLECONTAININGTHETESTFAILURESTRING)
VARIABLECONTAININGAREDIRECTTODEVNULL        = >/dev/null 2>&1

# This is the default rule that tepens only on the target file.
all: $(VARIABLECONTAININGTHETARGETNAME)

# This is required in case we ever want to have a file called "clean" or "test"
.PHONY: clean test ensure_python

# This is the rule that does all the work. It compiles the source file into the
# target file, and then modifies the target file to be exactly like we wanted
# it to be in the first place and are too lazy to configure the markdown module
# before calling it.
$(VARIABLECONTAININGTHETARGETNAME): $(VARIABLECONTAININGTHESOURCEFILECOMPUTEDFROMTHETARGETNAME) ensure_python
	# This command compiles the source file as a markdown file into an html
	# file, which happens to be our target file
	$(VARIABLEREFERENCINGTHEPYTHONINTERPRETER) -m $(VARIABLECONTAININGTHENAMEOFTHEMARKUPMODULE) $< > $@
	# This command adds a header to the target file to put a decent charset and
	# shit.
	$(VARIABLECONTAININGTHEPATHTOTHESEDBINARY) -i '1i<meta http-equiv="content-type" content="text/html; charset=utf-8" />' $@
	# This command helps formatting the entries that are interpreted as code
	# due to markdown syntax but actually we just wanted a <pre> mark. But
	# yeah, that doesn't do exactly what we want so we sed the shit out of it.
	$(VARIABLECONTAININGTHEPATHTOTHESEDBINARY) -i 's/<pre>/<pre style="white-space: pre-wrap;">/' $@

ensure_python:
	$(VARIABLEREFERENCINGTHEPYTHONINTERPRETER) -c "import $(VARIABLECONTAININGTHENAMEOFTHEMARKUPMODULE)" $(VARIABLECONTAININGAREDIRECTTODEVNULL) || ( $(VARIABLECONTAININGTHEECHOCOMMAND) "Sorry, you are missing the markdown module" && exit 4 ) 

# This rule implements a basic unit test
# TODO: every line should have its own comment
test:
	# Recursively descend into the test directory and invoke make
	$(VARIABLECONTAININGTHEPATHTOTHECDBINARY) $(VARIABLECONTAININGTHEPATHTOTHETESTDIRECTORY); $(VARIABLECONTAININGTHECOMMANDTOCREATEANEWINSTANCEOFMAKE)
	# FIXME: there are hardcoded strings in this command. This is unacceptable.
	$(VARIABLECONTAININGTHEPATHTOTHEDIFFBINARY) $(VARIABLECONTAININGTHEPATHTOTHETESTDIRECTORY)$(VARIABLECONTAININGTHEPATHSEPARATOR)$(VARIABLECONTAININGTHETARGETNAME) $(VARIABLECONTAININGTHEPATHTOTHETESTDIRECTORY)$(VARIABLECONTAININGTHEPATHSEPARATOR)$(VARIABLECONTAININGTHETARGETNAME)$(VARIABLECONTAININGTHETESTREFERENCEOUTPUTEXTENSION) && $(VARIABLECONTAININGTHEECHOCOMMAND) "$(VARIABLECONTAININGTHEFULLTESTSUCCESSMESSAGE)" || $(VARIABLECONTAININGTHEECHOCOMMAND) "$(VARIABLECONTAININGTHEFULLTESTFAILUREMESSAGE)"

# This rule helps clean the project by removing every generated file.
clean:
	# This command deletes a file. Ideally, the target file.
	$(VARIABLECONTAININGTHEPATHTOTHERMBINARY) -f $(VARIABLECONTAININGTHETARGETNAME)

# Yes, the number of occurrences of the word "shit" in this file is way too
# high.
