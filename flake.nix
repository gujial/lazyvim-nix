{
  description = "LazyVim setup as a flake module using nixvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { system, lib, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
          mergedConfig = import ./modules/default.nix { inherit pkgs lib; };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [
              (nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvim {
                extraPackages = mergedConfig.packages;
                extraPlugins = mergedConfig.plugins;
                extraConfigLua = mergedConfig.luaConfig;
                inherit (mergedConfig) env opts;
              })
            ];
          };
        };

      flake = {
        # 暴露 flake module 接口
        nixosModules.lazyvim =
          { pkgs, lib, ... }:
          let
            # 使用统一的配置整合
            mergedConfig = import ./modules/default.nix { inherit pkgs lib; };
          in
          {
            environment.systemPackages = [
              (nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvim {
                extraPackages = mergedConfig.packages;
                extraPlugins = mergedConfig.plugins;
                extraConfigLua = mergedConfig.luaConfig;
                inherit (mergedConfig) env opts;
              })
            ];
          };
      };
    };
}
