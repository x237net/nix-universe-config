# modules/darwin/nix/default.nix
# ==============================
#
# Copying
# -------
#
# Copyright (c) 2025 universe/config authors and contributors.
#
# This file is part of the *universe/config* project.
#
# *universe/config* is a free software project. You can redistribute it
# and/or modify it following the terms of the MIT License.
#
# This software project is distributed *as is*, WITHOUT WARRANTY OF ANY KIND;
# including but not limited to the WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE and NONINFRINGEMENT.
#
# You should have received a copy of the MIT License along with
# *universe/config*. If not, see <http://opensource.org/licenses/MIT>.
#
{
  # Flake's library as well as the libraries available from the flake's
  # inputs.
  lib,
  # An instance of input packages mixed with the flake's overlays and packages.
  pkgs,
  # Flake's inputs.
  inputs,
  # The namespace of the flake. See `snowfall.namespace`.
  namespace,
  # The system architecture for the system (eg. `x86_64-linux`).
  system,
  # The Snowfall Lib target for the system (eg. `x86_64-iso`).
  target,
  # A normalized name for the system target (eg. `iso`).
  format,
  # A boolean to determine whether this system is a virtual target using
  # nixos-generators.
  virtual,
  # An attribute map of other defined systems.
  systems,
  # Options coming from user of the module.
  config,
  ...
}:
with lib; let
  cfg = config.universe.darwin.nix;

  brewsDefault = [
    "mas"
  ];

  registry = {
    universe = {
      from = {
        type = "indirect";
        id = "universe";
      };
      to = {
        type = "github";
        owner = "x237net";
        repo = "nix-universe-config";
      };
    };
  };
in {
  options.universe.darwin.nix = with types; {
    enable = mkEnableOption "Enable the default Nix configuration for macOS.";

    allowedUsers = mkOption {
      description = ''
        A list of names of users that are allowed to connect to the Nix daemon.
        You can specify groups by prefixing them with `@`.
      '';
      default = [
        "@admin"
        "@nix"
      ];
      type = listOf string;
    };

    trustedUsers = mkOption {
      description = ''
        A list of names of users that have additional rights when connecting to
        the Nix daemon, such as the ability to specify additional binary caches,
        or to import unsigned NARs. You can also specify groups by prefixing
        them with `@`.
      '';
      default = [
        "@admin"
      ];
      type = listOf string;
    };

    homebrew = {
      enable = mkEnableOption "Allow Nix to manage Homebrew.";
      autoUpgrade = mkEnableOption "Automatically upgrade Homebrew packages.";
      autoUninstall = mkEnableOption "Automatically uninstall Homebrew packages.";
    };

    service = {
      enable = mkOption {
        description = ''
          Enable the Nix daemon to perform store operations on behalf of
          non-root clients.
        '';
        default = true;
        type = bool;
      };
    };

    store = {
      optimise = mkEnableOption "Automatically clean and optimise the Nix store.";
    };
  };

  config = mkIf cfg.enable {
    nix = {
      inherit registry;

      gc.automatic = cfg.store.optimise;
      optimise.automatic = cfg.store.optimise;

      settings = {
        allowed-users = cfg.allowedUsers;
        trusted-users = cfg.trustedUsers;
      };
    };
    services.nix-daemon.enable = cfg.service.enable;

    homebrew = mkIf cfg.homebrew.enable {
      inherit (cfg.homebrew) enable;

      global.autoUpdate = !cfg.homebrew.autoUpgrade;

      onActivation = mkIf (cfg.homebrew.autoUpgrade || cfg.homebrew.autoUninstall) {
        autoUpdate = cfg.homebrew.autoUpgrade;
        upgrade = cfg.homebrew.autoUpgrade;
        cleanup =
          if cfg.homebrew.autoUninstall
          then "zap"
          else "none";
      };

      brews = brewsDefault;
    };
  };
}
