{
  outputs = inputs: let
    inherit (inputs) self nixpkgs;

    forEachSystem = let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      genPkgs = system:
        nixpkgs.legacyPackages.${system};
      inherit (nixpkgs.lib) genAttrs;
    in f: genAttrs systems (system: f (genPkgs system));
  in {
    devShells = forEachSystem (pkgs:
      {
        default = pkgs.mkShell {
          LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib/";
          packages = with pkgs; [
            buildbox
            buildstream
            lzip
          ] ++ (with pkgs.python3Packages; [
            dulwich
            packaging
            pip
            requests
            tomlkit
            tox
          ]);
        };
      }
    );
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };
}
