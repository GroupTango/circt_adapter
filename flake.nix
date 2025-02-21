{
  description = "Flake utils demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
      {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            (python312.withPackages (p: with p; [
              venvShellHook
              psutil

              (buildPythonPackage rec {
                pname = "ai_edge_model_explorer";
                version = "0.1.17";

                src = fetchPypi {
                  inherit pname version;
                  hash = "sha256-NGiqtXfw6tTQvjEYXoCLQQa+mMS10xPdtdvhvz8/jg8=";
                };

                doCheck = true;
                dependencies = [
                  torch flask numpy ipython requests termcolor typing-extensions portpicker packaging


                  (buildPythonPackage rec {
                    pname = "ai_edge_model_explorer_adapter";
                    version = "0.1.5";
                    format = "wheel";

                    src = fetchPypi {
                      inherit version pname;
                      dist = "cp312";
                      python = "cp312";
                      abi = "cp312";
                      platform = "manylinux_2_17_x86_64";
                      format = "wheel";
                      hash = "sha256-hO/yKrRyCNhH/prHnm0Ab+w26yRf96eg7o1SpFUlIvM=";
                    };

                    propagatedBuildInputs = [ ];
                    nativeBuildInputs = [ wheel ];

                    doCheck = true;
                  })
                ];

                pyproject = true;
                build-system = [
                  setuptools
                  wheel
                ];
              })
            ]))
            bashInteractive
            ninja
            cmake
            llvmPackages_latest.llvm
            llvmPackages_latest.bintools
            (vscode-with-extensions.override {
              # vscode = vscodium;
              vscodeExtensions = with vscode-extensions; [
                bbenoist.nix
                ms-python.python
                ms-vscode.cpptools
                ms-vscode.cmake-tools
                vscodevim.vim
              ];
            })
          ];
        };
      }
    );
}
