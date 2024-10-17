{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = {
        pkgs,
        lib,
        self',
        ...
      }: {
        packages = let
          compileBin = src: name:
            pkgs.stdenv.mkDerivation {
              inherit name src;

              buildPhase = ''
                make ${name}
              '';

              installPhase = ''
                mkdir -p $out/bin
                install -Dm744 ${name} $out/bin
              '';
            };
        in
          (lib.genAttrs [
            "rs41mod"
            "dfm09mod"
            "m10mod"
            "m20mod"
            "rs92mod"
            "lms6Xmod"
            "meisei100mod"
            "imet54mod"
            "mp3h1mod"
            "mts01mod"
            "iq_dec"
          ] (name: compileBin ./demod/mod name))
          // {
            weathex301d = compileBin ./weathex "weathex301d";
            mk2a1680 = compileBin ./mk2a "mk2a1680mod";
            imet4iq = compileBin ./imet "imet4iq";
            fsk_demod = compileBin ./utils "fsk_demod";
            dft_detect = compileBin ./scan "dft_detect";
          };

        checks = self'.packages;
      };
    };
}
