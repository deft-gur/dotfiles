Using stow.

To deploy the nixos.configuration file: stow nixos -t /etc/
To deploy other dot files: stow NAME -t HOME

TODO:
Some of the application haven't been set up for stow to use. For ex mpd.
Just create a '.config/' directory and move all files inside it.
