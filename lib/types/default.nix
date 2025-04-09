# lib/types/default.nix
# =====================
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
}: {
  attrs = import ./attrs.nix {inherit lib inputs namespace;};
}
