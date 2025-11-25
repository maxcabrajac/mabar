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
		perSystem = { pkgs, lib, ... }: let
			buildInternalBins = attrs:
				attrs
				|> lib.mapAttrs' (name: p: { name = "bin/${name}"; value = lib.getExe p; })
				|> pkgs.linkFarm "mabar-internal-bins"
			;
		in rec {
			packages = let
				inherit (pkgs) callPackage;
				callDefaultPackage = lib.flip callPackage <| {};
			in rec {
				mabar = callDefaultPackage (
					{
						quickshell,
						writeShellScriptBin,
						wmInterface ? sampleWmInterface,
					}: let
						internalBins = buildInternalBins {
							inherit wmInterface;
						};
						src = builtins.path {
							path = ./src;
							name = "mabar-quickshell-src";
						};
					in
						writeShellScriptBin "mabar" ''
							export PATH=${internalBins}/bin:$PATH
							exec ${lib.getExe quickshell} -p ${src} "$@"
						''
				);

				sampleWmInterface = callDefaultPackage ({
						writeShellApplication,
						jq,
						coreutils,
					}: writeShellApplication {
						name = "sampleWmInterface";
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
				commands = intoFmt {
					live = {
						help = "Start live reloading";
						command = "qs -p $PRJ_ROOT/src";
					};
				};
				packages = with pkgs; with packages; [
					(buildInternalBins {
						wmInterface = sampleWmInterface;
					})
					sampleWmInterface
					quickshell
					jq
				];
			};
		};
	};
}
