{
  description = "LazyVim setup as a flake module using nixvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixvim, flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      flake = {
        # 暴露 flake module 接口
        nixosModules.lazyvim = { config, pkgs, lib, ... }: {
          environment.systemPackages = [
            (nixvim.legacyPackages.${pkgs.system}.makeNixvim {
              enableMan = false;
              withPython3 = false;
              withRuby = false;
              extraPackages = with pkgs; [
                lua-language-server
                stylua
                ripgrep
              ];
              extraPlugins = [ pkgs.vimPlugins.lazy-nvim ];
              extraConfigLua = ''
                require("lazy").setup({
                  defaults = { lazy = true },
                  dev = {
                    path = "${pkgs.linkFarm "lazy-plugins" []}",
                    patterns = { "" },
                    fallback = true,
                  },
                  spec = {
                    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
                    { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
                    { "mason-org/mason-lspconfig.nvim", enabled = false },
                    { "mason-org/mason.nvim", enabled = false },
                    { "nvim-treesitter/nvim-treesitter",
                      opts = function(_, opts) opts.ensure_installed = {} end },
                  },
                })
              '';
            })
          ];
        };
      };
    };
}
