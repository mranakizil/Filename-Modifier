
# EOPSY Operating Systems - Task #1
# Merve Rana Kızıl

# !/bin/bash

sed_pattern=""

rename_file() {
    for file in "$1"/*
        do 
            curr_filename="$(basename $file)"
            
            # If there is no file in the dir
            if [ "$curr_filename" = "*" ]
            then
                break
            fi
            new_filename="$1/`echo $curr_filename | sed $sed_pattern`"

            if [ -d "$file" ]; then
                if [ "$2" = true ]; then
                    rename_file $file true
                fi
            elif [ "$new_filename" != "$file" ]; then
                if [ "$2" = true -o "$3" = "$curr_filename" ]; then
                    mv "$file" "$new_filename"
                fi  
            fi
        done  
}


get_help() {       
cat<<EOT 
Usage:
  $0 [-r] [-l|-u] <dir/file names...>
  $0 [-r] <sed pattern> <dir/file names...>
  $0 [-h]
Options:
  -r runs with recursion
  -l lowerizes filenames
  -u uppercases filenames
  -h shows help
Syntax examples:
  $0 -r -u directory
  $0 -l file1.txt file2.txt
  $0 's/f/t/' file3.txt file4.txt
  $0 -r 's/a/b/' directory
EOT
exit
}


# If recursion is chosen
if [ $# -eq 3 -a $1 = "-r" ]; then
    if [ $2 = "-l" ]; then
        # lowerize
        sed_pattern="s/[A-Z]/\L&/g"
        rename_file $3 true
    elif [ $2 = "-u" ]; then
        # uppercase
        sed_pattern="s/[a-z]/\U&/g"
        rename_file $3 true
    else
        # Using sed pattern
        sed_pattern="$2"
        rename_file $3   true 
fi
elif [ $# -eq 1 -a $1 = "-h" ]; then
    get_help `basename "$0"`
# If recursion is not chosen
else
    for ((i = 2; i <= $#; i++ )); do
        if [ $1 = "-l" ]; then
            # lowerize
            sed_pattern="s/[A-Z]/\L&/g"
            rename_file "$(pwd)" false "${!i}"
        elif [ $1 = "-u" ]; then
            # uppercase
            sed_pattern="s/[a-z]/\U&/g"
            rename_file "$(pwd)" false "${!i}"
        else
            # using sed pattern
            sed_pattern="$1"
            rename_file "$(pwd)" false "${!i}"
        fi
    done
fi