# modules/home/shell/starship/status.nix
# ======================================
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
  cfg = config.universe.home.shell.starship.status;

  ourSettings = {
    inherit (cfg) format;

    disabled = !cfg.enable;

    style = mkIf (cfg.style.default != null) cfg.style.default;
    failure_style = mkIf (cfg.style.failure != null) cfg.style.failure;
    success_style = mkIf (cfg.style.success != null) cfg.style.success;

    symbol = mkIf (cfg.symbol.failure != null) cfg.symbol.failure;
    not_executable_symbol = mkIf (cfg.symbol.notExecutable != null) cfg.symbol.notExecutable;
    not_found_symbol = mkIf (cfg.symbol.notFound != null) cfg.symbol.notFound;
    sigint_symbol = mkIf (cfg.symbol.sigint != null) cfg.symbol.sigint;
    signal_symbol = mkIf (cfg.symbol.signal != null) cfg.symbol.signal;
    success_symbol = mkIf (cfg.symbol.success != null) cfg.symbol.success;

    map_symbol = cfg.symbol.enableMapping;
    recognize_signal_code = cfg.symbol.recognizeSignalCode;

    pipestatus = cfg.pipestatus.enable;
    pipestatus_format = cfg.pipestatus.format;
    pipestatus_segment_format = mkIf (cfg.pipestatus.segmentFormat != null) cfg.pipestatus.segmentFormat;
    pipestatus_separator = cfg.pipestatus.separator;
  };
in {
  options.universe.home.shell.starship.status = with types;
  with universe.nix; {
    enable = mkEnabledOption "Shows how long the last command took to execute.";

    format = mkOption {
      description = ''
        The format of the status module.
        See: https://starship.rs/config/#status
      '';
      default = "\\[[$status $symbol]($style)\\]";
      type = str;
    };

    pipestatus = {
      enable = mkEnableOption ''
        Enable pipestatus reporting.
      '';

      format = mkOption {
        description = ''
          The format of the module when the command is a pipeline.
        '';
        default = "\\(\\[$pipestatus\\] => [$common_meaning$signal_name$maybe_int $symbol]($style)\\)";
        type = str;
      };

      segmentFormat = mkOption {
        description = ''
          When specified, replaces `pipestatus.format` when formatting pipestatus
          segments.
        '';
        default = null;
        type = nullOr str;
      };

      separator = mkOption {
        description = ''
          The symbol used to separate pipestatus segments (supports formatting).
        '';
        default = "|";
        type = str;
      };
    };

    style = {
      default = mkOption {
        description = ''
          The style of the status module.
        '';
        default = "bold red";
        type = str;
      };

      failure = mkOption {
        description = ''
          The style of the status module when the command fails (defaults to
          `style.default` if unset).
        '';
        default = null;
        type = nullOr str;
      };

      success = mkOption {
        description = ''
          The style of the status module when the command succeeds (defaults to
          `style.default` if unset).
        '';
        default = "bold green";
        type = nullOr str;
      };
    };

    symbol = {
      enableMapping = mkEnabledOption ''
        Enable symbols mapping from exit code.
      '';

      recognizeSignalCode = mkEnabledOption ''
        Enable signal mapping from exit code.
      '';

      failure = mkOption {
        description = ''
          The symbol displayed on program error.
        '';
        default = "✗";
        type = nullOr str;
      };

      notExecutable = mkOption {
        description = ''
          The symbol displayed when file isn't executable.
        '';
        default = "󰅜";
        type = nullOr str;
      };

      notFound = mkOption {
        description = ''
          The symbol displayed when the command can't be found.
        '';
        default = "";
        type = nullOr str;
      };

      sigint = mkOption {
        description = ''
          The symbol displayed when the command is interrupted.
        '';
        default = "󰜺";
        type = nullOr str;
      };

      signal = mkOption {
        description = ''
          The symbol displayed when the command is killed by a signal.
        '';
        default = "󱐋";
        type = nullOr str;
      };

      success = mkOption {
        description = ''
          The symbol displayed on program success.
        '';
        default = null;
        type = nullOr str;
      };
    };
  };

  config.universe.home.shell.starship.settings.status = mkIf cfg.enable ourSettings;
}
