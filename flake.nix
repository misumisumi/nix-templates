{
  description = "A collection of flake templates";

  outputs = { self }: {
    templates = {
      python-cuda = {
        path = ./python-cuda;
        description = "python environment with CUDA";
      };
      python-poetry = {
        path = ./python-cuda;
        description = "python environment with CUDA";
      };
    };
  };
}
