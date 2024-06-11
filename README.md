# CV-as-Code

## Nix Flake

The Nix Flake will build a script which will render the LaTeX template to a PDF.

### Build the script and `tex` file

```sh
srcYaml=src/resume.yaml nix build --impure
```

### Render the document to PDF

```sh
srcYaml=src/resume.yaml nix run --impure
```

## `git-crypt`

I've included my personal data in `src/matt_thornback-resume.yaml`, encrypted using `git-crypt`. To use this as a source:

```sh
git-crypt unlock </path/to/crypt.key>
srcYaml=src/matt_thornback-resume.yaml nix build --impure
srcYaml=src/matt_thornback-resume.yaml nix run --impure
```
