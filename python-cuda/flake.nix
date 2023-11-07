{
  description = "Playbooks for apps of my k8s cluster";
  inputs.devenv.url = "github:cachix/devenv";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nixpkgs-python.url = "github:cachix/nixpkgs-python";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  inputs.nix2container = {
    url = "github:nlewo/nix2container";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { flake-parts, ... }:

    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      flake = {
        nixConfig = {
          extra-substituters = [
            "https://nixpkgs-python.cachix.org"
            "https://cuda-maintainers.cachix.org"
          ];
          extra-trusted-public-keys = [
            "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
            "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
          ];
        };
      };
      systems = [ "x86_64-linux" ];
      perSystem =
        { config
        , self'
        , inputs'
        , pkgs
        , system
        , ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (final: prev: { })
            ];
            config.allowUnfree = true;
          };
          devenv.shells.default = {
            containers.default = {
              name = "python-cuda";
              startupCommand = "bash";
              copyToRoot = null;
            };
            env = {
              XLA_FLAGS = "--xla_gpu_cuda_data_dir=${pkgs.cudaPackages_11_8.cudatoolkit}"; # For tensorflow with GPU support
              # https://github.com/google/REAPER/issues/14#issuecomment-651647572
              LD_PRELOAD = "${pkgs.gperftools}/lib/libtcmalloc.so";
            };
            packages = with pkgs; [
              pkgs.bashInteractive
              cudaPackages_11_8.cudatoolkit
              cudaPackages_11_8.cudnn_8_9
              ffmpeg
              file
              glibc
              gnumake
              libgcc
              llvmPackages_10.llvm
              mecab
              openssl
              zlib
            ];
            languages = {
              python = {
                enable = true;
                # poetry.enable = true;
                venv = {
                  enable = true;
                  requirements = null; # You must set requirements.txt
                };
                version = "3.9";
              };
            };
          };
        };
    };
}

