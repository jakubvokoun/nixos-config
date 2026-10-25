# NVIDIA OpenShell 0.1.x from the upstream release binaries.
#
# nixpkgs ships 0.0.x (embedded k3s gateway, broken on rootless Podman). 0.1.x
# splits the CLI (`openshell`, static musl) from the gateway
# (`openshell-gateway`, glibc), which drives rootless Podman directly. The
# supervisor/sandbox binaries are not installed: the gateway pulls them as
# version-pinned images from ghcr.io/nvidia/openshell/.
#
# Bump: change `version`, then
#   nix store prefetch-file --json <url> | jq -r .hash
# for each asset in `assets`.
{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  glibc,
}:

let
  version = "0.1.5";
  base = "https://github.com/NVIDIA/OpenShell/releases/download/v${version}";
  assets = {
    cli = fetchurl {
      url = "${base}/openshell-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-yhrW5vu0ps1AfpV2M5G47P8CkS59nEZ+fKImlv6Ar2k=";
    };
    gateway = fetchurl {
      url = "${base}/openshell-gateway-x86_64-unknown-linux-gnu.tar.gz";
      hash = "sha256-btamr/QgxlJQCCzB20jcYnGm9e7A4AaBM1Zv+uSqeIs=";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "openshell";
  inherit version;

  srcs = [
    assets.cli
    assets.gateway
  ];
  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
  ];
  # The gateway links only against glibc (libc, libm, libdl, librt, libpthread).
  buildInputs = [ glibc ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 openshell openshell-gateway -t $out/bin
    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd openshell \
      --bash <($out/bin/openshell completions bash) \
      --zsh <($out/bin/openshell completions zsh) \
      --fish <($out/bin/openshell completions fish)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/openshell --version | grep -F ${version}
    $out/bin/openshell-gateway --help >/dev/null
  '';

  meta = {
    description = "Sandboxed runtime for autonomous AI agents (CLI + gateway)";
    homepage = "https://github.com/NVIDIA/OpenShell";
    changelog = "https://github.com/NVIDIA/OpenShell/releases/tag/v${version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "openshell";
  };
}
