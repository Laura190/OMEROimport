#!/bin/bash

##Import for individual Windows computer
# Parameters
micro=laura
path=/mnt/d/Data
imp_path=$path/Imported
archive=$path/ImportLogs
pass_file=/home/user/.pass.txt
env=/home/user/omero-env
conf_file=/home/user/import.cfg

#Moves old data
bash OMEROimport move_old --location="$path/"

#Import data for each folder on path
log_files=()
i=0
for folder in "$path"/*; do
  if [ $(basename "$folder") != "Imported" ] && [ $(basename "$folder") != "OldData" ] && [ $(basename "$folder") != "imported" ]; then
    user=$(bash OMEROimport read_file --file="$folder"/.username.txt)
    if [[ $user != ERROR* ]]; then
      result=$(bash OMEROimport import_folder --password_file="$pass_file" \
                 --environment="$env" --user="$user" --folder="$folder" \
                 --config="$conf_file") 
    else
      result=$user
    fi
    if [ "${result//=== No files/}" != "${result}" ] || \
       [ "${result//ERROR/}" != "${result}" ]; then
      echo "${result}"
    else
      log_files[$i]="$result"
      i=$((i+1))
    fi
  fi
done

# Move imported files to imp_path
for log in ${log_files[@]}; do
  bash OMEROimport move_imports --logfile="$log" --target="$imp_path"
  mv "$log" "$archive"/"$micro"_$(date +%Y%m%d)_"$log"
  rm "Before_$log"
done

#Remove all empty files
find . -size 0 -delete
