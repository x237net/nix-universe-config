# shells/http/default.nix
# =======================
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
  # An instance of `pkgs` with the overlays and other packages.
  pkgs,
  mkShell,
  ...
}: let
  shell = builtins.baseNameOf (builtins.getEnv "SHELL");
  fastfetch_cfg = pkgs.writeText "fastfetch.jsonc" (
    lib.universe.shells.mkFastFetchConfig
    "A shell environment to query HTTP resources."
    [
      {
        name = "Bruno";
        description = "A Git-friendly and offline-first open-source API client.";
      }
      {
        name = "curl";
        description = "A tool for transferring data from or to a server using URLs.";
      }
      {
        name = "dnsutils";
        description = "Various client programs related to DNS that are derived from the BIND source tree.";
      }
      {
        name = "httpx";
        description = "A fully featured HTTP client.";
      }
      {
        name = "Katana";
        description = "A fast crawler focused on execution in automation pipelines.";
      }
      {
        name = "OpenSSL";
        description = "A full-featured open-source Toolkit for the TLS (formerly SSL), DTLS and QUIC protocols.";
      }
      {
        name = "Playwright";
        description = "A fast and reliable end-to-end testing for modern Web apps.";
      }
      {
        name = "subfinder";
        description = "A subdomain discovery tool that returns valid subdomains for websites, using passive online sources.";
      }
    ]
  );
in
  mkShell {
    packages = with pkgs; [
      bruno
      bruno-cli
      curl
      dnsutils
      httpx
      katana
      openssl
      playwright-driver
      subfinder

      (python3.withPackages (
        pypkgs:
          with pypkgs; [
            httpx
            playwright
            requests
          ]
      ))

      fastfetch
      "${shell}"
    ];

    shellHook = ''
      exec ${shell}
      fastfetch --config "${fastfetch_cfg}"
    '';
  }
