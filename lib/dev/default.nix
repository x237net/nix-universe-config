# lib/dev/default.nix
# ===================
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
}: {
  dev = {
    git-hooks = let
      hooks = {
        # https://github.com/pre-commit/pre-commit-hooks
        check-added-large-files.enable = true;
        check-builtin-literals.enable = true;
        check-case-conflicts.enable = true;
        check-docstring-first.enable = true;
        check-executables-have-shebangs.enable = true;
        check-json.enable = true;
        check-merge-conflicts.enable = true;
        check-python.enable = true;
        check-shebang-scripts-are-executable.enable = true;
        check-symlinks.enable = true;
        check-toml.enable = true;
        check-yaml.enable = true;
        detect-aws-credentials.enable = true;
        detect-private-keys.enable = true;
        end-of-file-fixer.enable = true;
        fix-byte-order-marker.enable = true;
        fix-encoding-pragma.enable = true;
        fix-encoding-pragma.args = ["--remove"];
        mixed-line-endings.enable = true;
        mixed-line-endings.args = ["--fix=lf"];
        no-commit-to-branch.enable = true;
        pretty-format-json.enable = true;
        python-debug-statements.enable = true;
        trim-trailing-whitespace.enable = true;
        # https://github.com/kamadorueda/alejandra
        alejandra.enable = true;
        # https://github.com/psf/black
        black.enable = true;
        # https://github.com/PyCQA/isort
        isort.enable = true;
        isort.args = ["--profile" "black"];
        # https://github.com/astral-sh/ruff-pre-commit
        ruff.enable = true;
        # https://github.com/koalaman/shellcheck
        shellcheck.enable = true;
        # https://github.com/mvdan/sh
        shfmt.enable = true;
        # https://github.com/oppiliappan/statix
        statix.enable = true;
        # https://github.com/adrienverge/yamllint
        yamllint.enable = true;
      };
    in
      lib.flake-utils.eachDefaultSystemPassThrough (system: {
        ${system} = inputs.pre-commit-hooks.lib.${system}.run {
          inherit hooks;
          src = ./.;
        };
      });
  };
}
