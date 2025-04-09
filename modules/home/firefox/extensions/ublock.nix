# modules/home/firefox/extensions/ublock.nix
# ==========================================
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
  inherit (config.universe.home.firefox) profiles zenMode;

  cfg = config.universe.home.firefox.extensions.ublock;

  managedStorageRoot = universe.apps.firefox.path.home.${system}.managedStorage;
  extId = "uBlock0@raymondhill.net";

  defaultFilterLists = [
    "adguard-generic"
    "adguard-mobile-app-banners"
    "adguard-popup-overlays"
    "adguard-spyware"
    "adguard-widgets"
    "easylist-chat"
    "easylist-newsletters"
    "easylist-notifications"
    "easylist"
    "easyprivacy"
    "fanboy-cookiemonster"
    "plowe-0"
    "ublock-badware"
    "ublock-filters"
    "ublock-privacy"
    "ublock-quick-fixes"
    "ublock-unbreak"
    "urlhaus-1"
    "user-filters"
  ];

  zenLists = [
    "adguard-cookies"
    "adguard-other-annoyances"
    "easylist-annoyances"
    "ublock-annoyances"
    "ublock-cookies-adguard"
    "ublock-cookies-easylist"
  ];

  assertProfiles = attrsToList cfg
    |> filter (p: assertMsg (hasAttr p.name profiles) "Profile '${p.name}' is not defined.")
    |> filter (p: p.value.enable);

  extProfiles = assertProfiles
    |> map (p: let
      selectedFilterLists = subtractLists p.value.excludeFilterLists (
        filterLists ++ (optionals zenMode zenLists)
      );
    in {
      ${p.name} = mkIf p.value.enable {
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
          ];
        };
      };
    })
    |> mergeAttrsList;
in {
  options.universe.home.firefox.extensions.ublock = with types; mkOption {
    type = attrsOf (submodule {
      options = {
        enable = mkEnableOption ''
          uBlock Origin, an efficient blocker for Firefox.
        '';

        contextMenuEnabled = mkOption {
          description = ''
            Whether to add a uBlock Origin item in the browser's context menu.
          '';
          default = !zenMode;
          example = false;
          type = bool;
        };

        excludeFilterLists = mkOption {
          description = ''
            The list of filter lists to be excluded from uBlock Origin.
          '';
          default = [];
          example = ["easylist" "easylist-annoyances"];
          type = listOf str;
        };

        extraFilterLists = mkOption {
          description = ''
            The list of other filter lists to be used by uBlock Origin.
          '';
          default = [];
          example = ["easylist" "easylist-annoyances"];
          type = listOf str;
        };

        ignore = mkOption {
          description = ''
            List of Websites that uBlock Origin can ignore.
          '';
          default = [];
          example = ["www.example.com"];
          type = listOf str;
        };

        showIconBadge = mkOption {
          description = ''
          '';
          default = !zenMode;
          example = false;
          type = bool;
        };
      };
    });
    default = {};
  };

  config = {
    programs.firefox.profiles = extProfiles;

    # FIXME: There is no way to define a managed storage per Firefox profile.
    #        Only one profile will succeed to store its configuration here.
    # https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_manifests
    home.file = mkMerge (forEach assertProfiles (p: {
      "${managedStorageRoot}/${extId}.json" = let
        filterLists = subtractLists p.value.excludeFilterLists (
          defaultFilterLists ++ p.value.extraFilterLists ++ (optionals zenMode zenLists)
        );

        settings = {
          name = extId;
          description = "uBlock Origin settings for profile '${p.name}'.";
          type = "storage";
          data = {
            toOverwrite = {
              inherit filterLists;
              trustedSiteDirectives = p.value.ignore;
            };
            userSettings = [
              ["contextMenuEnabled" (boolToString p.value.contextMenuEnabled)]
              ["showIconBadge" (boolToString p.value.showIconBadge)]
            ];
          };
        };
      in {
        text = builtins.toJSON settings;
      };
    }));
  };
}
