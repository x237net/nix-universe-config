# shells/ansible/default.nix
# ==========================
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
    "IT automation using Ansible."
    [
      {
        name = "Ansible";
        description = "An automation engine that automates many IT processes.";
      }
      {
        name = "ansible-lint";
        description = "A command-line tool for linting Ansible playbooks.";
      }
      {
        name = "Git";
        description = "A distributed version control system that tracks versions of files.";
      }
      {
        name = "Molecule";
        description = "A tool designed to aid in developing and testing Ansible playbooks.";
      }
    ]
  );
in
  mkShell {
    packages = with pkgs;
      [
        ansible
        ansible-lint
        git
        molecule

        fastfetch
      ]
      ++ (lib.optional (shell != "") pkgs.${shell});

    name = "ansible";
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
