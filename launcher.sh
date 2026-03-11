#!/bin/bash

# Normal ANSI colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
MAGENTA="\e[35m"
CYAN="\e[36m"

# Bright ANSI colors
BRIGHT_RED="\e[91m"
BRIGHT_GREEN="\e[92m"
BRIGHT_YELLOW="\e[93m"
BRIGHT_BLUE="\e[94m"
BRIGHT_MAGENTA="\e[95m"
BRIGHT_CYAN="\e[96m"
BRIGHT_BLACK="\e[90m"          # added missing definition

RESET="\e[0m"

# Color array (includes BRIGHT_BLACK now)
colors=(
    "$RED" "$GREEN" "$CYAN" "$MAGENTA"
    "$BRIGHT_RED" "$BRIGHT_GREEN" "$BRIGHT_YELLOW" "$BRIGHT_BLUE"
    "$BRIGHT_MAGENTA" "$BRIGHT_CYAN" "$BRIGHT_BLACK"
)

# Use glob to list files in /usr/local/sbin (more robust than parsing ls)
script_files=(/usr/local/sbin/*)

# Extract only filenames (strip path) and ignore directories
scripts=()
for file in "${script_files[@]}"; do
    if [[ -f "$file" ]]; then          # only regular files
        scripts+=("${file##*/}")
    fi
done

# Check if the directory contains any files
if [ ${#scripts[@]} -eq 0 ]; then
    echo "No scripts found in /usr/local/sbin."
    exit 1
fi

# Banner Start
echo -e "

${RED}████████╗██████╗ ██╗██████╗ ██╗     ███████╗    ██╗  ██╗${RESET}
${BRIGHT_RED}╚══██╔══╝██╔══██╗██║██╔══██╗██║     ██╔════╝    ██║  ██║${RESET}
${BRIGHT_GREEN}   ██║   ██████╔╝██║██████╔╝██║     █████╗      ███████║${RESET}
${BRIGHT_BLUE}   ██║   ██╔══██╗██║██╔═══╝ ██║     ██╔══╝      ██╔══██║${RESET}
${CYAN}   ██║   ██║  ██║██║██║     ███████╗███████╗    ██║  ██║${RESET}
${BRIGHT_CYAN}   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚══════╝╚══════╝    ╚═╝  ╚═╝${RESET}
                                                  
${BRIGHT_CYAN}        ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗   ${RESET} 
${CYAN}        ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝   ${RESET} 
${BRIGHT_BLUE}        ███████╗██║     ██████╔╝██║██████╔╝   ██║      ${RESET} 
${BRIGHT_GREEN}        ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║      ${RESET} 
${BRIGHT_RED}        ███████║╚██████╗██║  ██║██║██║        ██║      ${RESET} 
${RED}        ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝ ${RESET}
        "
# Banner End

echo "Available scripts in /usr/local/sbin:"

# Print scripts with rotating colors
for i in "${!scripts[@]}"; do
    color_index=$(( i % ${#colors[@]} ))
    echo -e "${colors[$color_index]}█ $((i+1)). ${scripts[$i]}${RESET}"
done

# Add Exit option at the bottom
echo -e "${BRIGHT_BLACK}█ 0. Exit${RESET}"
echo

read -p "Enter the number of the script you want to execute (or 0 to exit): " choice

# Validate input
if [[ "$choice" -eq 0 ]]; then
    echo -e "${BRIGHT_GREEN}Exiting.${RESET}"
    exit 0
elif [[ "$choice" -ge 1 && "$choice" -le "${#scripts[@]}" ]]; then
    script_name="${scripts[$((choice-1))]}"
    echo -e "${BRIGHT_GREEN}Executing >>> 🚀 $script_name${RESET}"
    sudo /usr/local/sbin/"$script_name"
else
    echo -e "${BRIGHT_RED}Invalid choice. Pick a valid number.${RESET}"
    exit 1
fi