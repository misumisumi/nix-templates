{ lib, pkgs, ... }:
pkgs.poetry2nix.overrides.withDefaults (final: prev:
let
  notUseWheelPackages = [ ];
in
lib.listToAttrs (map (name: lib.nameValuePair name (prev.${name}.override { preferWheel = false; })) notUseWheelPackages)
//
{
  # Remove missing dependencies
  typing = null;
  # more fine-grained overrides
  # onnxruntime-gpu = prev.onnxruntime-gpu.overridePythonAttrs (old: {
  #   buildInputs = with pkgs.cudaPackages_11_8; old.buildInputs ++ [
  #     cudnn
  #     cudatoolkit
  #   ];
  #   autoPatchelfIgnoreMissingDeps = lib.optionals pkgs.stdenv.isLinux [
  #     "libcuda.so.1"
  #     "libnvinfer.so.8"
  #     "libnvinfer_plugin.so.8"
  #     "libnvonnxparser.so.8"
  #   ];
  # });
}
  //
(with pkgs; with prev;
let
  fixDerivation = { name, setupRequires, installRequires, override }:
    (prev.${name}.override override).overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ setupRequires;
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ installRequires;
    });
  mkOverrides = lib.mapAttrs
    (name: value: fixDerivation {
      inherit name;
      setupRequires = value.setupRequires or [ ];
      installRequires = value.installRequires or [ ];
      override = value.override or  { };
    });
in
# easy override
mkOverrides {
  # torchvision = { setupRequires = [ autoPatchelfHook ]; };
}
))
