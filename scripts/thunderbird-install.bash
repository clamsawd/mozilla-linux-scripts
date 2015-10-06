#!/bin/bash
 
# Script to install Thunderbird on GNU/Linux
# Created by clamsawd (clamsawd@openmailbox.org)
# Version 2.0
# Licensed by GPL v.2
# Last update: 24-08-2015
# --------------------------------------
 
  function printf(){
  echo "$1" "$2"
  }

  function textprint(){
  echo "$1"
  }
 
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
       KERNEL=linux
 else
       echo "Unsupported OS ($KERNEL)"
       exit 0
 fi
 
 # Create Mozilla thunderbird shortcut after of install it.
 function create_thunderbird_icon(){
	 
  textprint "[Desktop Entry]" > /usr/share/applications/thunderbird.desktop
  #textprint "Encoding=UTF-8" >> /usr/share/applications/thunderbird.desktop
  textprint "Name=Mozilla Thunderbird" >> /usr/share/applications/thunderbird.desktop
  textprint "Comment=Mozilla Email Reader" >> /usr/share/applications/thunderbird.desktop
  textprint "GenericName=Email Reader" >> /usr/share/applications/thunderbird.desktop
  textprint "X-GNOME-FullName=Mozilla Thunderbird" >> /usr/share/applications/thunderbird.desktop
  textprint "Exec=thunderbird %u" >> /usr/share/applications/thunderbird.desktop
  textprint "Terminal=false" >> /usr/share/applications/thunderbird.desktop
  textprint "X-MultipleArgs=false" >> /usr/share/applications/thunderbird.desktop
  textprint "Type=Application" >> /usr/share/applications/thunderbird.desktop
  textprint "Icon=/opt/thunderbird/chrome/icons/default/default48.png" >> /usr/share/applications/thunderbird.desktop
  textprint "Categories=Network;WebBrowser;" >> /usr/share/applications/thunderbird.desktop
  #textprint "StartupWMClass=thunderbird-bin" >> /usr/share/applications/thunderbird.desktop
  textprint "StartupNotify=true" >> /usr/share/applications/thunderbird.desktop
  chmod 755 /usr/share/applications/thunderbird.desktop
  printf " <-Finished->"
  exit 
 }
 
 # Install thunderbird using 'tar' command and
 # initialize the 'create_THUNDERBIRD_icon' function.
 function install_thunderbird(){

   printf ""
   printf " <-Downloading Mozilla Thunderbird->"
   cd /tmp/
   if [ "$APP_DOWNLOAD" == "curl" ] ; then
     $APP_DOWNLOAD $SERVER > thunderbird-$VERSION
   else
     $APP_DOWNLOAD $SERVER
   fi
   printf " <-Installing Mozilla Thunderbird->"
   tar jxvf thunderbird-$VERSION -C /opt/
   rm -rf /usr/bin/thunderbird
   ln -s /opt/thunderbird/thunderbird /usr/bin/thunderbird
   chmod 755 -R /opt/thunderbird/
   rm -rf /tmp/thunderbird-$VERSION
   create_thunderbird_icon
 }
 
 # Define the complete URL of selected thunderbird package, show
 # the selected previous options to confirm and will initialize
 # the install ('install_thunderbird' function).
 function step5_install_thunderbird(){
 
 SERVER=http://archive.mozilla.org/pub/thunderbird/releases/$RELEASE/$ARCH/$LANGUAGE/thunderbird-$VERSION
 
 clear
 printf ""
 printf "[Step 5/5] Check your selected installation:"
 printf ""
 printf "Install: Mozilla Thunderbird"
 printf "Package: thunderbird-$VERSION"
 printf "Language: $LANGUAGE"
 printf "Arch: $ARCH"
 printf "Directory: /opt/thunderbird/"
 printf ""
 printf "Apps: $NAME_APP (download) , tar (unpack) "
 printf ""
 printf -n "(default: y) Is correct (y/n/q); " ; read VAREND
 
  if [ "${VAREND:-NO_VALUE}" == "NO_VALUE" -o "$VAREND" == "yes" -o "$VAREND" == "y" ] ; then
     install_thunderbird
  elif [ "$VAREND" == "no" -o "$VAREND" == "n" ] ; then
       get_list_versions
       
  elif [ "$VAREND" == "q" -o "$VAREND" == "quit" ] ; then
       exit
       
  else
     clear  
     printf ""
     printf "Invalid option, please, choose any available option"
     printf ""
     printf "Press 'ENTER' to return"
     read yesorno
     step5_install_thunderbird
  fi
 }

 # Check if 'wget', 'aria2c' & 'axel' are installed, 
 # define the corresponding variable and initialize the
 # 'step4_choose_app_download' function.
 function check_downloaders_on_system() {
	
    wget --help > /dev/null
    if [ "$?" -eq 0 ] ; then
     WGET=Available
    else
     WGET='Not available'
    fi
    
    aria2c --help > /dev/null
    if [ "$?" -eq 0 ] ; then
     ARIA2C=Available
    else
     ARIA2C='Not available'
    fi  

    axel --help > /dev/null
    if [ "$?" -eq 0 ] ; then
     AXEL=Available
    else
     AXEL='Not available'
    fi 
  step4_choose_app_download
}

# Check if exist a previous installation of thunderbird and
# allows overwrite it, uninstall it or exit to cancel.
# Initialize the 'step1_choose_version' function too.
function check_other_installs_on_system(){
	
	if [ -d /opt/thunderbird/ ]; then
	clear
	printf ""
	printf "Detected a previous installation of Thunderbird"
	printf "Do you want to overwrite or uninstall the current version?"
	printf ""
	printf "(1) - overwrite"
	printf "(2) - uninstall"
	printf "(3) - quit (q)"
	printf ""
	printf -n "(Default: overwrite) Choose an option; " ; read INST
	
	if [ "${INST:-NO_VALUE}" == "NO_VALUE" ] ; then
	   get_list_versions
	   
	elif [ "$INST" == "1" -o "$INST" == "overwrite" ] ; then
	   get_list_versions
	   
	elif [ "$INST" == "2" -o "$INST" == "uninstall" ] ; then
	
	     clear
	     printf ""
	     printf "Uninstalling thunderbird, please wait..."
	     printf ""
	     sleep 5
	     rm -rf /usr/bin/thunderbird
	     rm -rf /usr/share/applications/thunderbird.desktop
	     rm -rf /opt/thunderbird/
	     printf "Done!"
	     printf ""
	     exit
	     
	elif [ "$INST" == "3" -o "$INST" == "quit" -o "$INST" == "q" ]; then
	      exit
	
	else
          clear  
          printf ""
          printf "Invalid option, please, choose any available option"
          printf ""
          printf "Press 'ENTER' to return"
          read notoption
          check_other_installs_on_system
       fi
      else
       get_list_versions
    fi
}

 # Check if 'git' is installed and cancel the installation 
 # if it is not installed. Initialize the 'check_other_installs_on_system'
 # too.
 function check_curl_on_system(){
	 
    curl --help > /dev/null
    if [ "$?" -eq 0 ] ; then
     check_other_installs_on_system
    else
     clear
     printf ""
     printf "Error: Need 'curl' installed on your system!"
     printf ""
     exit
    fi
 }

 # Define the variable 'APP_DOWNLOAD' and
 # initialize the 'step5_install_thunderbird'
 # function.
 function step4_choose_app_download(){
   
   clear
   printf ""
   printf "[ Step 4/5 (App to download) ]"
   printf ""
   printf "Available apps to download:"
   printf ""
   printf "(1) - wget ($WGET)"
   printf "(2) - aria2c ($ARIA2C)"
   printf "(3) - axel ($AXEL)"
   printf "(4) - curl (Available)"
   printf ""
   printf "(q) - quit"
   printf ""
   APP=0
   printf -n "(Default: wget) Choose an option; " ; read APP
   
   if [ "$APP" == "1" -o "$APP" == "wget" ] ; then
   
     # Check if 'wget' is available using the variable
     # defined in 'check_downloaders_on_system' function.
     if [ "$WGET" == "Available" ]; then
         APP_DOWNLOAD='wget -c'
         NAME_APP='wget'
         step5_install_thunderbird
     else
     clear
     printf ""
     printf "'wget' is not available in your system"
     printf ""
     printf "Press 'ENTER' to return"
     read not
     step4_choose_app_download
     fi
   
   elif [ "$APP" == "2" -o "$APP" == "aria2c" ] ; then
   
     # Check if 'aria2c' is available using the variable
     # defined in 'check_downloaders_on_system' function.
     if [ "$ARIA2C" == "Available" ]; then
         APP_DOWNLOAD='aria2c --check-certificate=false'
         NAME_APP='aria2c'
         step5_install_thunderbird
     else
     clear
     printf ""
     printf "'aria2c' is not available in your system"
     printf ""
     printf "Press 'ENTER' to return"
     read not
     step4_choose_app_download
     fi
     
   elif [ "$APP" == "3" -o "$APP" == "axel" ] ; then
   
     # Check if 'axel' is available using the variable
     # defined in 'check_downloaders_on_system' function.
     if [ "$AXEL" == "Available" ]; then
         APP_DOWNLOAD='axel'
         NAME_APP='axel'
         step5_install_thunderbird
     else
     clear
     printf ""
     printf "'axel' is not available in your system"
     printf ""
     printf "Press 'ENTER' to return"
     read not
     step4_choose_app_download
     fi

   elif [ "$APP" == "4" -o "$APP" == "curl" ] ; then
   
         APP_DOWNLOAD='curl'
         NAME_APP='curl'
         step5_install_thunderbird
     
   elif [ "$APP" == "q" -o "$APP" == "quit" ] ; then
         exit
   
   elif [ "${APP:-NO_VALUE}" == "NO_VALUE" ] ; then
     if [ "$WGET" == "Available" ]; then
         APP_DOWNLOAD='wget -c'
         NAME_APP='wget'
         step5_install_thunderbird
     else
     clear
     printf ""
     printf "'wget' is not available in your system"
     printf ""
     printf "Press 'ENTER' to return"
     read not
     step4_choose_app_download
     fi

   else
     clear  
     printf ""
     printf "Invalid option, please, choose any available app"
     printf ""
     printf "Press 'ENTER' to return"
     read notapp
     step4_choose_app_download
  fi
}

 # Define the variable 'AR' and initialize
 # the 'check_downloaders_on_system' function.
 function step3_choose_arch(){
   
   clear
   printf ""
   printf "[ Step 3/5 (Arch) ]"
   printf ""
   printf "Available Arch:"
   printf ""
   printf "(1) - 32 bits (linux-i686)"
   printf "(2) - 64 bits (linux-x86_64)"
   printf ""
   printf "(q) - quit"
   printf ""
   printf -n "(Default: autodetect) Choose an option; " ; read AR
   
   if [ "${AR:-NO_VALUE}" == "NO_VALUE" ] ; then
       
      # Detect the arch of the system if variable
      # 'AR' is empty.
      archs=`uname -m`
      case "$archs" in
       i?86)
         ARCH=linux-i686
         check_downloaders_on_system
       ;;
       x86_64)
         ARCH=linux-x86_64
         check_downloaders_on_system
      ;;
      *)
        echo "Unsupported Arquitecture ($archs)"
        exit 0
      esac
      
   elif [ "$AR" == "1" -o "$AR" == "32" ] ; then
   ARCH=linux-i686
   check_downloaders_on_system
   
   elif [ "$AR" == "2" -o "$AR" == "64" ] ; then
   ARCH=linux-x86_64
   check_downloaders_on_system
   
   elif [ "$AR" == "q" -o "$AR" == "quit" ] ; then
         exit
   
   else
     clear  
     printf ""
     printf "Invalid option, please, choose any available arch"
     printf ""
     printf "Press 'ENTER' to return"
     read notarch
     step3_choose_arch
   fi
}
 
 # Define the variable 'LANGUAGE' and initialize the
 # 'step3_choose_arch' funtion.
 function step2_choose_language(){
  
   FILE_LANGUAGES=/tmp/thunderbird-languages
   clear
   printf ""
   printf "[ Step 2/5 (Language) ]"
   printf ""
   printf "Available languages:"
   printf ""
   printf "[ach] [af] [an] [ar] [as] [ast] [be]" > $FILE_LANGUAGES
   printf "[bg] [bn-BD] [bn-IN] [br] [bs] [ca]" >> $FILE_LANGUAGES
   printf "[cs] [csb] [cy] [da] [de] [el] [en-GB]" >> $FILE_LANGUAGES
   printf "[en-US] [en-ZA] [eo] [es-AR] [es-CL]" >> $FILE_LANGUAGES
   printf "[es-ES] [es-MX] [et] [eu] [fa] [ff] [fi]" >> $FILE_LANGUAGES
   printf "[fr] [fy-NL] [ga-IE] [gd] [gl] [gu-IN]" >> $FILE_LANGUAGES
   printf "[he] [hi-IN] [hr] [hu] [hy-AM] [id]" >> $FILE_LANGUAGES
   printf "[is] [it] [ja] [kk] [km] [kn] [ko] [ku]" >> $FILE_LANGUAGES
   printf "[lij] [lt] [lv] [mai] [mk] [ml] [mr]" >> $FILE_LANGUAGES
   printf "[ms] [nb-NO] [nl] [nn-NO] [or] [pa-IN]" >> $FILE_LANGUAGES
   printf "[pl] [pt-BR] [pt-PT] [rm] [ro] [ru]" >> $FILE_LANGUAGES
   printf "[si] [sk] [sl] [son] [sq] [sr] [sv-SE]" >> $FILE_LANGUAGES
   printf "[sw] [ta] [te] [th] [tr] [uk] [vi] [xh]" >> $FILE_LANGUAGES
   printf "[xpi] [zh-CN] [zh-TW] [zu]" >> $FILE_LANGUAGES
   cat $FILE_LANGUAGES
   printf ""
   printf -n "(Default: en-US) Type the language; " ; read LANG
   COUNT=1
   
   # Check if the variable 'LANG' is empty.
   if [ "${LANG:-NO_VALUE}" != "NO_VALUE" ] ; then
   
     # Check if the variable 'LANG' is valid.
     while [ $COUNT -le 10 ]; do
   
        LANGUAGE_VAR=`cat $FILE_LANGUAGES | grep $LANG | cut -d "[" -f $COUNT | cut -d "]" -f 1`
    
        if [ "$LANGUAGE_VAR" == "$LANG" ]; then
     
            LANGUAGE=$LANG
            step3_choose_arch
       
        else  
   
        COUNT=`expr $COUNT + 1`
        fi
     done
   
     clear  
     printf ""
     printf "Language '$LANG' is not valid, please, type any available language"
     printf ""
     printf "Press 'ENTER' to return"
     read notlang
     step2_choose_language
     
   else
     LANGUAGE=en-US
     step3_choose_arch
   fi
}

 # Get the list of available thunderbird versions using 'curl',
 # and initialize the 'step2_choose_language' function.
 
 function get_list_versions() {
 
   clear 
   printf ""
   printf "Getting information of available versions, please wait.."
   printf ""
   TMP_FILE_STABLE=/tmp/moz_versions_st
   TMP_FILE_BETA=/tmp/moz_versions_bt
   TMP_FILE_ESR=/tmp/moz_versions_esr
   HTTP_THUNDERBIRD=http://archive.mozilla.org/pub/thunderbird/releases
      curl "$HTTP_THUNDERBIRD/latest/linux-x86_64/en-US/" | grep "tar.bz2" | cut -d "-" -f 3 | cut -d "<" -f 1 > $TMP_FILE_STABLE
      curl "$HTTP_THUNDERBIRD/latest-beta/linux-x86_64/en-US/" | grep "tar.bz2" | cut -d "-" -f 3 | cut -d "<" -f 1 > $TMP_FILE_BETA
      curl "$HTTP_THUNDERBIRD/latest-esr/linux-x86_64/en-US/" | grep "tar.bz2" | cut -d "-" -f 3 | cut -d "<" -f 1 > $TMP_FILE_ESR
       error=$?
       if [ $? -eq 0 ] ; then
         printf "OK" > /dev/null
         step1_choose_version
       else
         clear
         printf ""
         printf "Error: Failed to obtain the required information from the server!"
         printf "Connection Fail!"
         printf ""
         exit
       fi
 }
 
 function step1_choose_version(){
	  
   THUNDERBIRD_STABLE=`cat $TMP_FILE_STABLE`
   THUNDERBIRD_BETA=`cat $TMP_FILE_BETA`
   THUNDERBIRD_ESR=`cat $TMP_FILE_ESR`
   DEFAULT=`cat $TMP_FILE_STABLE`
	  
   clear
   printf ""
   printf "[ Step 1/5 (Version) ]"
   printf ""
   printf "Available Versions:"
   printf ""
   printf "(1) - thunderbird-$THUNDERBIRD_ESR (ESR)"
   printf "(2) - thunderbird-$THUNDERBIRD_STABLE (stable)"
   printf "(3) - thunderbird-$THUNDERBIRD_BETA (beta)"
   printf ""
   printf "(q) - quit"
   printf ""
   printf -n "(Default: thunderbird-$DEFAULT) Choose an option; " ; read VER
   
   if [ "$VER" == "1" -o "$VER" == "ESR" ] ; then
   VERSION=$THUNDERBIRD_ESR
   RELEASE="latest-esr"
   step2_choose_language
   
   elif [ "$VER" == "2" -o "$VER" == "stable" ] ; then
   VERSION=$THUNDERBIRD_STABLE
   RELEASE="latest"
   step2_choose_language
   
   elif [ "$VER" == "3" -o "$VER" == "beta" ] ; then
   VERSION=$THUNDERBIRD_BETA
   RELEASE="latest-beta"
   step2_choose_language
   
   elif [ "${VER:-NO_VALUE}" == "NO_VALUE" ] ; then
   VERSION=$DEFAULT
   RELEASE="latest"
   step2_choose_language
   
   elif [ "$VER" == "q" -o "$VER" == "quit" ] ; then
         exit
   
   else
     clear  
     printf ""
     printf "Invalid option, please, choose any available version"
     printf ""
     printf "Press 'ENTER' to return"
     read notversion
     step1_choose_version
   fi
}

# Initialize the first step of the installation.
check_curl_on_system
