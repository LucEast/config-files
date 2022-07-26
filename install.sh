#!/bin/bash
help()
{
    ############################################################
    #                           Help                           #
    ############################################################
    # Display Help
    echo "This script copies the selected config files to their final location"
    echo
    echo "Syntax: $(basename $0) [-i|d|h]"
    echo "options:"
    echo "-i | --install    Installs selected configs."
    echo "-d | --delete     Deletes selected configs and removes all empty directorys under $HOME."
    echo "-h | --help       Print this Help."
    echo
    exit 2
}

function prompt_for_multiselect {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()   { printf "$ESC[?25h"; }
    cursor_blink_off()  { printf "$ESC[?25l"; }
    cursor_to()         { printf "$ESC[$1;${2:-1}H"; }
    print_inactive()    { printf "$2   $1 "; }
    print_active()      { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()    { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()         {
      local key
      IFS= read -rsn1 key 2>/dev/null >&2
      if [[ $key = ""      ]]; then echo enter; fi;
      if [[ $key = $'\x20' ]]; then echo space; fi;
      if [[ $key = $'\x1b' ]]; then
        read -rsn2 key
        if [[ $key = [A ]]; then echo up;    fi;
        if [[ $key = [B ]]; then echo down;  fi;
      fi 
    }
    toggle_option()    {
      local arr_name=$1
      eval "local arr=(\"\${${arr_name}[@]}\")"
      local option=$2
      if [[ ${arr[option]} == true ]]; then
        arr[option]=
      else
        arr[option]=true
      fi
      eval $arr_name='("${arr[@]}")'
    }

    local retval=$1
    local options
    local defaults

    IFS=';' read -r -a options <<< "$2"
    if [[ -z $3 ]]; then
      defaults=()
    else
      IFS=';' read -r -a defaults <<< "$3"
    fi
    local selected=()

    for ((i=0; i<${#options[@]}; i++)); do
      selected+=("${defaults[i]:-false}")
      printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - ${#options[@]}))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for option in "${options[@]}"; do
            local prefix="[ ]"
            if [[ ${selected[idx]} == true ]]; then
              prefix="[x]"
            fi

            cursor_to $(($startrow + $idx))
            if [ $idx -eq $active ]; then
                print_active "$option" "$prefix"
            else
                print_inactive "$option" "$prefix"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            space)  toggle_option selected $active;;
            enter)  break;;
            up)     ((active--));
                    if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi;;
            down)   ((active++));
                    if [ $active -ge ${#options[@]} ]; then active=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    eval $retval='("${selected[@]}")'
}


VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

if [ "$VALID_ARGUMENTS" -eq 0 ]; then
  help
fi


# Usage Example

OPTIONS_VALUES=(".zshrc" ".tmux.conf" ".vimrc" ".config/terminator/config")
OPTIONS_LABELS=("zsh" "tmux" "vim" "terminator")

for i in "${!OPTIONS_VALUES[@]}"; do
	OPTIONS_STRING+="${OPTIONS_VALUES[$i]} (${OPTIONS_LABELS[$i]});"
done

prompt_for_multiselect SELECTED "$OPTIONS_STRING"

for i in "${!SELECTED[@]}"; do
	if [ "${SELECTED[$i]}" == "true" ]; then
		CHECKED+=("${OPTIONS_VALUES[$i]}")
	fi
done
# echo "${CHECKED[@]}"


POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--install)
            if [[ -n ${CHECKED[3]} ]]; then
                # echo "${CHECKED[3]}"
                cp -r --parents ${CHECKED[3]} ~/test
            fi
            if [[ -n ${CHECKED[2]} ]]; then
                # echo "${CHECKED[2]}"
                cp -r --parents ${CHECKED[2]} ~/test
            fi
            if [[ -n ${CHECKED[1]} ]]; then
                # echo "${CHECKED[1]}"
                cp -r --parents ${CHECKED[1]} ~/test
            fi
            if [[ -n ${CHECKED[0]} ]]; then
                # echo "${CHECKED[0]}"
                cp -r --parents ${CHECKED[0]} ~/test
            fi
            shift # past argument
            ;;
        -d|--delete)
            if [[ -n ${CHECKED[3]} ]]; then
                # echo "${CHECKED[3]}"
                rm -r ~/test/${CHECKED[3]}
            fi
            if [[ -n ${CHECKED[2]} ]]; then
                # echo "${CHECKED[2]}"
                rm -r ~/test/${CHECKED[2]}
            fi
            if [[ -n ${CHECKED[1]} ]]; then
                # echo "${CHECKED[1]}"
                rm -r ~/test/${CHECKED[1]} 
            fi
            if [[ -n ${CHECKED[0]} ]]; then
                # echo "${CHECKED[0]}"
                rm -r ~/test/${CHECKED[0]} 
            fi
            shift # past argument
            find $HOME -empty -type d -delete
            ;;
        -h|--help)
            help
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            shift # past argument
            ;;
    esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters








