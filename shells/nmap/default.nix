# shells/nmap/default.nix
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
in
  mkShell {
    packages = with pkgs; [
      cdncheck
      curl
      cvemap
      dnsutils
      dnsx
      httpx
      ipcalc
      masscan
      naabu
      nmap
      nuclei
      nuclei-templates
      openssl
      subfinder
      tcpdump
      termshark
      tshark
      wireshark

      "${shell}"
    ];

    shellHook = ''
      exec ${shell}
    '';
  }
