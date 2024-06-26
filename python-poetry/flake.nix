{
  description = "template of python project managed by poetry";
  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
      flake-parts.url = "github:hercules-ci/flake-parts";
      nixpkgs-python.url = "github:cachix/nixpkgs-python";
      devenv = {
        url = "github:cachix/devenv/python-rewrite";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.poetry2nix.follows = "poetry2nix";
      };
      mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
      nix2container = {
        url = "github:nlewo/nix2container";
        inputs.nixpkgs.follows = "nixpkgs-stable";
      };
      poetry2nix = {
        url = "github:nix-community/poetry2nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      {
        imports = [
          inputs.devenv.flakeModule
        ];
        flake = {
          nixConfig = {
            extra-substituters = [
              "https://nixpkgs-python.cachix.org"
              "https://cuda-maintainers.cachix.org"
              "https://devenv.cachix.org"
            ];
            extra-trusted-public-keys = [
              "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
              "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
              "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
            ];
          };
        };
        systems = [ "x86_64-linux" ];
        perSystem =
          { config
          , self'
          , inputs'
          , pkgs
          , lib
          , system
          , ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.poetry2nix.overlays.default
                (final: prev: {
                  inherit (inputs.nixpkgs-stable) skopeo;
                })
              ];
              config = {
                allowUnfree = true;
              };
            };
            devenv.shells.default =
              let
                inherit (inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryEnv;
                buildInputs = with pkgs;[
                  cudaPackages_11_8.cudatoolkit
                  cudaPackages_11_8.cudnn_8_9
                  pythonManylinuxPackages.manylinux2014Package
                  stdenv.cc.cc
                  zlib
                ];
              in
              {
                containers.default = {
                  name = "python-poetry";
                  startupCommand = "bash";
                  copyToRoot = null;
                };
                env = {
                  LD_LIBRARY_PATH = "${with pkgs; lib.makeLibraryPath buildInputs}:/run/opengl-driver/lib";
                  XLA_FLAGS = "--xla_gpu_cuda_data_dir=${pkgs.cudaPackages_11_8.cudatoolkit}"; # For tensorflow with GPU support
                };
                packages = with pkgs; [
                  bashInteractive
                ];
                languages.python = {
                  enable = true;
                  manylinux.enable = false;
                  package = pkgs.python310;
                  poetry = {
                    enable = true;
                  };
                };
              };
          };
      };
}


