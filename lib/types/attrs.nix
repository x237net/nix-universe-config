# lib/types/attrs.nix
# ===================
#
# Copying
# -------
#
# Copyright (c) 2025 Thrasibule.Mx - All Rights Reserved
#
# Unauthorized copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential.
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
with lib; rec {
  flatten = sep: let
    recurse = path:
      concatMapAttrs
      (name: value:
        if builtins.isAttrs value
        then recurse (path ++ [name]) value
        else {${builtins.concatStringsSep sep (path ++ [name])} = value;});
  in
    recurse [];
}
