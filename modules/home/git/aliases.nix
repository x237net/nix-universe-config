# modules/home/git/aliases.nix
# ============================
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
  cfg = config.universe.home.git.aliases;

  defaultAliases = {
    alias = "config --get-regexp '^alias\.'";
    br = "branch --format='${gitFormat.branch}'";
    branch = "branch --format='${gitFormat.branch}'";
    c = "commit";
    cm = "commit --message";
    cms = "commit --message --signoff";
    co = "checkout";
    cs = "commit --signoff";
    dc = "diff --cached";
    del = "branch --delete";
    df = "diff";
    down = "pull";
    lg = "log --graph --all --abbrev-commit --decorate --format=tformat:'${gitFormat.log.oneline}'";
    ll = "log --all --abbrev-commit --decorate --stat --format=tformat:'${gitFormat.log.detailed}'";
    ls = "log --all --abbrev-commit --decorate --format=tformat:'${gitFormat.log.oneline}'";
    new = "switch --create";
    oops = "commit --amend";
    ss = "status --branch --short";
    st = "status";
    sw = "switch";
    tag = "tag --format='${gitFormat.tag.oneline}'";
    tags = "tag --list --format='${gitFormat.tag.detailed}'";
    up = "push --set-upstream";
    update = "rebase --autosquash --interactive";
  };

  gitFormat = {
    branch = "%(color:bold magenta)%(HEAD)%(color:reset) %(color:bold green)%(refname:short)%(color:reset)  %(contents:subject) %(color:green)%(committerdate:relative) %(color:blue)[%(authorname)]%(color:reset)";
    log = rec {
      detailed = "%n${oneline}";
      oneline = "%C(yellow)%h%C(reset) %C(magenta)%ar%C(reset) %s %C(blue)[%cn]%C(reset)%C(bold green)%d%C(reset)";
    };
    tag = {
      detailed = "%(color:bold magenta)%(HEAD)%(color:reset) %(color:bold green)%(refname:short)%(color:reset)  %(color:yellow)%(objectname:short)%(color:reset) %(contents:subject) %(color:green)%(committerdate:relative)%(color:reset) %(color:blue)[%(authorname)]%(color:reset)";
      oneline = "%(color:bold magenta)%(HEAD)%(color:reset) %(color:bold green)%(refname:short)%(color:reset)";
    };
  };
in {
  options.universe.home.git.aliases = {
    enable = mkOption {
      description = "Whether to enable.universe.home.git.aliases";
      default = true;
      type = types.bool;
    };

    extraAliases = mkOption {
      description = "A set of Git aliases to join along with the default ones.";
      default = {};
      example = {
        br = "branch";
        c = "commit";
      };
      type = types.attrsOf types.str;
    };

    excludeAliases = mkOption {
      description = "A list of Git aliases to exclude from the final result.";
      default = [];
      example = ["br" "c"];
      type = types.listOf types.str;
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      aliases =
        builtins.removeAttrs
        (defaultAliases // cfg.extraAliases)
        cfg.excludeAliases;
    };
  };
}
