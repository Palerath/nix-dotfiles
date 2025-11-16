{
    description = "Multi-host NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        flake-parts.url = "github:hercules-ci/flake-parts";

        nvf = {
            url = "github:notashelf/nvf";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs @ { self, flake-parts, nixpkgs, home-manager, ... }:
        flake-parts.lib.mkFlake { inherit inputs; } {
            systems = [ "x86_64-linux" ];

            flake = {
                # User configurations
                userConfigs = {
                    perihelie = import (self + /users/perihelie/home.nix);
                };

                # Helper function to create host configurations
                lib.mkHost = { hostName, system ? "x86_64-linux" }: 
                    nixpkgs.lib.nixosSystem {
                        inherit system;
                        specialArgs = {
                            inherit inputs;
                            inherit hostName;
                            userConfigs = self.userConfigs;
                        };
                        modules = [
                            home-manager.nixosModules.home-manager
                            {
                                _module.args = { inherit inputs; };
                                home-manager.extraSpecialArgs = { inherit inputs hostName; };
                            }
                            (self + /hosts/${hostName}/hardware-configuration.nix)
                            (self + /hosts/${hostName}/configuration.nix)
                            # Optionally add common modules
                            self.nixosModules.common
                        ];
                    };

                # Define each host using the helper
                nixosConfigurations = {
                    perikon = self.lib.mkHost { hostName = "perikon"; };
                    latitude = self.lib.mkHost { hostName = "latitude"; };
                };

                # Common modules
                nixosModules = {
                    common = import (self + /common);
                };
            };

            perSystem = { pkgs, ... }: {
                devShells = {
                    # Default shell with NixOS rebuild tools
                    default = pkgs.mkShell {
                        buildInputs = with pkgs; [
                            git
                            nh
                            nixos-rebuild
                        ];
                        shellHook = ''
                            echo "NixOS development environment loaded"
                            echo "Tools: nh, nixos-rebuild, git"
                            '';
                    };

                    # AI coding shell
                    ai = pkgs.mkShell {
                        buildInputs = with pkgs; [
                            aider-chat
                            llm
                            ollama
                            python313
                            git  # Aider needs git
                            fish
                        ];

                        shellHook = ''
                            echo "AI coding environment loaded"
                            echo "---"
                            export OLLAMA_API_BASE=http://localhost:11434
                            # Check if ollama is already running
                            if ! pgrep -x ollama > /dev/null; then
                            echo "Starting Ollama server..."
                            ollama serve > /tmp/ollama.log 2>&1 &
                            echo $! > /tmp/ollama.pid
                            sleep 2  # Give it time to start
                            fi 
                            echo ""
                            echo "Aider: $(aider --version 2>/dev/null || echo 'available')"
                            echo "LLM: $(llm --version 2>/dev/null || echo 'available')"
                            echo "Quick start:"
                            echo "  ollama serve                                            # Start Ollama server"
                            echo "  ollama pull qwen2.5-coder:7b                            # Download a model"
                            echo "  aider --model ollama/qwen2.5-coder:7b --subtree-only    # Start aider"
                            '';
                    };
                };
            };
        };
}
