Using stow.
To deploy other dot files: stow NAME -t HOME

NOTE: For now the nixos config file is not stowed yet on my computer. Thus it
is just a copy of it and not updated very often, i.e. not symlinked yet.

Using flake for reproducibility:
Now we only need to modify configuration.nix file in this git instead of the
system wide config (/etc/nixos/configuration.nix).
