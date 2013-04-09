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

# This variable contains the radical of the target file.
VARIABLECONTAININGTHERADICALOFTHETARGETFILE              = index

# This variable contains the extension of the target file.
VARIABLECONTAININGTHEFILEEXTENSIONFORTARGETFILE          = .html

# This variable contains the file extension of the source file.
VARIABLECONTAININGTHEFILEEXTENSIONFORSOURCEFILE          = .md

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
VARIABLEREFERENCINGTHEPYTHONINTERPRETER                = /usr/bin/env python
VARIABLECONTAININGTHEPATHTOTHESEDBINARY                = /bin/sed
VARIABLECONTAININGTHENAMEOFTHEMARKUPMODULE             = markdown
VARIABLECONTAININGTHEPATHTOTHERMBINARY                 = /bin/rm
VARIABLECONTAININGTHEPATHTOTHETESTDIRECTORY            = t
VARIABLECONTAININGTHEPATHTOTHEDIFFBINARY               = /usr/bin/diff
VARIABLECONTAININGTHEPATHTOTHECDBINARY                 = cd
VARIABLECONTAININGTHECOMMANDTOCREATEANEWINSTANCEOFMAKE = $(MAKE)


# TODO i18n these strings
# TODO adjust to the naming convention if these stay here
VARIABLETESTWHITESPACE    = " "
VARIABLETESTNAME          = "Test"
VARIABLETESTNAMESCHEME    = $($VARIABLETESTNAME, $VARIABLETESTWHITESPACE)
VARIABLETESTSUCCESSSTRING = "Success"
VARIABLETESTFAILURESTRING = "Failure"
VARIABLETESTSUCCESS       = $($VARIABLETESTNAMESCHEME, $VARIABLETESTSUCCESSSTRING))
VVARIABLETESTFAILURE      = $($VARIABLETESTNAMESCHEME, $VARIABLETESTFAILURESTRING)

# This is the default rule that tepens only on the target file.
all: $(VARIABLECONTAININGTHETARGETNAME)

# This is the rule that does all the work. It compiles the source file into the
# target file, and then modifies the target file to be exactly like we wanted
# it to be in the first place and are too lazy to configure the markdown module
# before calling it.
$(VARIABLECONTAININGTHETARGETNAME): $(VARIABLECONTAININGTHESOURCEFILECOMPUTEDFROMTHETARGETNAME)
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


# This rule implements a basic unit test
# TODO: every line should have its own comment
test:
	$(VARIABLECONTAININGTHEPATHTOTHECDBINARY) $(VARIABLECONTAININGTHEPATHTOTHETESTDIRECTORY); $(VARIABLECONTAININGTHECOMMANDTOCREATEANEWINSTANCEOFMAKE)
	# TODO: there are hardcoded strings in this command. This is unacceptable.
	$(VARIABLECONTAININGTHEPATHTOTHEDIFFBINARY) $(VARIABLECONTAININGTHEPATHTOTHETESTDIRECTORY)/index.html $(VARIABLECONTAININGTHEPATHTOTHETESTDIRECTORY)/index.html.ref && echo $(VARIABLETESTSUCCESS) || echo $(VARIABLETESTFAILURE)

# This rule helps clean the project by removing every generated file.
clean:
	# This command deletes a file. Ideally, the target file.
	$(VARIABLECONTAININGTHEPATHTOTHERMBINARY) -f $(VARIABLECONTAININGTHETARGETNAME)

# Yes, the number of occurrences of the word "shit" in this file is way too
# high.
