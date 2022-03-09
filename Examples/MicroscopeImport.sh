#!/bin/bash

## Import for individua Windows computer
#Read config file
config=$( bash OMEROimport check_config )
if [ "${config//ERROR/}" != "${config}" ]; then
      echo "${config}"
      exit 1
else
  source $config
fi

#Import data for each folder on path
log_files=()
i=0
for folder in "$path"/*; do
  if [ $(basename "$folder") != "Imported" ] && [ $(basename "$folder") != "OldData" ] && [ $(basename "$folder") != "imported" ]; then
    user=$(bash OMEROimport read_file --file="$folder"/.username.txt)
    if [[ $user != ERROR* ]]; then
      # Move old data
      bash OMEROimport move_old --location="$folder"
      # Import data
      result=$(bash OMEROimport import_folder --user="$user" --folder="$folder")
    else
      result=$user
    fi
    if [ "${result//=== No files/}" != "${result}" ] || \
       [ "${result//ERROR/}" != "${result}" ]; then
      echo "${result}"
    else
      bash OMEROimport move_imports --logfile="${result}" --target="$imp_path"
      log_files[$i]="$result"
      i=$((i+1))
    fi
  fi
done

# Move imported files to imp_path
for log in ${log_files[@]}; do
  mv "$log" "$archive"/"$micro"_$(date +%Y%m%d)_"$log"
  rm "Before_$log"
done

#Remove all empty files
find . -size 0 -delete
