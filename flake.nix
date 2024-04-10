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
        path = ./python-cuda;
        description = "python environment with CUDA";
      };
    };
  };
}
