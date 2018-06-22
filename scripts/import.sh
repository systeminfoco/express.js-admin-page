#!/bin/bash

# Instructions:
# 1. Create files import_concepts.txt / import_mappings.txt / import_terminologies.txt
#    with one line for each file or URL to be imported (lines starting with # are ignored)
# 2. Make script executable: $ chmod +x import.sh
# 3. run $ ./scripts/import.sh /path/to/jskos-server
#    IF script is not under scripts/ in jskos-server, you need to specify its path:
#    $ ./scripts/import.sh /path/to/jskos-server

CURRENT_DIR=$(dirname $0)
IMPORT_DIR=$CURRENT_DIR"/.files_to_import"
# Server directory
if [ "$#" -eq  "0" ]
  then
    SERVER_DIR=$CURRENT_DIR"/.."
  else
    SERVER_DIR=$1
fi
if [[ ! -d $SERVER_DIR ]]; then
  echo "Server directory does not exist."
  exit 1
fi

# Create import directory
[[ -d $IMPORT_DIR ]] || mkdir $IMPORT_DIR

cd $SERVER_DIR

# Define function for download and import
# Usage: download_import -m ${FILES[@]}
# (replace -m with -t for terminologies or -c for concepts)
download_import() {
  local OPT=$1
  shift
  local FILES=($@)
  ## Remove all existing mappings/terminologies/concepts
  npm run import -- -r -i $OPT
  ## Download and import
  for FILE in ${FILES[@]}; do
    if [[ $FILE == \#* ]];
    then
      echo
      echo "##### Skipping $FILE #####"
      echo
      continue
    fi
    echo
    echo "##### Importing $FILE #####"
    if [[ $FILE == http* ]];
    then
      ### Download file if it starts with http
      local EXT="${FILE##*.}"
      wget -q $FILE -O $IMPORT_DIR"/file."$EXT
      FILE=$IMPORT_DIR"/file."$EXT
    fi
    ### Import file
    npm rum import -- $OPT $FILE
  done
}

OLD_IFS=$IFS
IFS=$'\n'

# Import mappings
FILES=( $(cat $CURRENT_DIR/import_mappings.txt) )
download_import -m ${FILES[@]}

# Import terminologies
FILES=( $(cat $CURRENT_DIR/import_terminologies.txt) )
download_import -t ${FILES[@]}

# Import concepts
FILES=( $(cat $CURRENT_DIR/import_concepts.txt) )
download_import -c ${FILES[@]}

IFS=$OLD_IFS
# Delete import directory
rm -r $IMPORT_DIR
cd $CURRENT_DIR

echo "##### Importing done! #####"
