{ stdenv
, python3Packages
}:
stdenv.mkDerivation {
  name = "rmcgibbo.org";
  src = builtins.filterSource
    (path: type:
      baseNameOf path != ".git" &&
      baseNameOf path != "output" &&
      baseNameOf path != "result")
    ./.;
  buildInputs = [
    python3Packages.pelican
    python3Packages.markdown
  ];
  installPhase = ''
    make html
    mkdir -p $out
    echo 'rmcgibbo.org' > $out/CNAME
    mv output/* $out
  '';
}