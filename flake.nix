{
  description = "LaTeX C.V. / Resume";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;
    flake-utils.url = github:numtide/flake-utils;
    src-data.url = "path:./src/resume.yaml";
    src-data.flake = false;
  };
  outputs = { self, nixpkgs, flake-utils, src-data }:
    with flake-utils.lib; eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-full latex-bin latexmk
        fontspec fontawesome5;
      };
      srcYaml = src-data.outPath;
      gitCommit = if (self ? shortRev) then self.shortRev
            else if (self ? dirtyShortRev) then self.dirtyShortRev
            else "";
    in rec {
      packages = {
        resume = pkgs.stdenvNoCC.mkDerivation rec {
          name = "cvac";
          src = self;
          propagatedBuildInputs = [ pkgs.coreutils pkgs.git pkgs.roboto tex pkgs.python3Packages.pyyaml pkgs.python3Packages.jinja2 ];
          phases = ["unpackPhase" "buildPhase" "installPhase"];
          SCRIPT = ''
            #!/usr/bin/env bash
            prefix=${builtins.placeholder "out"}
            export PATH="${pkgs.lib.makeBinPath propagatedBuildInputs}";
            DIR=$(mktemp -d)
            BASENAME=$(basename -s .yaml ${srcYaml})
            RES=$(pwd)/$BASENAME.pdf
            cd $prefix/share
            mkdir -p "$DIR/.texcache/texmf-var"
            env TEXMFHOME="$DIR/.cache" \
              TEXMFVAR="$DIR/.cache/texmf-var" \
              OSFONTDIR=${pkgs.roboto}/share/fonts \
              SOURCE_DATE_EPOCH=${toString self.lastModified} \
              latexmk -interaction=nonstopmode -pdf -lualatex \
              -output-directory="$DIR" \
              -pretex="\pdfvariable suppressoptionalinfo 512\relax\\def\\githash{${gitCommit}}" \
              -usepretex $BASENAME.tex
            mv "$DIR/$BASENAME.pdf" $RES
            rm -rf "$DIR"
          '';
          buildPhase = ''
            printenv SCRIPT >cvac
            python3 scripts/render.py ${srcYaml}
          '';
          installPhase = ''
            mkdir -p $out/{bin,share}
            BASENAME=$(basename -s .yaml ${srcYaml})
            mv $BASENAME.tex $out/share/
            cp src/resume.cls $out/share/resume.cls
            cp cvac $out/bin/cvac
            chmod u+x $out/bin/cvac
          '';
        };
      };
      devShells.default = pkgs.mkShell {
        name = "cvac";
        packages = with pkgs; [
          git-crypt
          python3
          python3Packages.pyyaml
          python3Packages.jinja2
          roboto
          texliveFull
        ];
      };
      defaultPackage = packages.resume;
    });
}
