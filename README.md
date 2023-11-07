# nix-templates

## Templates

- python-cuda: python environment with CUDA
- python-poetry: python environment managed by poetry

## Generate container

```flake.nix

...
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
            process.<name> = {
              exec = "python launch-web.py";
            };
            containers.<name> = {
              name = "<name>";
              # entrypoint = ["${pkgs.hello}/bin/hello"]; # Launch hello
              startupCommand = "bash"; # or config.process.<name>.exec
              copyToRoot = null; # Exclude the source repo to make the container smaller.
            };
            packages = with pkgs; [
              pkgs.bashInteractive # Must need
            ];
          };
        };
...
```

```
# Generate container-image
nix run ".#container-<name>.copyToPodman"

# Run
podman run
```
