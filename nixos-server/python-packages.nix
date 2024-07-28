{ pkgs }:

pkgs.python311.withPackages (p: with p; [
  sympy
  pynvim
])
