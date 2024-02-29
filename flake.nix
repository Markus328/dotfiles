{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    t64gram = {
      url = "github:Markus328/64gram-desktop-bin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    osu-nixos = {
      url = "github:notgne2/osu-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      overlays = [
        inputs.nixGL.overlay
        inputs.t64gram.overlay
        inputs.osu-nixos.overlay
        inputs.hyprlock.overlays.default
        inputs.hypridle.overlays.default
      ];
      config = import ./nixos/nixpkgs/config.nix;
    };
  in {
    defaultPackage.x86_64-linux = inputs.home-manager.defaultPackage.x86_64-linux;

    nixosConfigurations.nixos-desktop = inputs.nixpkgs.lib.nixosSystem {
      # inherit pkgs;
      modules = [
        # inputs.hyprland.nixosModules.default
        ./nixos/configuration.nix
      ];
      specialArgs = {inherit inputs;};
    };
    scripts = import ./scripts/scripts.nix {
      inherit pkgs;
      scriptsPath = ./scripts;
    };
    homeConfigurations = let
      prefix = ./nixos/home-manager;
      getHmPaths = paths:
        if builtins.typeOf paths == "list"
        then (pkgs.lib.lists.concatMap (x: [(pkgs.lib.path.append prefix x)]) paths)
        else pkgs.lib.path.append prefix paths;

      baseModules = getHmPaths ["modules/flatpak-themes.nix"];

      users = ["markus" "talita"];
      hosts = ["arch-desktop" "nixos-desktop"];

      maybeUserConfig = user: host: let
        personalized_config = getHmPaths "${user}/${host}.nix";
        host_config = getHmPaths "${host}.nix";
        user_config = getHmPaths "${user}/home.nix";
      in
        if builtins.pathExists user_config
        then
          (
            if builtins.pathExists personalized_config
            then personalized_config
            else user_config
          )
        else if builtins.pathExists host_config
        then host_config
        else getHmPaths "home.nix";

      # for raw home-manager configurations
      mkHome = username: host: {
        "${username}@${host}" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          # Specify the path to your home configuration here
          # configuration = import (maybeUserConfig username host) {
          #   inherit inputs pkgs;
          # };

          modules = baseModules ++ [(maybeUserConfig username host)];
          extraSpecialArgs = {
            inherit (inputs) self;
            inherit (inputs.self) scripts;
            inherit username host;
          };
          # extraModules = [ ./home/standalone.nix ];
        };
      };
    in
      pkgs.lib.foldr (a: b: a // b) {} (pkgs.lib.concatMap (user: (pkgs.lib.concatMap (host: [(mkHome user host)]) hosts)) users);
    # "markus@arch-desktop" = inputs.home-manager.lib.homeManagerConfiguration {
    #   inherit pkgs;
    #   extraSpecialArgs = {scripts = scripts;};
    #   modules = baseModules ++ (getHmPaths ["markus/home.nix" "modules/archConfig.nix"]);
    # };
    # "markus@nixos-desktop" = inputs.home-manager.lib.homeManagerConfiguration {
    #   inherit pkgs;
    #   extraSpecialArgs = {scripts = scripts;};
    #   modules = baseModules ++ (getHmPaths ["markus/home.nix" "modules/nixosConfig.nix"]);
    # };
    # "talita@arch-desktop" = inputs.home-manager.lib.homeManagerConfiguration {
    #   inherit pkgs;
    #   modules = baseModules ++ [inputs.plasma-manager.homeManagerModules.plasma-manager] ++ (getHmPaths ["guest/home.nix" "modules/archConfig.nix"]);
    # };
    # "talita@nixos-desktop" = inputs.home-manager.lib.homeManagerConfiguration {
    #   inherit pkgs;
    #   modules = baseModules ++ [inputs.plasma-manager.homeManagerModules.plasma-manager] ++ (getHmPaths ["guest/home.nix" "modules/nixosConfig.nix"]);
    # };
  };
}
