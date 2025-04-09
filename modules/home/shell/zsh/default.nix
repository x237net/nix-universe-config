# modules/home/shell/zsh/default.nix
# ==================================
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
  cfg = config.universe.home.shell.zsh;
in {
  imports = universe.fs.import-directory ./.;

  options.universe.home.shell.zsh = with types;
  with universe.nix; {
    enable = mkEnableOption "universe.home.shell.zsh";

    keymap = mkOption {
      description = ''
        The base keymap to use. Can either be Emacs or Vi mode.
      '';
      default = null;
      type = nullOr (enum [
        "emacs"
        "vicmd"
        "viins"
      ]);
    };

    config = {
      directory = mkOption {
        description = ''
          Directory where the zsh configuration and more should be located,
          relative to the users home directory. The default is the home directory.
        '';
        default = null;
        type = nullOr str;
      };
    };

    history = {
      append = mkEnableOption ''
        If set, zsh sessions will append their history list to the history
        file, rather than replace it. Thus, multiple parallel zsh sessions
        will all have the new entries from their history lists added to the
        history file, in the order that they exit.
      '';

      ignoreDups = mkEnabledOption ''
        If set, zsh will not add a command to the history list if it is
        identical to the last command in the history list.
      '';

      ignoreSpace = mkEnabledOption ''
        If set, zsh will not add a command to the history list if it begins
        with a space.
      '';

      share = mkEnabledOption ''
        Share command history between ZSH sessions.
      '';
    };

    highlighting = {
      enable = mkEnabledOption "Enable ZSH syntax highlighting.";
      styles = mkOption {
        description = ''
          A set of custom styles to use for syntax highlighting.
          See the [zsh-syntax-highlighting documentation](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md)
          for the available styles.
        '';
        default = {};
        type = attrsOf str;
      };
    };

    suggestion = {
      enable = mkEnabledOption ''
        Suggest commands as you type based on history and completions.
      '';

      strategy = mkOption {
        description = ''
          Specifies how suggestions should be generated.

          * `history`: Chooses the most recent match from history.
          * `completion`: Chooses a suggestion based on what tab-completion
            would suggest.
        '';
        default = ["history" "completion"];
        type = listOf (enum [
          "history"
          "completion"
        ]);
      };
    };
  };

  config = mkIf cfg.enable {
    home.shell.enableZshIntegration = cfg.enable;
    programs.starship.enableZshIntegration = config.universe.home.shell.starship.enable;

    programs.zsh = {
      inherit (cfg) enable;

      autosuggestion = {
        inherit (cfg.suggestion) enable strategy;
      };

      defaultKeymap = cfg.keymap;
      dotDir = cfg.config.directory;

      enableCompletion = true;
      enableVteIntegration = true;

      history = {
        inherit (cfg.history) append ignoreDups ignoreSpace share;

        extended = true;
        findNoDups = true;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      syntaxHighlighting = {
        inherit (cfg.highlighting) enable styles;
      };
    };
  };
}
