{
	description = "Mabar";
	inputs = {
		systems.url = "github:nix-systems/default";
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		flake-parts = {
			url = "github:hercules-ci/flake-parts";
			inputs.nixpkgs-lib.follows = "nixpkgs";
		};

		devshell.url = "github:numtide/devshell";
	};
	outputs = { flake-parts, self, ... } @ inputs: flake-parts.lib.mkFlake { inherit inputs; } {
		imports = [
			inputs.devshell.flakeModule
		];
		systems = import inputs.systems;
		perSystem = { pkgs, lib, ... }: {
			devshells.default = let
				intoFmt = x:
					x
					|> lib.mapAttrs (name: val: val // { inherit name; })
					|> lib.attrValues
				;
			in {
				env = intoFmt {
				};
				commands = intoFmt {
					live = {
						help = "Start live reloading";
						command = "qs -p $PRJ_ROOT/src";
					};
				};
				packages = with pkgs; [
					quickshell
				];
			};
		};
	};
}
