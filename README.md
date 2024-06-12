# CV-as-Code

## Nix Flake

The Nix Flake will build a script which will render the LaTeX template to a PDF.

### Build the script and `tex` file

```sh
nix build --override-input src-data path:../cvac-data/matt_thornback.yaml
```

### Render the document to PDF

```sh
nix run --override-input src-data path:../cvac-data/matt_thornback.yaml
```
