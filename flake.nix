{
  description = "faust2sc test";
  inputs = {
    nixpkgs.url =
      "github:olafklingt/nixpkgs/faust";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "mysin";
          src = self;
          buildInputs = with pkgs; [ faust2sc ];
          buildPhase = ''
            	  faust2sc mysin.dsp -o ./ -n 1 -s 
          '';
          installPhase = ''
            mkdir $out
            cp -r HelpSource Classes *.so $out
          '';
        };
        packages.testconfigfile = pkgs.writeScript "config.yaml" builtins.toJSON {
          includePaths = [
            "${self.packages.${system}.default}"
            "${pkgs.supercollider}/share/SuperCollider/SCClassLibrary/"
          ];
          excludePaths = [ ];
          postInlineWarnings = false;
          excludeDefaultPaths = true;
        };
        packages.scd = pkgs.writeScript "run.scd" ''
          	s.waitForBoot{
          		{Mysin.ar*0.1}.play
          	}
          	'';
        packages.test = pkgs.writeShellApplication {
          name = "test";
          runtimeInputs = with pkgs; [ supercollider ];
          text = ''
            SC_PLUGIN_PATH="${self.packages.${system}.default}" \
            QT_QPA_PLATFORM=minimal \
            sclang -a -l \
            "${self.packages.${system}.testconfigfile}" \
            "${self.packages.${system}.scd}"
          '';
        };
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.test}/bin/test";
        };
      });
}
