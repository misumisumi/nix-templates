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
    nix-ml-ops.url = "github:Atry/nix-ml-ops";
  };
  outputs = inputs @ { nix-ml-ops, ... }:
    nix-ml-ops.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.nix-ml-ops.flakeModules.devenvPythonWithLibstdcxx
        inputs.nix-ml-ops.flakeModules.ldFallbackManylinux
        inputs.nix-ml-ops.flakeModules.cuda
        inputs.nix-ml-ops.flakeModules.nixpkgs
        inputs.nix-ml-ops.flakeModules.devcontainer
      ];
      perSystem = { pkgs, lib, system, ... }: {
        ml-ops.common.pythonPackage.base-package = pkgs.python310;
        ml-ops.devcontainer = {
          devenvShellModule.languages.python = {
            enable = true;
            poetry = {
              enable = true;
              activate.enable = false;
            };
          };
        };
      };
    };
}
