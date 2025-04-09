# modules/home/shell/starship/default.nix
# =======================================
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
  cfg = config.universe.home.shell.starship;

  starshipModules = [
    "aws"
    "azure"
    "battery"
    "buf"
    "bun"
    "c"
    "character"
    "cmake"
    "cmd_duration"
    "cobol"
    "conda"
    "container"
    "crystal"
    "custom"
    "daml"
    "dart"
    "deno"
    "directory"
    "direnv"
    "docker_context"
    "dotnet"
    "elixir"
    "elm"
    "env_var"
    "erlang"
    "fennel"
    "fill"
    "fossil_branch"
    "fossil_metrics"
    "gcloud"
    "git_branch"
    "git_commit"
    "git_metrics"
    "git_state"
    "git_status"
    "gleam"
    "golang"
    "gradle"
    "guix_shell"
    "haskell"
    "haxe"
    "helm"
    "hg_branch"
    "hostname"
    "java"
    "jobs"
    "julia"
    "kotlin"
    "kubernetes"
    "line_break"
    "localip"
    "lua"
    "memory_usage"
    "meson"
    "mojo"
    "nats"
    "netns"
    "nim"
    "nix_shell"
    "nodejs"
    "ocaml"
    "odin"
    "opa"
    "openstack"
    "os"
    "package"
    "perl"
    "php"
    "pijul_channel"
    "pulumi"
    "purescript"
    "python"
    "quarto"
    "raku"
    "red"
    "rlang"
    "ruby"
    "rust"
    "scala"
    "shell"
    "shlvl"
    "singularity"
    "solidity"
    "spack"
    "status"
    "sudo"
    "swift"
    "terraform"
    "time"
    "typst"
    "username"
    "vagrant"
    "vcsh"
    "vlang"
    "zig"
  ];

  defaultModules = [
    "username"
    "hostname"
    "localip"
    "shlvl"
    "singularity"
    "kubernetes"
    "directory"
    "vcsh"
    "fossil_branch"
    "fossil_metrics"
    "git_branch"
    "git_commit"
    "git_state"
    "git_metrics"
    "git_status"
    "hg_branch"
    "pijul_channel"
    "docker_context"
    "package"
    "c"
    "cmake"
    "cobol"
    "daml"
    "dart"
    "deno"
    "dotnet"
    "elixir"
    "elm"
    "erlang"
    "fennel"
    "gleam"
    "golang"
    "guix_shell"
    "haskell"
    "haxe"
    "helm"
    "java"
    "julia"
    "kotlin"
    "gradle"
    "lua"
    "nim"
    "nodejs"
    "ocaml"
    "opa"
    "perl"
    "php"
    "pulumi"
    "purescript"
    "python"
    "quarto"
    "raku"
    "rlang"
    "red"
    "ruby"
    "rust"
    "scala"
    "solidity"
    "swift"
    "terraform"
    "typst"
    "vlang"
    "vagrant"
    "zig"
    "buf"
    "nix_shell"
    "conda"
    "meson"
    "spack"
    "memory_usage"
    "aws"
    "gcloud"
    "openstack"
    "azure"
    "nats"
    "direnv"
    "env_var"
    "crystal"
    "custom"
    "sudo"
    "line_break"
    "jobs"
    "battery"
    "time"
    "os"
    "container"
    "shell"
    "character"
  ];

  defaultRightModules = [
    "cmd_duration"
    "status"
  ];

  mkStarshipModules = concatMapStrings (x: "$" + x);

  ourSettings = {
    inherit (cfg) palettes;

    format = mkStarshipModules cfg.modules;
    right_format = mkStarshipModules cfg.rightModules;

    add_newline = cfg.addNewLine;
    command_timeout = cfg.commandTimeout;
    follow_symlinks = cfg.followSymlinks;
    palette = mkIf (cfg.palette != null) cfg.palette;
    scan_timeout = cfg.scanTimeout;
  };
in {
  imports = universe.fs.import-directory ./.;

  options.universe.home.shell.starship = with types; {
    settings = mkOption {
      description = "Final settings for the Starship prompt.";
      default = {};
      type = attrs;
      internal = true;
    };

    enable = mkEnableOption "Whether to enable.universe.home.shell.starship";

    modules = mkOption {
      description = ''
        The list of modules composing the prompt. List each module in the order
        they should appear in the prompt. Use the `format` option of each module
        to customize how they are displayed.

        See the [Starship documentation](https://starship.rs/config/) for the
        full list of modules and their options.
      '';
      default = defaultModules;
      example = ["username" "hostname" "directory" "character"];
      type = listOf (enum starshipModules);
    };

    rightModules = mkOption {
      description = ''
        Some shells support a right prompt which renders on the same line as the
        input. Set the modules displaying on the right prompt using this option.

      '';
      default = defaultRightModules;
      example = ["status"];
      type = listOf (enum starshipModules);
    };

    commandTimeout = mkOption {
      description = ''
        The time in milliseconds to wait for Starship to run a command.
      '';
      default = 500;
      type = int;
    };

    scanTimeout = mkOption {
      description = ''
        The time in milliseconds to wait for Starship to scan files.
      '';
      default = 30;
      type = int;
    };

    addNewLine = mkEnableOption ''
      Whether to add a new line before shell prompts.
    '';

    followSymlinks = mkEnableOption ''
      Follows symlinks to check if they're directories; used in modules such
      as git.

      Note: If you have symlinks to networked filesystems, consider setting
      `followSymlinks` to `false`.
    '';

    palette = mkOption {
      description = ''
        Sets which color palette from `palettes` to use.
      '';
      default = null;
      type = nullOr str;
    };

    palettes = mkOption {
      description = ''
        Collection of color palettes that assign colors to user-defined names.
        Note that color palettes cannot reference their own color definitions.
      '';
      default = {};
      type = attrsOf str;
    };
  };

  config = mkIf cfg.enable {
    programs.starship = {
      inherit (cfg) enable;
      settings = cfg.settings // ourSettings;
    };
  };
}
