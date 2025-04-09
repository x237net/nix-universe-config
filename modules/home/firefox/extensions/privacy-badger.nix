# modules/home/firefox/extensions/privacy-badger.nix
# ==================================================
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

  cfg = config.universe.home.firefox.extensions.privacy-badger;

  managedStorageRoot = universe.apps.firefox.path.home.${system}.managedStorage;
  extId = "jid1-MnnxcxisBPnSXQ@jetpack";

  assertProfiles = attrsToList cfg
    |> filter (p: assertMsg (hasAttr p.name profiles) "Profile '${p.name}' is not defined.")
    |> filter (p: p.value.enable);

  extProfiles = assertProfiles
    |> map (p: {
      ${p.name} = mkIf p.value.enable {
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            privacy-badger
          ];
        };
      };
    })
    |> mergeAttrsList;
in {
  options.universe.home.firefox.extensions.privacy-badger = with types; mkOption {
    type = attrsOf (submodule {
      options = {
        enable = mkEnableOption ''
          uBlock Origin, an efficient blocker for Firefox.
        '';

        checkForDNTPolicy = mkOption {
          type = bool;
          default = true;
          description = ''
            If set to `false` then do not query third-party domains for
            declarations of compliance with EFF's Do Not Track policy.
          '';
        };

        disabledSites = mkOption {
          type = listOf str;
          default = [];
          description = ''
            This is a list of website domains where Privacy Badger will be
            disabled. This means that Privacy Badger will not block anything or
            send DNT/GPC signals to anything when you visit a website on this
            list. If you want to customize tracking domain settings, use
            trackingDomains, not disabledSites.
          '';
        };

        learnLocally = mkOption {
          type = bool;
          default = false;
          description = ''
            Learn to block new trackers from your browsing.

            WARNING: Enabling learning may make you more identifiable to
            websites. Please see https://www.eff.org/badger-evolution for more
            information.
          '';
        };

        learnInIncognito = mkOption {
          type = bool;
          default = false;
          description = ''
            Learn to block new trackers in incognito mode.

            WARNING: Enabling learning in Private/Incognito windows may leave
            traces of your private browsing history on your computer. By
            default, Privacy Badger will block trackers it already knows about
            in Private/Incognito windows, but it won't learn about new
            trackers. You might want to enable this option if a lot of your
            browsing happens in Private/Incognito windows.
          '';
        };

        sendDNTSignal = mkOption {
          type = bool;
          default = true;
          description = ''
            Toggles global sending of Global Privacy Control and Do Not Track
            signals.
          '';
        };

        showCounter = mkOption {
          type = bool;
          default = !zenMode;
          description = ''
            Toggles showing the counter over Privacy Badger's icon in the
            browser toolbar.
          '';
        };

        showIntroPage = mkOption {
          type = bool;
          default = !zenMode;
          description = ''
            If set to `false` then do not open the new user intro page upon
            install.
          '';
        };

        trackingDomains = mkOption {
          type = listOf (submodule {
            options = {
              domain = mkOption {
                type = str;
                description = ''
                  The tracking domain to be added to the list.
                '';
              };

              action = mkOption {
                type = enum ["allow" "block" "cookieblock"];
                default = "block";
                description = ''
                  The action to be taken for the tracking domain. Possible
                  values are "block", "cookieblock", and "allow".
                '';
              };
            };
          });
          default = [];
          description = ''
            This list lets you specify actions for tracking domains.
          '';
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
      "${managedStorageRoot}/${extId}.json".text = builtins.toJSON {
        name = extId;
        description = "Privacy Badger settings for profile '${p.name}'.";
        type = "storage";
        data = builtins.removeAttrs p.value ["enable"];
      };
    }));
  };
}
