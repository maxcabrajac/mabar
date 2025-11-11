{
	description = "Mabar";
	inputs = {
		systems.url = "github:nix-systems/default";
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		flake-parts = {
			url = "github:hercules-ci/flake-parts";
			inputs.nixpkgs-lib.follows = "nixpkgs";
		};

		devshell = {
			url = "github:numtide/devshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = { flake-parts, self, ... } @ inputs: flake-parts.lib.mkFlake { inherit inputs; } {
		imports = [
			inputs.devshell.flakeModule
		];
		systems = import inputs.systems;
		perSystem = { pkgs, lib, ... }: rec {

			packages = let
				inherit (pkgs) callPackage;
				callDefaultPackage = lib.flip callPackage <| {};
			in rec {
				mabar = callDefaultPackage (
					{
						quickshell,
						linkFarm,
						writeShellScriptBin,
						wmInterface ? sampleWmInteraface,
					}: let
						internalBins = {
							inherit wmInterface;
						} |> lib.mapAttrs (_: p: lib.getExe p) |> linkFarm "mabar-internal-bins";
					in
						writeShellScriptBin "mabar" ''
							export PATH=${internalBins}:$PATH
							exec ${lib.getExe quickshell} -p ${./src} "$@"
						''
				);

				sampleWmInteraface = callDefaultPackage ({
						writeShellApplication,
						jq,
						coreutils,
					}: writeShellApplication {
						name = "sampleWmDumper";
						text = builtins.readFile ./scripts/wmInterface/sample.bash;
						inheritPath = false;
						runtimeInputs = [
							jq
							coreutils
						];
					}
				);
			};

			devshells.default = let
				intoFmt = x:
					x
					|> lib.mapAttrs (name: val: val // { inherit name; })
					|> lib.attrValues
				;
			in {
				env = intoFmt {
					PATH.prefix = "${packages.mabar}/internalBins";
				};
				commands = intoFmt {
					live = {
						help = "Start live reloading";
						command = "qs -p $PRJ_ROOT/src";
					};
				};
				packages = with pkgs; [
					quickshell
					jq
				];
			};
		};
	};
}
