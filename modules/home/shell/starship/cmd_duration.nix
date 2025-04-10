# modules/home/shell/starship/cmd_duration.nix
# ============================================
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
  cfg = config.universe.home.shell.starship.cmd_duration;

  ourSettings = {
    inherit (cfg) format style;

    disabled = !cfg.enable;
    min_time = cfg.minTime;
    min_time_to_notify = cfg.notifications.minTime;
    notification_timeout = mkIf (cfg.notifications.timeout != null) cfg.notifications.timeout;
    show_milliseconds = cfg.showMilliseconds;
    show_notifications = cfg.notifications.enable;
  };
in {
  options.universe.home.shell.starship.cmd_duration = with types;
  with universe.nix; {
    enable = mkEnabledOption "Shows how long the last command took to execute.";

    format = mkOption {
      description = ''
        The format of the command duration module.
        See: https://starship.rs/config/#command-duration
      '';
      default = "[$duration]($style) ";
      type = str;
    };

    minTime = mkOption {
      description = ''
        Shortest duration to show time for (in milliseconds).
      '';
      default = 2000;
      type = int;
    };

    notifications = {
      enable = mkEnableOption ''
        Show notifications when the command completes.
      '';

      minTime = mkOption {
        description = ''
          Shortest duration to show time for (in milliseconds).
        '';
        default = 45000;
        type = int;
      };

      timeout = mkOption {
        description = ''
          Duration to show notification for (in milliseconds). If unset,
          notification timeout will be determined by daemon. Not all notification
          daemons honor this option.
        '';
        default = null;
        type = nullOr int;
      };
    };

    showMilliseconds = mkEnableOption ''
      Show milliseconds in addition to seconds for the duration.
    '';

    style = mkOption {
      description = ''
        The style of the command duration module.
      '';
      default = "bold yellow";
      type = str;
    };
  };

  config.universe.home.shell.starship.settings.cmd_duration = mkIf cfg.enable ourSettings;
}
