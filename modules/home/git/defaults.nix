# modules/home/git/defaults.nix
# =============================
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
  cfg = config.${namespace}.home.git.defaults;

  gitOptions = {
    commit.verbose = true;
    init.defaultBranch = "main";
    merge.ff = false;
    pull.rebase = true;
    push = {
      default = "simple";
      followTags = true;
    };
    rebase.autoSquash = true;
    rerere.enabled = true;
    status.submoduleSummary = true;
  };
in {
  options.${namespace}.home.git.defaults = with types; {
    enable = mkOption {
      description = "Whether to enable ${namespace}.home.git.defaults";
      default = true;
      type = bool;
    };
  };

  config = mkIf cfg.enable {
    programs.git.extraConfig = gitOptions;
  };
}
