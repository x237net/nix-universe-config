# modules/home/git/delta.nix
# ==========================
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
  cfg = config.${namespace}.home.git.delta;

  deltaOptions = {
    inherit (cfg) hyperlinks navigate;
    side-by-side = cfg.sideBySide;
  };

  deltaTheme =
    if cfg.theme == ""
    then {}
    else {syntax-theme = cfg.theme;};

  gitOptions = {
    diff = {
      algorithm = "histogram";
      submodule = "log";
    };
    merge.conflictStyle = "zdiff3";
  };
in {
  options.${namespace}.home.git.delta = with types; {
    enable = mkOption {
      description = "Whether to enable ${namespace}.home.git.delta";
      default = true;
      type = bool;
    };

    extraOptions = mkOption {
      description = "Additional configuration options for Delta.";
      default = {};
      example = {
        hyperlinks-commit-link-format = "https://repo.example.com/commit/{commit}";
      };
      type = attrs;
    };

    hyperlinks = mkOption {
      description = "Whether to render commit hashes, file names, and line numbers as hyperlinks.";
      default = false;
      type = bool;
    };

    navigate = mkOption {
      description = "Whether to enable navigating through the diff using 'n' and 'N' keys.";
      default = true;
      type = bool;
    };

    sideBySide = mkOption {
      description = "Whether to use side-by-side diffs.";
      default = false;
      type = bool;
    };

    theme = mkOption {
      description = "The syntax-highlighting theme to use.";
      default = "";
      type = nullOr str;
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      extraConfig = gitOptions;
      delta = {
        inherit (cfg) enable;
        options = deltaOptions // deltaTheme // cfg.extraOptions;
      };
    };
  };
}
