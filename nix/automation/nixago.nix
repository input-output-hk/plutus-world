{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs data-merge;
  inherit (inputs.std) std;
in {
  treefmt = std.nixago.treefmt {
    configData = {};
    packages = [];
  };
  editorconfig = std.nixago.editorconfig {
    configData = {};
  };
  mdbook = std.nixago.mdbook {
    packages = [nixpkgs.mdbook-mermaid];
    configData = {
      book.autors = ["The Plutus Authors"];
      book.title = "The Plutus Book";
      preprocessor.mermaid.command = "mdbook-mermaid";
      output.html = {
        git-repository-url = "https://github.com/input-output-hk/plutus-world";
        git-repository-icon = "fa-github";
        edit-url-template = "https://github.com/input-output-hk/plutus-world/edit/main/src/{path}";
        additional-js = [
          "static/js/mermaid.min.js"
          "static/js/mermaid-init.js"
        ];
      };
    };
  };
}
