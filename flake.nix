{
  description = "LaTeX C.V. / Resume";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-full latex-bin latexmk
        fontspec fontawesome5;
      };
    in rec {
      packages = {
        resume = pkgs.stdenvNoCC.mkDerivation rec {
          name = "latex-resume";
          src = self;
          propagatedBuildInputs = [ pkgs.coreutils pkgs.roboto tex pkgs.python3Packages.pyyaml pkgs.python3Packages.jinja2 ];
          phases = ["unpackPhase" "buildPhase" "installPhase"];
          SCRIPT = ''
            #!/usr/bin/env bash
            prefix=${builtins.placeholder "out"}
            export PATH="${pkgs.lib.makeBinPath propagatedBuildInputs}";
            DIR=$(mktemp -d)
            RES=$(pwd)/resume.pdf
            cd $prefix/share
            mkdir -p "$DIR/.texcache/texmf-var"
            env TEXMFHOME="$DIR/.cache" \
              TEXMFVAR="$DIR/.cache/texmf-var" \
              OSFONTDIR=${pkgs.roboto}/share/fonts \
              SOURCE_DATE_EPOCH=${toString self.lastModified} \
              latexmk -interaction=nonstopmode -pdf -lualatex \
              -output-directory="$DIR" \
              -pretex="\pdfvariable suppressoptionalinfo 512\relax" \
              -usepretex resume.tex
            mv "$DIR/resume.pdf" $RES
            rm -rf "$DIR"
          '';
          buildPhase = ''
            printenv SCRIPT >latex-resume
            python3 scripts/render.py src/resume.yaml
          '';
          installPhase = ''
            mkdir -p $out/{bin,share}
            mv resume.tex $out/share/resume.tex
            cp src/resume.cls $out/share/resume.cls
            cp latex-resume $out/bin/latex-resume
            chmod u+x $out/bin/latex-resume
          '';
        };
      };
      devShells.default = pkgs.mkShell {
        name = "cvac";
        packages = with pkgs; [
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
