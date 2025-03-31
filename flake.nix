{
  description = "Professional website";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    py-utils.url = "github:rmcgibbo/python-flake-utils";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils, py-utils }:

  utils.lib.eachSystem ["x86_64-linux" "aarch64-darwin"] (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        # overlays = [ self.overlays.default (import rust-overlay) ];
        #  overlays = [ self: super: { rmcgibbo_dot_org = self.callPackage ./.; };
      };
      rmcgibbo_dot_org = pkgs.callPackage ./. {};
    in
    {
      packages.default = rmcgibbo_dot_org;

      devShells.default = pkgs.mkShell rec {
        name = "rmcgibbo.org";
        #shellHook = ''
        #  export PS1="\n(${name}) \[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\[\033[0m\]\n$ "
        #'';
        buildInputs = with pkgs; with python3Packages; [
          isort
          mypy
          pelican
          markdown
        ];
      };
    });
}