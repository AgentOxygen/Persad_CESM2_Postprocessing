#!/bin/bash
# Searches contents of tar files in directory for keyword matches
# Arguments can be multiple keywords. Example useage:
# ./find_archives.sh atm SFCO2 SFdst

LIST=""
for FILE in *.tar
do
    CONTENTS=$(tar -tf $FILE)
    for KEY in $@
    do
	if [[ $CONTENTS == *"${KEY}"* ]]; then
	    echo $FILE
	    LIST="${LIST} ${FILE}"
	fi
    done
done
echo $LIST
