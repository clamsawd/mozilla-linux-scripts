#!/bin/sh

# Script to install Mozilla Apps on GNU/Linux
# Created by Quique (quuiqueee@gmail.com)
# Licensed by GPL v.2
# Last update: 27-07-2014
# --------------------------------------
VERSION=1.0
alias printf='echo'

TEMP_FILE=/tmp/mozilla
TEMP_DIR=/tmp

case $1 in

  -install|--install)
     user=$(whoami)
     if [ "$user" = "root" ] 
       then
        printf "You are root"
     else
        printf "You must be root to install" 
        exit
     fi
     
     if [ "$2" = "firefox" ]
       then
        printf "Selected package -> firefox"
     elif [ "$2" = "thunderbird" ]
       then
        printf "Selected package -> thunderbird"
     else
        printf "Invalid syntax"
        exit
     fi
     
     if [ -f /opt/$2/$2-conf.sh ]
       then
          printf ""
          printf "Exist another installation of $2"
          printf "Use $0 --update-to $2 [version]"
          printf ""
          exit
     fi
     
     printf "Selected version -> $3"
     printf "Selected language -> $4"
     
     if [ "$5" = "linux-i686" ]
       then
        printf "Selected arch -> linux-i686"
     elif [ "$5" = "linux-x86_64" ]
       then
        printf "Selected arch -> linux-x86_64"
     else
        printf "Invalid syntax"
        exit
     fi
     
    SERVER=ftp://ftp.mozilla.org/pub/$2/releases
    URL=$SERVER/$3/$5/$4/$2-$3.tar.bz2
    cd $TEMP_DIR
    
    if wget -c $URL
      then
       printf "Package -> $TEMP_DIR/$2-$3.tar.bz2"
    else
       printf "Unable to download the package"
       exit
    fi
    
    if tar jxvf $TEMP_DIR/$2-$3.tar.bz2 -C /opt/
      then
       printf "Installed successfully -> /opt/$2"
       rm -rf $TEMP_DIR/$2-$3.tar.bz2
    else
       printf "Unable to install"
       exit
    fi
    
    rm -rf /usr/bin/$2
    ln -s /opt/$2/$2 /usr/bin/$2
    chmod 755 -R /opt/$2/
    printf "[Desktop Entry]" > /usr/share/applications/$2.desktop
    printf "Name=Mozilla $2" >> /usr/share/applications/$2.desktop
    printf "Comment=Browse the World Wide Web" >> /usr/share/applications/$2.desktop
    printf "GenericName=Web Browser" >> /usr/share/applications/$2.desktop
    printf "X-GNOME-FullName=Mozilla $2" >> /usr/share/applications/$2.desktop
    printf "Exec=$2 %u" >> /usr/share/applications/$2.desktop
    printf "Terminal=false" >> /usr/share/applications/$2.desktop
    printf "X-MultipleArgs=false" >> /usr/share/applications/$2.desktop
    printf "Type=Application" >> /usr/share/applications/$2.desktop
    if [ "$2" = "firefox" ]
     then
    printf "Icon=/opt/$2/browser/icons/mozicon128.png" >> /usr/share/applications/$2.desktop
    elif [ "$2" = "thunderbird" ]
     then
    printf "Icon=/opt/$2/chrome/icons/default/default48.png" >> /usr/share/applications/$2.desktop
    fi
    printf "Categories=Network;WebBrowser;" >> /usr/share/applications/$2.desktop
    printf "StartupNotify=true" >> /usr/share/applications/$2.desktop
    chmod 755 /usr/share/applications/$2.desktop
    printf "ARCH=$5" > /opt/$2/$2-conf.sh
    printf "LANG=$4" >> /opt/$2/$2-conf.sh
   ;;
  -update-to|--update-to)
     user=$(whoami)
     if [ "$user" = "root" ] 
       then
        printf "You are root"
     else
        printf "You must be root to update" 
        exit
     fi
     
     if [ "$2" = "firefox" ]
       then
        printf "Selected package -> firefox"
     elif [ "$2" = "thunderbird" ]
       then
        printf "Selected package -> thunderbird"
     else
        printf "Invalid syntax"
        exit
     fi
     
     if [ -f /opt/$2/$2-conf.sh ]
       then
        . /opt/$2/$2-conf.sh
     else
        printf ""
        printf "Not exist another installation of $2"
        printf "Use $0 --install $2 [version] [language] [arch]"
        printf ""
        exit
     fi
     
    SERVER=ftp://ftp.mozilla.org/pub/$2/releases
    URL=$SERVER/$3/$ARCH/$LANG/$2-$3.tar.bz2
    cd $TEMP_DIR
    
    if wget -c $URL
      then
       printf "Package -> $TEMP_DIR/$2-$3.tar.bz2"
    else
       printf "Unable to download the package"
       exit
    fi
    
    if tar jxvf $TEMP_DIR/$2-$3.tar.bz2 -C /opt/
      then
       printf "Installed successfully -> /opt/$2"
       rm -rf $TEMP_DIR/$2-$3.tar.bz2
    else
       printf "Unable to update"
       exit
    fi
  ;;
  -uninstall|--uninstall)
     user=$(whoami)
     if [ "$user" = "root" ] 
       then
        printf "You are root"
     else
        printf "You must be root to uninstall" 
        exit
     fi
     rm -rf /usr/bin/$2
     rm -rf /usr/share/applications/$2.desktop
     rm -rf /opt/$2/
     printf "Unistalled successfully"
  ;;
  -show-versions|--show-versions)
     if curl -h > /dev/null
       then
        printf "curl OK"
     else
        clear
        printf ""
        printf "'curl' is not installed!"
        printf ""
        exit
     fi
        printf "" > $TEMP_FILE
        printf "# Mozilla Firefox" >> $TEMP_FILE
        printf "" >> $TEMP_FILE
        curl ftp://ftp.mozilla.org/pub/firefox/releases/ | grep latest >> $TEMP_FILE
        printf "" >> $TEMP_FILE
        printf "# Mozilla Thunderbird" >> $TEMP_FILE
        printf "" >> $TEMP_FILE
        curl ftp://ftp.mozilla.org/pub/thunderbird/releases/ | grep latest >> $TEMP_FILE
        printf "" >> $TEMP_FILE
        cat $TEMP_FILE
        rm -rf $TEMP_FILE
  ;;
  -show-languages|--show-languages)
    if curl -h > /dev/null
       then
        printf "curl OK"
     else
        clear
        printf ""
        printf "'curl' is not installed!"
        printf ""
        exit
     fi
     
     if [ "$2" = "firefox" ]
       then
        printf "Selected package -> firefox"
     elif [ "$2" = "thunderbird" ]
       then
        printf "Selected package -> thunderbird"
     else
        printf "Invalid syntax"
        exit
     fi
     
    SERVER=ftp://ftp.mozilla.org/pub/$2/releases
    URL=$SERVER/$3/linux-i686/
    curl $URL    
  ;;
  -h|--h|-help|--help)
    printf ""
    printf "mozinstall $VERSION"
    printf "--------------"
    printf ""
    printf "USAGE:"
    printf ""
    printf "$0 --install [package] [version] [language] [arch]"
    printf "$0 --update-to [package] [version]"
    printf "$0 --uninstall [package]"
    printf "$0 --show-versions"
    printf "$0 --show-languages [package] [version]"
    printf "$0 --help"
    printf ""
    printf "AVAILABLE PACKAGES:"
    printf ""
    printf "firefox"
    printf "thunderbird"
    printf ""
    printf "AVAILABLE ARCH(S):"
    printf ""
    printf "linux-i686"
    printf "linux-x86_64"
    printf ""
    printf "EXAMPLES OF USE:"
    printf ""
    printf "$0 --install firefox 30.0 en-US linux-i686"
    printf "$0 --update-to firefox 31.0"
    printf "$0 --uninstall firefox"
    printf "$0 --show-languages firefox 30.0"
    printf ""
  ;;
  *)
    printf ""
    printf "$0: invalid option $1"
    printf ""
    printf "See $0 --help"
    printf ""
  esac

