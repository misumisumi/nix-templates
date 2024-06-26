{
  description = "A collection of flake templates";

  outputs = { self }: {
    templates = {
      ml-ops = {
        path = ./ml-ops;
        description = "machine learning develop environment";
      };
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
