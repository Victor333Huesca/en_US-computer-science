#!/usr/bin/bash


# ==================== Parse arguments ====================
usage() {
    _text="Usage: $(basename $0) [-f] <file>\n"
    _text+="\n"
    _text+="Arguments:\n"
    _text+="  \t  file         \t            A file where each line represent a word\n"
    _text+="\n"
    _text+="Options:\n"
    _text+="  \t  -f           \t            Force to override existing dictionary\n"
    _text+="  \t  -h           \t            Display this help message\n"
    _text+="  \t  -v           \t            Display the version\n"
    echo -e $_text #>&2
}


prompt_confirm() {
    while true; do
        read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
        case $REPLY in
            [yY])  echo ; return 0 ;;
            [nN])  echo ; return 1 ;;
            *)     printf " \033[31minvalid input\n\033[0m" >&2
        esac
    done
}



# Initialize our own variables
force=false
file=""

# Reset in case getopts has been used previously in the shell
OPTIND=1
while getopts "hf" opt; do
    case $opt in
    h)
        usage
        exit 0
        ;;
    f)
        force=true
        ;;
    *)
        usage
        exit -1
        ;;
    esac
done
shift $((OPTIND-1))


# ================= Ensure everything is ok ===================

# Get the dictionary name
if [ -z $1 ]; then
    echo "A file containg the list of words" \
         "is required to create the dictionary."
    echo "For usage use '-h'."
    exit -1
else
    file=$1
fi


# Avoid overriding w/o explicit confirmation
if [ $force == false ] && ([[ -f $file.dic || -f $file.aff ]]); then
    echo "A $(file) dictionnary of affix already exists."
    prompt_confirm "Do you want to override it?" || exit 0
fi


# ==================== Actualy do the job =====================

wc -l $file > $file.dic
sort $file | uniq >> $file.dic
touch $file.aff



