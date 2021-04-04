let
  pkgs = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/7471ce31fe27.tar.gz";
      sha256 = "0f85kqdgmlc6iblqy0vvkxidpzv0qwxzwql3dl0ibh3blbsvjyfs";
    }) { };
in
pkgs.stdenv.mkDerivation {
  name = "rmcgibbo.org";
  src = builtins.filterSource
    (path: type:
      baseNameOf path != ".git" &&
      baseNameOf path != "output" &&
      baseNameOf path != "result")
    ./.;
  buildInputs = [
    pkgs.python38Packages.pelican
    pkgs.python38Packages.markdown
  ];
  installPhase = ''
    make html
    mkdir -p $out
    mv output/* $out
  '';
}