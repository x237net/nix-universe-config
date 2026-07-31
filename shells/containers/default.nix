# shells/kubernetes/default.nix
# =============================
#
# Copying
# -------
#
# Copyright (c) 2026 universe/config authors and contributors.
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
    "A shell environment to build, lint, validate, and manage containers."
    [
      # Building & Execution
      {
        name = "  Building & Execution";
        description = "";
      }
      {
        name = "buildah";
        description = "Tool that facilitates building OCI images.";
      }
      {
        name = "docker";
        description = "Classic container engine CLI.";
      }
      {
        name = "podman";
        description = "Daemonless container engine for OCI Containers.";
      }
      # Image Management & Inspection
      {
        name = "  Image Management & Inspection";
        description = "";
      }
      {
        name = "crane";
        description = "Interact with remote images and registries.";
      }
      {
        name = "dive";
        description = "Tool for exploring each layer in a container image.";
      }
      {
        name = "skopeo";
        description = "Operations on container images and repositories.";
      }
      # Linting & Validation
      {
        name = "  Linting & Validation";
        description = "";
      }
      {
        name = "dockle";
        description = "Container Image Linter for Security.";
      }
      {
        name = "hadolint";
        description = "Dockerfile linter that validates inline bash.";
      }
      # Security & SBOM
      {
        name = "  Security & SBOM";
        description = "";
      }
      {
        name = "grype";
        description = "Vulnerability scanner for container images.";
      }
      {
        name = "kics";
        description = "Keeping Infrastructure as Code Secure.";
      }
      {
        name = "syft";
        description = "Generates a Software Bill of Materials (SBOM).";
      }
      {
        name = "trivy";
        description = "Vulnerability scanner for containers.";
      }
      # Management & TUI
      {
        name = "  Management & TUI";
        description = "";
      }
      {
        name = "ctop";
        description = "Top-like interface for container metrics.";
      }
      {
        name = "docker-compose";
        description = "Multi-container orchestration tool.";
      }
      {
        name = "lazydocker";
        description = "Terminal UI for docker and docker-compose.";
      }
      {
        name = "podman-compose";
        description = "Run docker-compose.yml using podman.";
      }
    ]
  );
in
  mkShell {
    packages = with pkgs;
      [
        # Building & Execution
        docker

        # Image Management & Inspection
        dive
        go-containerregistry # Provides crane
        skopeo

        # Linting & Validation
        hadolint

        # Security & SBOM
        grype
        kics
        syft
        trivy

        # Management & TUI
        ctop
        docker-compose
        lazydocker

        fastfetch
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        buildah
        dockle
        podman
        podman-compose
      ]
      ++ (lib.optional (shell != "") pkgs.${shell});

    name = "containers";
    shellHook = ''
      fastfetch --config "${fastfetch_cfg}"

      export PS1="[''${name}]$ "
      if [ "${shell}" ]
      then
        export SHELL="$(which ${shell})"
        exec ''${SHELL}
      fi
    '';
  }
