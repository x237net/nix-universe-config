# lib/shells/default.nix
# ======================
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
  shells = rec {
    fastFetchHeader = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
    };

    mkFastFetchCustomModule = attrs:
      with attrs; {
        type = "custom";
        key = name;
        format = description;
      };

    mkFastFetchSystemModules = [
      "os"
      "shell"
      {
        type = "title";
        key = "User";
        format = "{user-name}{at-symbol-colored}{host-name}";
      }
      "memory"
      "disk"
    ];

    mkFastFetchSeparator = description: string: let
      length =
        if (description == null)
        then 1
        else (stringLength description);

      header = optional (description != null) (mkFastFetchCustomModule {
        inherit description;
        name = " ";
      });
    in
      header
      ++ [
        {
          inherit length string;
          type = "separator";
        }
      ];

    mkFastFetchConfig = desc: pkgs: let
      header = mkFastFetchSeparator desc " ";
      packages = (mkFastFetchSeparator "Packages:" "-") ++ (builtins.map mkFastFetchCustomModule pkgs);
      system = (mkFastFetchSeparator "System:" "-") ++ mkFastFetchSystemModules;

      config =
        fastFetchHeader
        // {
          logo = {
            type = "small";
          };
          modules =
            header
            ++ system
            ++ (mkFastFetchSeparator null " ")
            ++ packages
            ++ (mkFastFetchSeparator null " ");
        };
    in
      builtins.toJSON config;
  };
}
