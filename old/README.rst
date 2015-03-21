mozinstall
----------

* How to use::

   mozinstall.sh --install [package] [version] [language] [arch]
   mozinstall.sh --update-to [package] [version]
   mozinstall.sh --uninstall [package]
   mozinstall.sh --show-versions
   mozinstall.sh --show-languages [package] [version]
   mozinstall.sh --help
  
* Available packages::

   -firefox
   -thunderbird

* Available arch(s)::

   -linux-i686
   -linux-x86_64

* Examples of use::

   mozinstall.sh --install firefox 30.0 en-US linux-i686
   mozinstall.sh --update-to firefox 31.0
   mozinstall.sh --uninstall firefox
   mozinstall.sh --show-languages firefox 30.0
