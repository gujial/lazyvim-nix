# lazyvim nixos flake moudule

## Usage

```nix
# /etc/nixos/flake.nix
{
  ...
  inputs = {
      ...
      lazyvim-nix = {
        url = "github:gujial/lazyvim-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      ...
    };

  outputs = inputs@{ nixpkgs, lazyvim-nix, ... } {
      ...
      lazyvim-nix.nixosModules.lazyvim
      ...
    };
}
```
