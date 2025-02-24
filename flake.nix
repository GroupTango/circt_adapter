{
  description = "Flake utils demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
      {
        devShell = pkgs.mkShell {
          shellHook = ''
            export CYPRESS_INSTALL_BINARY=0
            export CYPRESS_RUN_BINARY=${pkgs.cypress}/bin/Cypress
          '';
          packages = with pkgs;
          [
            # uv
            # python312
            # (poetry.override { python3 = python312; })
            nodejs_22
            cypress
            (python312.withPackages (p: with p;
              let
                # nanobind = buildPythonPackage rec {
                #   pname = "nanobind";
                #   version = "2.4.0";
                #   pyproject = true;

                #   src = fetchFromGitHub {
                #     owner = "wjakob";
                #     repo = "nanobind";
                #     rev = "refs/tags/v${version}";
                #     # tag = "v${version}";
                #     hash = "sha256-9OpDsjFEeJGtbti4Q9HHl78XaGf8M3lG4ukvHCMzyMU=";
                #     fetchSubmodules = true;
                #   };

                #   build-system = [
                #     cmake
                #     ninja
                #     pathspec
                #     wheel
                #     scikit-build-core
                #   ];

                #   dependencies = [ eigen ];

                #   dontUseCmakeBuildDir = true;

                #   preCheck = ''
                #     # TODO: added 2.2.0, re-enable on next bump
                #     # https://github.com/wjakob/nanobind/issues/754
                #     # "generated stubs do not match their references"
                #     # > -import tensorflow.python.framework.ops
                #     # > +import tensorflow
                #     rm tests/test_ndarray_ext.pyi.ref

                #     # build tests
                #     make -j $NIX_BUILD_CORES
                #   '';

                #   nativeCheckInputs =
                #     [
                #       pytestCheckHook
                #       numpy
                #       scipy
                #       torch
                #       scikit-build-core
                #       # tensorflow-bin
                #       jax
                #       jaxlib
                #     ];
                # };
                base-deps = [
                  torch flask numpy ipython requests termcolor typing-extensions portpicker packaging ml-dtypes # nanobind
                ];
                adapter = buildPythonPackage rec {
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
                };
                model-explorer = buildPythonPackage rec {
                  pname = "ai_edge_model_explorer";
                  version = "0.1.17";

                  src = fetchPypi {
                    inherit pname version;
                    hash = "sha256-NGiqtXfw6tTQvjEYXoCLQQa+mMS10xPdtdvhvz8/jg8=";
                  };

                  doCheck = true;
                  dependencies = base-deps ++ [adapter];

                  pyproject = true;
                  build-system = [
                    setuptools
                    wheel
                  ];
                };
                dependencies = base-deps ++ [adapter model-explorer]; in
            [
              venvShellHook
              psutil
              adapter
              model-explorer
              pip

              # (buildPythonPackage rec {
              #   pname = "circt-adapter";
              #   version = "0.0.1";
              #   src = ./.;
              #   pyproject = true;
              #   build-system = [
              #     setuptools
              #     wheel
              #   ];
              #   inherit dependencies;
              # })

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
