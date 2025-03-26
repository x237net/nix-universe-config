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
  fastfetch_cfg = pkgs.writeText "fastfetch.jsonc" (
    lib.universe.shells.mkFastFetchConfig
    "A shell environment to investigate network targets."
    [
      {
        name = "cdncheck";
        description = "A tool for identifying the technology associated with a network addresses.";
      }
      {
        name = "curl";
        description = "A tool for transferring data from or to a server using URLs.";
      }
      {
        name = "cvemap";
        description = "Navigate the Common Vulnerabilities and Exposures (CVE) jungle with ease.";
      }
      {
        name = "dnsutils";
        description = "Various client programs related to DNS that are derived from the BIND source tree.";
      }
      {
        name = "dnsx";
        description = "A fast and multi-purpose DNS toolkit.";
      }
      {
        name = "httpx";
        description = "A fully featured HTTP client.";
      }
      {
        name = "ipcalc";
        description = "A calculator for IPv4 and IPv6 addresses.";
      }
      {
        name = "masscan";
        description = "An Internet-scale port scanner.";
      }
      {
        name = "Naabu";
        description = "A port scanning tool that allows to enumerate valid ports for hosts in a fast and reliable manner.";
      }
      {
        name = "Nmap";
        description = "A tool for network exploration and security auditing.";
      }
      {
        name = "Nuclei";
        description = "A high-performance vulnerability scanner that leverages YAML-based templates.";
      }
      {
        name = "OpenSSL";
        description = "A full-featured open-source Toolkit for the TLS (formerly SSL), DTLS and QUIC protocols.";
      }
      {
        name = "subfinder";
        description = "A subdomain discovery tool that returns valid subdomains for websites, using passive online sources.";
      }
      {
        name = "tcpdump";
        description = "A command line utility that allows to capture and analyze network traffic.";
      }
      {
        name = "termshark";
        description = "A terminal user-interface for tshark, inspired by Wireshark.";
      }
      {
        name = "tshark";
        description = "A terminal oriented version of Wireshark.";
      }
      {
        name = "Wireshark";
        description = "A network protocol analyzer.";
      }
    ]
  );
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

      fastfetch
      "${shell}"
    ];

    name = "nmap";
    shellHook = ''
      PS1="[''${name}] ''${PS1-}"

      exec ${shell}
      fastfetch --config "${fastfetch_cfg}"
    '';
  }
