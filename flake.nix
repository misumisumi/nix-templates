{
  description = "A collection of flake templates";

  outputs = { self }: {
    templates = {
      python-cuda = {
        path = ./python-cuda;
        description = "python environment with CUDA";
      };
      python-poetry = {
        path = ./python-poetry;
        description = "python environment managed by poetry";
      };
      python-poetry2nix = {
        path = ./python-poetry2nix;
        description = "python environment managed by poetry2nix";
      };
    };
  };
}
