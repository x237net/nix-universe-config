# lib/apps/firefox/default.nix
# ============================
#
# Copying
# -------
#
# Copyright (c) 2025 Thrasibule.Mx - All Rights Reserved
#
# Unauthorized copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential.
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

    mkOptions = with lib;
    with lib.types; {
      enable = mkEnableOption "Whether to enable management of Firefox.";

      enhancedPrivacy = mkEnableOption ''
        Enable enhanced privacy settings in Firefox.
      '';

      package = mkOption {
        description = "The Firefox package to install.";
        default = pkgs.firefox;
        type = nullOr package;
      };

      packageInstall = mkOption {
        description = ''
          Whether to install the Firefox package as part of the user profile.
        '';
        default = !isDarwin;
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
  };
}
