#!/bin/bash
# Author: 33
# Backup function
function backup {
     Varbasebackupdir="$TEMP"/"cinnamon-desktop-backup-$(date '+%Y-%m-%d-%H-%M')"
     source $XDG_CURRENT_DESKTOP.config
     mkdir -p $Varbasebackupdir $Varcinbkpdir $Varcinconfigbkpdir $Varcinpicbkpdir $Varcinfontsbkpdir $Varciniconsbkpdir $Varcinthemesbkpdir
     touch $CONFIG
     start_spinner 'Desktop settings backup'
     dconf dump / > $CINCONFIG && stop_spinner $?
     Varwallpaper=$(grep "picture-uri=" $CINCONFIG | cut -d'/' -f3-)
     Varwallpaper=${Varwallpaper::-1}
     start_spinner 'Wallpaper backup'
     cp $Varwallpaper $Varcinpicbkpdir && stop_spinner $?
     echo "Varwallpaper=$(basename $Varwallpaper)" | tee --append $CONFIG >/dev/null
     start_spinner 'Cinnamon applets and desklets backup'
     rsync -a $Varcindir* $Varcinbkpdir && stop_spinner $?
     start_spinner 'Cinnamon configs backup'
     rsync -a $Varcinconfigdir* $Varcinconfigbkpdir && stop_spinner $?
     start_spinner 'Fonts backup'
     rsync -a $Varcinfontsdir* $Varcinfontsbkpdir && stop_spinner $?
     start_spinner 'Icons backup'
     rsync -a $Varciniconsdir* $Varciniconsbkpdir
     rsync -a --exclude-from=$SYSICONS $Varrooticonsdir* $Varciniconsbkpdir && stop_spinner $?
     start_spinner 'Themes backup'
     rsync -a $Varcinthemesdir* $Varcinthemesbkpdir
     rsync -a --exclude-from=$SYSTHEMES $Varrootthemesdir* $Varcinthemesbkpdir
     cd $TEMP
     tar -zcf $Varbasebackupdir".tar.gz" *
     mv $Varbasebackupdir".tar.gz" $Varbasedir
     rm -rf $TEMP && stop_spinner $?
     echo -e "Backup complete.."
     exit 0
}

# Restore function
function restore { 
     tar -xzf "$1" -C $TEMP
     Varbasebackupdir=$TEMP/$(basename "$1" | cut -d. -f1) 
     source $XDG_CURRENT_DESKTOP.config
     source $CONFIG   
     mkdir -p $Varcindir $Varcinfontsdir $Varciniconsdir $Varcinthemesdir $Varcinconfigdir
     start_spinner 'Restoring applets and desklets'
     rsync -a $Varcinbkpdir* $Varcindir && stop_spinner $?
     start_spinner 'Restoring fonts'
     rsync -a $Varcinfontsbkpdir* $Varcinfontsdir && stop_spinner $?
     start_spinner 'Restoring icons'
     rsync -a $Varciniconsbkpdir* $Varciniconsdir && stop_spinner $?
     start_spinner 'Restoring themes'
     rsync -a $Varcinthemesbkpdir* $Varcinthemesdir && stop_spinner $?
     start_spinner 'Restoring cinnamon configs'
     rsync -a $Varcinconfigbkpdir* $Varcinconfigdir && stop_spinner $?
     start_spinner 'Restoring desktop setings'
     dconf load / < $CINCONFIG && stop_spinner $?
     start_spinner 'Restoring wallpaper'
     cp $Varcinpicbkpdir$Varwallpaper $Varcinpicdir
     gsettings set org.cinnamon.desktop.background picture-uri "file://$Varcinpicdir$Varwallpaper" && stop_spinner $?
     echo -e "Restore successful.."
     echo -e "Reload cinnamon using Ctrl + Alt + Esc if you're having any issues."
     rm -rf $TEMP
     exit 0
}

# Script starting point
source "$(pwd)/spinner.sh"
TEMP=/tmp/cinnamon-desktop-backup
mkdir -p $TEMP
$1 $2