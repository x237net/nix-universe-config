# modules/home/firefox/profiles.nix
# =================================
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
}: with lib; let
  cfg = config.universe.home.firefox.profiles;

  profiles = universe.apps.firefox.profiles.toList cfg
    |> imap0 (
      id: p: {
        ${p.name} = {
          inherit id;
          inherit (p.value) isDefault name;
        };
      }
    )
    |> mergeAttrsList;
in {
  options.universe.home.firefox.profiles = with types; mkOption {
    type = attrsOf (submodule {
      options = {
        isDefault = mkOption {
          type = bool;
          default = false;
          description = ''
            Whether this profile is the default one. This should be set to
            `true` for only one profile.
          '';
        };

        name = mkOption {
          type = str;
          default = "Profile";
          description = "The profile name.";
        };
      };
    });

    default = {
      default = {
        isDefault = true;
        name = "Default";
      };
    };
  };

  config = {
    programs.firefox = {
      inherit profiles;
    };
  };
}
