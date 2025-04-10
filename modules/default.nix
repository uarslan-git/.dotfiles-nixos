# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ 
	./audio
	./cronjobs
	./desktop
	./environmental
	./fonts
	./programs
	./virtualisation
    ];
}

