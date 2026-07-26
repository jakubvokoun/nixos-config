{
  description = "NixOS + home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    # Deliberately not `follows`-ing nixpkgs: nixvim pins the revision its
    # plugin set was tested against, and overriding it only produces a warning
    # and untested combinations.
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # Shared config + VM-guest overrides + home-manager; system/hosts/<name>/
      # adds what is specific to the machine. `work` pulls in home/work.nix.
      mkHost =
        {
          name,
          work ? true,
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./system/common.nix
            ./system/vm-guest.nix
            ./system/hosts/${name}
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.jakub.imports = [
                  ./home/home.nix
                ]
                ++ nixpkgs.lib.optional work ./home/work.nix;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        # ThinkPad E14 Gen 3.
        e14 = mkHost { name = "e14"; };
        # ThinkPad T440.
        t440 = mkHost {
          name = "t440";
          work = false;
        };
        # Hardware-free host for testing; builds on any x86_64 machine.
        vm = mkHost { name = "vm"; };
      };
    };
}
