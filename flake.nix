{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #my-repo = {
    #  url = "github:codeandb/My-Apps/";
    #  flake = true;
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    # Please replace my-nixos with your hostname
    nixosConfigurations =  {
      nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      #specialArgs = { inherit my-repo; };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
  	    
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.anderson = import ./home.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
      ];
      };
    };
  };
}
