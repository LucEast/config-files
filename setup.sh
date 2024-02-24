#!/bin/bash

# Setting colored output
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Add the directory where your config files are stored
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
CONFIG_DIR="$SCRIPT_DIR"
COMMON_DIR=$CONFIG_DIR/common

# Detect the operating system
OS=$(uname -s)

# Set the specific configuration directory based on the operating system
case $OS in
  Linux) OS_DIR=$CONFIG_DIR/Linux ;;
  Darwin) OS_DIR=$CONFIG_DIR/macOS ;; # Darwin indicates macOS
  *) echo -e "${RED}Unsupported operating system: $OS${NC}"; exit 1 ;;
esac

echo -e "${RED}"
echo -e " _________                _____.__         .____    .__        __                  "
echo -e " \_   ___ \  ____   _____/ ____\__| ____   |    |   |__| ____ |  | __ ___________  "
echo -e " /    \  \/ /  _ \ /    \   __\|  |/ ___\  |    |   |  |/    \|  |/ // __ \_  __ \ "
echo -e " \     \___(  <_> )   |  \  |  |  / /_/  > |    |___|  |   |  \    <\  ___/|  | \/ "
echo -e "  \______  /\____/|___|  /__|  |__\___  /  |_______ \__|___|  /__|_ \\___  >__|    "
echo -e "         \/            \/        /_____/           \/       \/     \/    \/        "
echo -e "${NC}"



help()
{
  ############################################################
  #                           Help                           #
  ############################################################
  # Display Help
  echo -e "${YELLOW}This script links the selected config files to their final location based on the operating system."
  echo -e
  echo -e "Syntax: ./$(basename $0) [-i|d|h]"
  echo -e "options:"
  echo -e "-i | --install    Installs selected configs using symbolic links."
  echo -e "-d | --delete     Deletes selected config symbolic links."
  echo -e "-h | --help       Print this Help.${NC}"
  echo -e 
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

OPTIONS_VALUES=(".zshrc" ".tmux.conf" ".vimrc" ".config/terminator/config" ".local/share/fonts/truetype/MesloLGS/*")
OPTIONS_LABELS=("zsh" "tmux" "vim" "terminator" "MesloLGS fonts")

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

link_directory_contents() {
    local source_dir=$1
    local target_dir=$2
    for entry in "$source_dir"/*; do
        local target_link="$target_dir/$(basename "$entry")"
        if [ ! -e "$target_link" ]; then
            ln -sfn "$entry" "$target_link"
            echo -e "${GREEN}Linked $(basename "$entry") to $target_dir${NC}"
        else
            echo -e "${YELLOW}Target $(basename "$entry") already exists, skipping.${NC}"
        fi
    done
}

delete_links() {
    local source_dir=$1
    local target_dir=$2
    for entry in "$source_dir"/*; do
        local target_link="$target_dir/$(basename "$entry")"
        if [ -L "$target_link" ]; then
            rm "$target_link"
            echo -e "${RED}Removed link for $(basename "$entry")${NC}"
        else
            echo -e "${YELLOW}No link for $(basename "$entry"), skipping.${NC}"
        fi
    done
}

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--install)
      echo -e "${YELLOW}Linking common configurations...${NC}"
      link_directory_contents "$COMMON_DIR" ~
      echo -e "${YELLOW}Linking $OS-specific configurations...${NC}"
      link_directory_contents "$OS_DIR" ~
      shift
      ;;
    -d|--delete)
      echo -e "${YELLOW}Removing common configuration links...${NC}"
      delete_links "$COMMON_DIR" ~
      echo -e "${YELLOW}Removing $OS-specific configuration links...${NC}"
      delete_links "$OS_DIR" ~
      shift
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








