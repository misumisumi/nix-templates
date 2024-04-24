{
  nixConfig = {
    extra-substituters = [
      "https://cuda-maintainers.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };
  inputs = {
    # nix-ml-ops.url = "github:Atry/nix-ml-ops";
    nix-ml-ops.url = "github:misumisumi/nix-ml-ops/fix/cuda";
  };
  outputs = inputs @ { nix-ml-ops, ... }:
    nix-ml-ops.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.nix-ml-ops.flakeModules.cuda
        inputs.nix-ml-ops.flakeModules.devcontainer
        inputs.nix-ml-ops.flakeModules.ldFallbackManylinux
        inputs.nix-ml-ops.flakeModules.nixpkgs
      ];
      perSystem = { pkgs, lib, system, ... }: {
        ml-ops = {
          common = {
            cuda = {
              version = "12.1";
              packages = cp: with cp; [
                cuda_nvcc
                cudatoolkit
                cuda_cudart
                libcublas
                cudnn
              ];
            };
          };
          devcontainer = {
            devenvShellModule = {
              enterShell = ''
                if [ ! -f pyproject.toml ]; then
                  poetry new --name="$(basename $PWD | tr [:upper:] [:lower:])" --src ./tmp
                  mv ./tmp/* .
                  rm -rf ./tmp
                fi
              '';
              languages.python = {
                enable = true;
                package = pkgs.python311;
                poetry = {
                  enable = true;
                  activate.enable = true;
                };
              };
            };
          };
        };
      };
    };
}
