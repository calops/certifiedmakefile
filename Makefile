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

# It is absolutely crucial to abstract these away in case we want to thange
# them later !

VARIABLEPYTHONINTERPRETER = /usr/bin/env python2
VARIABLESED               = /bin/sed
VARIABLEMARKDOWNMODULE    = markdown
VARIABLERMBINARY          = /bin/rm
VARIABLETESTDIR           = t
VARIABLEDIFF              = /usr/bin/diff
VARIABLECD                = cd


# TODO i18n these strings
VARIABLETESTWHITESPACE    = " "
VARIABLETESTNAME          = "Test"
VARIABLETESTNAMESCHEME    = $($VARIABLETESTNAME, $VARIABLETESTWHITESPACE)
VARIABLETESTSUCCESSSTRING = "Success"
VARIABLETESTFAILURESTRING = "Failure"
VARIABLETESTSUCCESS       = $($VARIABLETESTNAMESCHEME, $VARIABLETESTSUCCESSSTRING)
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
	$(VARIABLEPYTHONINTERPRETER) -m $(VARIABLEMARKDOWNMODULE) $< > $@
	# This command adds a header to the target file to put a decent charset and
	# shit.
	$(VARIABLESED) -i '1i<meta http-equiv="content-type" content="text/html; charset=utf-8" />' $@
	# This command helps formatting the entries that are interpreted as code
	# due to markdown syntax but actually we just wanted a <pre> mark. But
	# yeah, that doesn't do exactly what we want so we sed the shit out of it.
	$(VARIABLESED) -i 's/<pre>/<pre style="white-space: pre-wrap;">/' $@


# This rule implements a basic unit test
test:
	$(VARIABLECD) $(VARIABLETESTDIR); $(MAKE)
	$(VARIABLEDIFF) $(VARIABLETESTDIR)/index.html $(VARIABLETESTDIR)/index.html.ref && echo $(VARIABLETESTSUCCESS) || echo $(VARIABLETESTFAILURE)

# This rule helps clean the project by removing every generated file.
clean:
	# This command deletes a file. Ideally, the target file.
	$(VARIABLERMBINARY) -f $(VARIABLECONTAININGTHETARGETNAME)

# Yes, the number of occurrences of the word "shit" in this file is way too
# high.
