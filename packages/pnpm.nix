{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  installShellFiles,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pnpm";
  version = "12.8.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/@pnpm/exe.darwin-arm64/-/exe.darwin-arm64-${finalAttrs.version}.tgz";
    hash = "sha256-XQm0TyZwHSA4JsZCICNkpHzlF+YhUmLE2sVK9Rza6I4=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 pnpm "$out/bin/pnpm"
    ln -s pnpm "$out/bin/pn"
    makeWrapper "$out/bin/pnpm" "$out/bin/pnpx" --add-flags dlx
    ln -s pnpx "$out/bin/pnx"

    "$out/bin/pnpm" completion bash > pnpm.bash
    "$out/bin/pnpm" completion fish > pnpm.fish
    "$out/bin/pnpm" completion zsh > pnpm.zsh
    sed -i '1 i#compdef pnpm' pnpm.zsh
    installShellCompletion pnpm.{bash,fish,zsh}
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    test "$("$out/bin/pnpm" --version)" = "${finalAttrs.version}"
    "$out/bin/pnpx" --help > /dev/null
  '';

  meta = {
    description = "Fast, disk space efficient package manager for JavaScript";
    homepage = "https://pnpm.io/";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "pnpm";
  };
})
