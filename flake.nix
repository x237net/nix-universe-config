# flake.nix
# =========
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
  description = "universe/config, configure the universe.";

  inputs = {
    # Nixpkgs, the Nix packages collection.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Snowfall, opinionated Nix flake structure.
    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # flake-utils, utilities for working with Nix flakes.
    flake-utils.url = "github:numtide/flake-utils";

    # git-hooks.nix, seamless integration of git hooks with Nix.
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;

      src = ./.;

      snowfall = {
        namespace = "universe";

        meta = {
          title = "universe/config";
          name = "universe-config";
          license = "MIT";
        };
      };
    };
  in
    lib.mkFlake {
      supportedSystems = ["aarch64-darwin" "x86_64-linux"];
      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };
    };
}
