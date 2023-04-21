{
  description = "mysin";

  inputs = {
    nixpkgs.url = 
	"github:olafklingt/nixpkgs/faust";
#	"github:magnetophon/nixpkgs/faust_QT5";
#	"path:/home/olaf/projects/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
#        "aarch64-linux" # 64-bit ARM Linux
#        "x86_64-darwin" # 64-bit Intel macOS
#        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.stdenv.mkDerivation {
            name = "mysin";
            src = self;
            buildInputs = with pkgs; [faust2supercollider faust];
            buildPhase = ''
	      faust2supercollider -sn mysin.dsp 
	    '';
            installPhase = ''
              mkdir $out
              cp *.sc *.so $out
            '';
          };
      });
    };
}