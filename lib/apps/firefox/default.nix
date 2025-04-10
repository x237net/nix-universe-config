# lib/apps/firefox/default.nix
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
  # Flake's inputs.
  inputs,
  # The namespace of the flake. See `snowfall.namespace`.
  namespace,
  ...
}: {
  apps.firefox = {
    policy = import ./policy.nix {inherit lib inputs namespace;};
    profiles = import ./profiles.nix {inherit lib inputs namespace;};

    mkOptions = with lib;
    with lib.types; {
      enable = mkEnableOption "Whether to enable management of Firefox.";

      enhancedPrivacy = mkEnableOption ''
        Enable enhanced privacy settings in Firefox.
      '';

      packageInstall = mkOption {
        description = ''
          Whether to install the Firefox package as part of the user profile.
        '';
        default = true;
        type = bool;
      };

      zenMode = mkOption {
        description = ''
          Enable Zen mode in Firefox. Zen mode is a minimalistic mode that
          removes all UI elements except the content area.
        '';
        default = false;
        type = bool;
      };
    };

    path = {
      home = {
        aarch64-darwin.managedStorage = "Library/Application Support/Mozilla/ManagedStorage";
        x86_64-linux.managedStorage = ".mozilla/managed-storage";
      };
      system = {
        aarch64-darwin.managedStorage = "/Library/Application Support/Mozilla/ManagedStorage";
        x86_64-linux.managedStorage = "/usr/lib64/mozilla/managed-storage";
      };
    };
  };
}
