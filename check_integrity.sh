for FILE in *.tar
do
    echo "Checking ${FILE}"
    if ! tar tf $FILE &> /dev/null; then
	echo "${FILE} has an error!"
    fi
done

