#!/bin/bash
 
# Script to install Firefox on GNU/Linux
# Created by q3aql (q3aql@openmailbox.org)
# Licensed by GPL v.2
# Last update: 01-03-2016
# --------------------------------------
VERSION="3.0.1"

# Check if 'user' is 'root'
user=$(whoami)
 if [ "$user" == "root" ] ; then
     echo "OK" > /dev/null
 else
     echo "You must be root!"
     exit 0
 fi

# Detect "kernel" name
KERNEL=$(uname -s)
 if   [ $KERNEL == "Linux" ]; then
       KERNEL="linux"
 else
       echo "Unsupported OS ($KERNEL)"
       exit 0
 fi

 # Create Mozilla Firefox shortcut after of install it.
 function create_firefox_icon(){

  cp -rf /opt/firefox/browser/chrome/icons/default/default16.png /usr/share/icons/hicolor/16x16/apps/firefox.png
  cp -rf /opt/firefox/browser/chrome/icons/default/default32.png /usr/share/icons/hicolor/32x32/apps/firefox.png
  cp -rf /opt/firefox/browser/chrome/icons/default/default48.png /usr/share/icons/hicolor/48x48/apps/firefox.png
  cp -rf /opt/firefox/browser/chrome/icons/default/default48.png /usr/share/icons/hicolor/64x64/apps/firefox.png
  chmod 644 /usr/share/icons/hicolor/16x16/apps/firefox.png
  chmod 644 /usr/share/icons/hicolor/32x32/apps/firefox.png
  chmod 644 /usr/share/icons/hicolor/48x48/apps/firefox.png
  chmod 644 /usr/share/icons/hicolor/64x64/apps/firefox.png
  echo "[Desktop Entry]" > /usr/share/applications/firefox.desktop
  #echo "Encoding=UTF-8" >> /usr/share/applications/firefox.desktop
  echo "Name=Mozilla Firefox" >> /usr/share/applications/firefox.desktop
  echo "Comment=Browse the World Wide Web" >> /usr/share/applications/firefox.desktop
  echo "GenericName=Web Browser" >> /usr/share/applications/firefox.desktop
  echo "X-GNOME-FullName=Mozilla Firefox" >> /usr/share/applications/firefox.desktop
  echo "Exec=firefox %u" >> /usr/share/applications/firefox.desktop
  echo "Terminal=false" >> /usr/share/applications/firefox.desktop
  echo "X-MultipleArgs=false" >> /usr/share/applications/firefox.desktop
  echo "Type=Application" >> /usr/share/applications/firefox.desktop
  echo "Icon=firefox" >> /usr/share/applications/firefox.desktop
  echo "Categories=Network;WebBrowser;" >> /usr/share/applications/firefox.desktop
  #echo "StartupWMClass=Firefox-bin" >> /usr/share/applications/firefox.desktop
  echo "StartupNotify=true" >> /usr/share/applications/firefox.desktop
  chmod 755 /usr/share/applications/firefox.desktop
  echo " <-Finished->"
  exit
 }

 # Install Firefox using 'tar' command and
 # initialize the 'create_firefox_icon' function.
 function install_firefox(){

   echo ""
   echo " <-Downloading Mozilla Firefox->"
   cd /tmp/
   $APP_DOWNLOAD $SERVER
   echo " <-Installing Mozilla Firefox->"
   tar jxvf $RELEASE.tar.bz2 -C /opt/
   rm -rf /usr/bin/firefox
   ln -s /opt/firefox/firefox /usr/bin/firefox
   chmod 755 -R /opt/firefox/
   rm -rf /tmp/$RELEASE.tar.bz2
   create_firefox_icon
 }

 # Define the complete URL of selected firefox package, show
 # the selected previous options to confirm and will initialize
 # the install ('install_firefox' function).
 function step5_install_firefox(){

 SERVER="https://download.mozilla.org/?product=$RELEASE&os=$ARCH&lang=$LANGUAGE"

 clear
 echo ""
 echo "firefox-install v$VERSION"
 echo "----------------------"
 echo ""
 echo "[Step 5/5] Check your selected installation:"
 echo ""
 echo "Install: Mozilla Firefox"
 echo "Package: $RELEASE"
 echo "Language: $LANGUAGE"
 echo "Arch: $ARCH_NAME"
 echo "Directory: /opt/firefox/"
 echo ""
 echo "Apps: $NAME_APP (download), tar (unpack) "
 echo ""
 echo -n "(default: y) Is correct? (y/n/q); " ; read VAREND

  if [ "${VAREND:-NO_VALUE}" == "NO_VALUE" -o "$VAREND" == "yes" -o "$VAREND" == "y" ] ; then
     install_firefox
  elif [ "$VAREND" == "no" -o "$VAREND" == "n" ] ; then
       step1_choose_version

  elif [ "$VAREND" == "q" -o "$VAREND" == "quit" ] ; then
       exit

  else
     clear
     echo ""
     echo "Invalid option, please, choose any available option"
     echo ""
     echo -n "Press 'ENTER' to return "
     read yesorno
     step5_install_firefox
  fi
 }

 # Check if 'wget', 'aria2c' & 'axel' are installed,
 # define the corresponding variable and initialize the
 # 'step4_choose_app_download' function.
 function check_downloaders_on_system() {

    wget --help > /dev/null
    if [ "$?" -eq 0 ] ; then
     WGET="Available"
    else
     WGET="Not available"
    fi

    aria2c --help > /dev/null
    if [ "$?" -eq 0 ] ; then
     ARIA2C="Available"
    else
     ARIA2C="Not available"
    fi

    axel --help > /dev/null
    if [ "$?" -eq 0 ] ; then
     AXEL="Available"
    else
     AXEL="Not available"
    fi
  step4_choose_app_download
}

# Check if exist a previous installation of firefox and
# allows overwrite it, uninstall it or exit to cancel.
# Initialize the 'step1_choose_version' function too.
function check_other_installs_on_system(){

	if [ -d /opt/firefox/ ]; then
	clear
	echo ""
	echo "Detected a previous installation of Firefox"
	echo "Do you want to overwrite or uninstall the current version?"
	echo ""
	echo "(1) - overwrite"
	echo "(2) - uninstall"
	echo "(3) - quit (q)"
	echo ""
	echo -n "(Default: overwrite) Choose an option; " ; read INST

	if [ "${INST:-NO_VALUE}" == "NO_VALUE" ] ; then
	   step1_choose_version

	elif [ "$INST" == "1" -o "$INST" == "overwrite" ] ; then
	   step1_choose_version

	elif [ "$INST" == "2" -o "$INST" == "uninstall" ] ; then

	     clear
	     echo ""
	     echo "Uninstalling Firefox, please wait..."
	     echo ""
	     sleep 5
	     rm -rf /usr/bin/firefox
	     rm -rf /usr/share/applications/firefox.desktop
	     rm -rf /opt/firefox/
	     echo "Done!"
	     echo ""
	     exit

	elif [ "$INST" == "3" -o "$INST" == "quit" -o "$INST" == "q" ]; then
	      exit

	else
          clear
          echo ""
          echo "Invalid option, please, choose any available option"
          echo ""
          echo -n "Press 'ENTER' to return "
          read notoption
          check_other_installs_on_system
       fi
      else
       step1_choose_version
    fi
}

 # Define the variable 'APP_DOWNLOAD' and
 # initialize the 'step5_install_firefox'
 # function.
 function step4_choose_app_download(){

   clear
   echo ""
   echo "firefox-install v$VERSION"
   echo "----------------------"
   echo ""
   echo "[ Step 4/5 (App to download) ]"
   echo ""
   echo "Available apps to download:"
   echo ""
   echo "(1) - wget ($WGET)"
   echo "(2) - aria2c ($ARIA2C)"
   echo "(3) - axel ($AXEL)"
   echo ""
   echo "(q) - quit"
   echo ""
   APP=0
   echo -n "(Default: wget) Choose an option; " ; read APP

   if [ "$APP" == "1" -o "$APP" == "wget" -o "${APP:-NO_VALUE}" == "NO_VALUE" ] ; then

     # Check if 'wget' is available using the variable
     # defined in 'check_downloaders_on_system' function.
     if [ "$WGET" == "Available" ]; then
         APP_DOWNLOAD="wget -O $RELEASE.tar.bz2 -c"
         NAME_APP="wget"
         step5_install_firefox
     else
     clear
     echo ""
     echo "'wget' is not available in your system"
     echo ""
     echo -n "Press 'ENTER' to return "
     read not
     step4_choose_app_download
     fi

   elif [ "$APP" == "2" -o "$APP" == "aria2c" ] ; then

     # Check if 'aria2c' is available using the variable
     # defined in 'check_downloaders_on_system' function.
     if [ "$ARIA2C" == "Available" ]; then
         APP_DOWNLOAD="aria2c --check-certificate=false -o $RELEASE.tar.bz2"
         NAME_APP="aria2c"
         step5_install_firefox
     else
     clear
     echo ""
     echo "'aria2c' is not available in your system"
     echo ""
     echo -n "Press 'ENTER' to return "
     read not
     step4_choose_app_download
     fi

   elif [ "$APP" == "3" -o "$APP" == "axel" ] ; then

     # Check if 'axel' is available using the variable
     # defined in 'check_downloaders_on_system' function.
     if [ "$AXEL" == "Available" ]; then
         APP_DOWNLOAD="axel -o $RELEASE.tar.bz2"
         NAME_APP="axel"
         step5_install_firefox
     else
     clear
     echo ""
     echo "'axel' is not available in your system"
     echo ""
     echo -n "Press 'ENTER' to return "
     read not
     step4_choose_app_download
     fi

   elif [ "$APP" == "q" -o "$APP" == "quit" ] ; then
         exit
   else
     clear
     echo ""
     echo "Invalid option, please, choose any available app"
     echo ""
     echo -n "Press 'ENTER' to return "
     read notapp
     step4_choose_app_download
  fi
}

 # Define the variable 'AR' and initialize
 # the 'check_downloaders_on_system' function.
 function step3_choose_arch(){

   clear
   echo ""
   echo "firefox-install v$VERSION"
   echo "----------------------"
   echo ""
   echo "[ Step 3/5 (Arch) ]"
   echo ""
   echo "Available Arch:"
   echo ""
   echo "(1) - 32 bits (linux)"
   echo "(2) - 64 bits (linux64)"
   echo ""
   echo "(q) - quit"
   echo ""
   echo -n "(Default: autodetect) Choose an option; " ; read AR

   if [ "${AR:-NO_VALUE}" == "NO_VALUE" ] ; then

      # Detect the arch of the system if variable
      # 'AR' is empty.
      archs=`uname -m`
      case "$archs" in
       i?86)
         ARCH="linux"
         ARCH_NAME="x86"
         check_downloaders_on_system
       ;;
       x86_64)
         ARCH="linux64"
         ARCH_NAME="x86_64"
         check_downloaders_on_system
      ;;
      *)
        echo "Unsupported Arquitecture ($archs)"
        exit 0
      esac

   elif [ "$AR" == "1" -o "$AR" == "32" ] ; then
   ARCH="linux"
   ARCH_NAME="x86"
   check_downloaders_on_system

   elif [ "$AR" == "2" -o "$AR" == "64" ] ; then
   ARCH="linux64"
   ARCH_NAME="x86_64"
   check_downloaders_on_system

   elif [ "$AR" == "q" -o "$AR" == "quit" ] ; then
         exit

   else
     clear
     echo ""
     echo "Invalid option, please, choose any available arch"
     echo ""
     echo -n "Press 'ENTER' to return "
     read notarch
     step3_choose_arch
   fi
}

 # Define the variable 'LANGUAGE' and initialize the
 # 'step3_choose_arch' funtion.
 function step2_choose_language(){

   FILE_LANGUAGES=/tmp/firefox-languages
   clear
   echo ""
   echo "firefox-install v$VERSION"
   echo "----------------------"
   echo ""
   echo "[ Step 2/5 (Language) ]"
   echo ""
   echo "Available languages:"
   echo ""
   echo "[ach] [af] [an] [ar] [as] [ast] [be]" > $FILE_LANGUAGES
   echo "[bg] [bn-BD] [bn-IN] [br] [bs] [ca]" >> $FILE_LANGUAGES
   echo "[cs] [csb] [cy] [da] [de] [el] [en-GB]" >> $FILE_LANGUAGES
   echo "[en-US] [en-ZA] [eo] [es-AR] [es-CL]" >> $FILE_LANGUAGES
   echo "[es-ES] [es-MX] [et] [eu] [fa] [ff] [fi]" >> $FILE_LANGUAGES
   echo "[fr] [fy-NL] [ga-IE] [gd] [gl] [gu-IN]" >> $FILE_LANGUAGES
   echo "[he] [hi-IN] [hr] [hu] [hy-AM] [id]" >> $FILE_LANGUAGES
   echo "[is] [it] [ja] [kk] [km] [kn] [ko] [ku]" >> $FILE_LANGUAGES
   echo "[lij] [lt] [lv] [mai] [mk] [ml] [mr]" >> $FILE_LANGUAGES
   echo "[ms] [nb-NO] [nl] [nn-NO] [or] [pa-IN]" >> $FILE_LANGUAGES
   echo "[pl] [pt-BR] [pt-PT] [rm] [ro] [ru]" >> $FILE_LANGUAGES
   echo "[si] [sk] [sl] [son] [sq] [sr] [sv-SE]" >> $FILE_LANGUAGES
   echo "[sw] [ta] [te] [th] [tr] [uk] [vi] [xh]" >> $FILE_LANGUAGES
   echo "[xpi] [zh-CN] [zh-TW] [zu]" >> $FILE_LANGUAGES
   cat $FILE_LANGUAGES
   echo ""
   echo -n "(Default: en-US) Type the language; " ; read LANG
   COUNT=1

   # Check if the variable 'LANG' is empty.
   if [ "${LANG:-NO_VALUE}" != "NO_VALUE" ] ; then

     # Check if the variable 'LANG' is valid.
     while [ $COUNT -le 10 ]; do

        LANGUAGE_VAR=`cat $FILE_LANGUAGES | grep $LANG | cut -d "[" -f $COUNT | cut -d "]" -f 1`

        if [ "$LANGUAGE_VAR" == "$LANG" ]; then

            LANGUAGE="$LANG"
            step3_choose_arch

        else

        COUNT=`expr $COUNT + 1`
        fi
     done

     clear
     echo ""
     echo "Language '$LANG' is not valid, please, type any available language"
     echo ""
     echo -n "Press 'ENTER' to return "
     read notlang
     step2_choose_language

   else
     LANGUAGE=en-US
     step3_choose_arch
   fi
}

 function step1_choose_version(){

   clear
   echo ""
   echo "firefox-install v$VERSION"
   echo "----------------------"
   echo ""
   echo "[ Step 1/5 (Version) ]"
   echo ""
   echo "Available Versions:"
   echo ""
   echo "(1) - firefox-esr-latest (ESR)"
   echo "(2) - firefox-latest (stable)"
   echo "(3) - firefox-beta-latest (beta)"
   echo ""
   echo "(q) - quit"
   echo ""
   echo -n "(Default: stable) Choose an option; " ; read VER

   if [ "$VER" == "1" -o "$VER" == "ESR" ] ; then
   RELEASE="firefox-esr-latest"
   step2_choose_language

   elif [ "$VER" == "2" -o "$VER" == "stable" ] ; then
   RELEASE="firefox-latest"
   step2_choose_language

   elif [ "$VER" == "3" -o "$VER" == "beta" ] ; then
   RELEASE="firefox-beta-latest"
   step2_choose_language

   elif [ "${VER:-NO_VALUE}" == "NO_VALUE" ] ; then
   RELEASE="firefox-latest"
   step2_choose_language

   elif [ "$VER" == "q" -o "$VER" == "quit" ] ; then
         exit

   else
     clear
     echo ""
     echo "Invalid option, please, choose any available version"
     echo ""
     echo -n "Press 'ENTER' to return "
     read notversion
     step1_choose_version
   fi
}

# Initialize the first step of the installation.
check_other_installs_on_system
