{
  description = "template of python project managed by poetry2nix";
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
                cudaSupport = true;
              };
            };
            apps = {
              poetry.program = "${pkgs.poetry}/bin/poetry";
            };
            devenv.shells.default =
              let
                inherit (inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryEnv;
              in
              {
                containers.default = {
                  name = "audiometrics";
                  startupCommand = "bash";
                  copyToRoot = null;
                };
                env = {
                  LD_LIBRARY_PATH = "${with pkgs; lib.makeLibraryPath [stdenv.cc.cc]}:/run/opengl-driver/lib";
                  POETRY_VIRTUALENVS_CREATE = true;
                  POETRY_VIRTUALENVS_IN_PROJECT = true;
                };
                packages =
                  let
                    myPythonEnv = mkPoetryEnv {
                      projectDir = ./.;
                      editablePackageSources = {
                        my-app = ./src;
                      };
                      python = pkgs.python310;
                      preferWheels = true;
                      extraPackages = ps: with ps; [ ];
                      overrides = pkgs.callPackage ./override.nix { };
                    };
                  in
                  with pkgs;
                  [
                    bashInteractive
                    myPythonEnv
                    poetry
                  ];
              };
          };
      };
}

