{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    myrepo = {
      url = "github:codeandb/My-Apps/";
    #  flake = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = inputs@{ nixpkgs, home-manager, self, hyprland, hyprland-plugins, nix-minecraft, ... }: {
    # Please replace my-nixos with your hostname
    nixosConfigurations =  {
      nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
	      nix-minecraft.nixosModules.minecraft-servers
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.anderson = import ./home.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
	    home-manager.extraSpecialArgs = {inherit inputs;};
          }
        ({
        nixpkgs.overlays = [
          (final: prev: {
            myrepo = inputs.myrepo.packages."${prev.system}";
          })
          inputs.nix-minecraft.overlay
        ];
        })
        inputs.stylix.nixosModules.stylix
      ];
      };
    };
  };
}
