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
		perSystem = { pkgs, lib, ... }: rec {

			packages = let
				inherit (pkgs) callPackage;
				callDefaultPackage = lib.flip callPackage <| {};
			in rec {
				mabar = callDefaultPackage (
					{
						bash,
						quickshell,
						stdenv,
						wmInterface ? sampleWmInteraface,
					}: stdenv.mkDerivation rec {
						pname = "mabar";
						version = "0.1";
						src = ./src;
						phases = [ "installPhase" ];
						meta.mainProgram = "mabar";
						installPhase = let
							internalBins = {
								inherit wmInterface;
							};
							linkInternalBins = internalBins
								|> lib.mapAttrs (name: pack: /* bash */ "ln -s ${lib.getExe pack} $out/internalBins/${name}")
								|> lib.attrValues
								|> lib.concatLines
							;
						in  /* bash */ ''
							mkdir -p $out
							cp -r ${src} $out/quickshell

							mkdir -p $out/internalBins
							${linkInternalBins}

							mkdir -p $out/bin
							cat <<- EOF > $out/bin/mabar
							#!${lib.getExe bash}
							export PATH="$out/internalBins:$PATH"
							exec ${lib.getExe quickshell} -p $out/quickshell "\$@"
							EOF
							chmod +x $out/bin/mabar
						'';
					}
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
