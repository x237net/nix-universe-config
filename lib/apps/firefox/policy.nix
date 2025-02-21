# lib/apps/firefox/policy.nix
# ===========================
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
}:
with lib; {
  mkOptions = with types; {
    clearCookiesOnShutdown = mkEnableOption ''
      Clear Cookies and Offline Website Data on shutdown.
    '';

    clearHistoryOnShutdown = mkEnableOption ''
      Clear Browsing History, Download History, Form & Search History on
      shutdown.
    '';

    disablePocket = mkOption {
      description = "Remove Pocket in the Firefox UI.";
      default = true;
      type = bool;
    };

    displayBookmarksToolbar = mkOption {
      description = ''
        Set the initial state of the bookmarks toolbar. A user can still
        change how it is displayed.

        * `always`: the bookmarks toolbar is always shown.
        * `never`: the bookmarks toolbar is never shown.
        * `newtab`: the bookmarks toolbar is shown only on the new tab page.
      '';
      default = "never";
      type =
        str
        // {
          check = x: builtins.elem x ["always" "never" "newtab"];
        };
    };

    displayMenuBar = mkOption {
      description = ''
        Set the initial state of the menu bar. A user can still change how it
        is displayed.

        * `always`: the menu bar is always shown and cannot be hidden.
        * `never`: the menu bar is hidden and cannot be shown.
        * `default-on`: the menu bar is shown by default but can be hidden.
        * `default-off`: the menu bar is hidden by default but can be shown.
      '';
      default = "default-off";
      type =
        str
        // {
          check = x: builtins.elem x ["always" "never" "default-on" "default-off"];
        };
    };

    dohExcludeDomains = mkOption {
      description = ''
        A list of domains to exclude from DNS-over-HTTPS (DoH). This is useful
        for domains that do not support DoH or have specific requirements.

        Note that DNS-over-HTTPS is enabled by the `privacyEnhanced` option.
      '';
      default = [];
      type = listOf str;
    };

    dohProviderUrl = mkOption {
      description = ''
        The URL of the DNS-over-HTTPS (DoH) provider.

        Note that DNS-over-HTTPS is enabled by the `privacyEnhanced` option.
      '';
      default = null;
      type = nullOr str;
    };

    passwordManagerEnabled = mkEnableOption ''
      Remove access to the builtin Firefox password manager.
    '';

    searchBar = mkOption {
      description = ''
        Set whether or not search bar is displayed.

        * `separate`: the search bar is separated from the URL bar.
        * `unified`: the search bar is unified with the URL bar.
      '';
      default = "unified";
      type =
        str
        // {
          check = x: builtins.elem x ["separate" "unified"];
        };
    };
  };

  mkGeneralPolicy = cfg: {
    # Disable Firefox updates, those are managed by Nix or the system package.
    AppAutoUpdate = true;
    DisableAppUpdate = true;
    # Initialization.
    NoDefaultBookmarks = false;
    # Pocket.
    DisablePocket = cfg.disablePocket;
    FirefoxSuggest = {
      WebSuggestions = true;
      Locked = false;
    };
    # Privacy.
    EnableTrackingProtection = {
      Value = true;
      Locked = false;
      Cryptomining = true;
      Fingerprinting = true;
      EmailTracking = true;
    };
    SanitizeOnShutdown = {
      Cookies = cfg.clearCookiesOnShutdown;
      History = cfg.clearHistoryOnShutdown;
    };
    # UI.
    DisplayBookmarksToolbar = cfg.displayBookmarksToolbar;
    DisplayMenuBar = cfg.displayMenuBar;
    PopupBlocking = {
      Default = true;
    };
    SearchBar = cfg.searchBar;
    SSLVersionMin = "tls1.2";
  };

  mkPrivacyPolicy = cfg: {
    DisableFirefoxStudies = true;
    DisableFormHistory = true;
    DisableTelemetry = true;
    DNSOverHTTPS = {
      Enabled = true;
      ExcludeDomains = cfg.dohExcludeDomains;
      FallBack = true;
      ProviderURL = mkIf cfg.dohProviderUrl cfg.dohProviderUrl;
    };
    EnableTrackingProtection = {
      Value = true;
      Locked = false;
      Cryptomining = true;
      Fingerprinting = true;
      EmailTracking = true;
    };
    FirefoxSuggest = {
      SponsoredSuggestions = false;
      ImproveSuggest = false;
    };
    SanitizeOnShutdown = {
      Cache = true;
    };
    SearchEngines = {
      PreventInstalls = true;
    };
    StartDownloadsInTempDirectory = true;
  };

  mkZenPolicy = cfg: {
    DisplayBookmarksToolbar = "never";
    DisplayMenuBar = "default-off";
    NewTabPage = false;
    OfferToSaveLoginsDefault = false;
    PromptForDownloadLocation = false;
    SearchBar = "unified";
    ShowHomeButton = false;
    TranslateEnabled = false;
    UserMessaging = {
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      SkipOnboarding = true;
      MoreFromMozilla = false;
      FirefoxLabs = false;
    };
  };
}
