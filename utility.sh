#!/bin/bash
# Author: 33

function start {
# Check desktop manager type
# TODO:
# Support more Desktop managers.
# Currently supports cinnamon only
if [ "$XDG_CURRENT_DESKTOP" == "X-Cinnamon" ]; then
      #validating inputs
      case $1 in
       backup)
         if [ ! -d "$2" ]; then
          echo ""
          echo -e "Invalid directory path"
          echo -e "Please re-run the script with valid path"
          echo -e "Exiting script.."
          exit 3
         else 
          echo ""
          echo "### backup started ###"
          ./$XDG_CURRENT_DESKTOP.sh $1 $2
         fi
         ;;
       restore)
         if ! gzip -t "$2"; then
           echo ""
           echo -e "Invalid backup file"
           echo -e "Please re-run the script with valid backup file"
           echo -e "Exiting script.."
           exit 4
         else 
           echo ""
           echo "### Restoring ###"   
           ./$XDG_CURRENT_DESKTOP.sh $1 $2
         fi
         ;;
       esac  
else
    echo ""
    echo -e "Sorry! This utility is only for cinnamon Desktop"
    echo -e "You're using '$XDG_CURRENT_DESKTOP'"
    echo -e "Exiting script.."
    exit 1  
fi
exit 0
}


function dependencies {
    # check if gzip is installed

    if ! type -p "gzip" >/dev/null; then

			echo "################################################################"
			echo "   installing missing dependencies for this script to work"
			echo "#################################################################"

		  	sudo apt-get install -y gzip
            clear  
    fi
}

# Script starting point
####################################################################################

# Print help in case parameters are empty
if [ $# != 2 ] || [ "$1" != "backup" ] && [ "$1" != "restore" ]; then
   echo ""
   echo -e "Usage: $0 [command] path to backup [options]"
   echo ""
   echo -e "Commands:"
   echo -e "  backup         - Backup entire cinnamon desktop settings"
   echo -e "  restore        - Restore entire cinnamon desktop settings"
   echo -e "Options:"
   echo -e "  Path should be a directory to store the backup file if you are backuping"
   echo -e "  Path of the backup file if you are restoring"
   exit 2
else
   dependencies
   start $1 $2
fi
