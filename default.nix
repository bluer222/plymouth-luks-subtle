{
  lib,
  stdenvNoCC,
  nixos-icons,
  plymouth,
  bgrtX ? 576,
  bgrtY ? 242,
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-theme-nix-flake";
  version = "1.0.0";

  src = lib.cleanSource ./.;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    themeDir=$out/share/plymouth/themes/nix-flake
    mkdir -p "$themeDir"

    cp nix-flake.plymouth nix-flake.script "$themeDir"

    ln -s /sys/firmware/acpi/bgrt/image "$themeDir/bgrt-image"

    spinner=${plymouth}/share/plymouth/themes/spinner
    ln -s "$spinner"/throbber-*.png "$themeDir/"

    icons=${nixos-icons}/share/icons/hicolor/48x48/apps
    ln -s "$icons/nix-snowflake-white.png" "$themeDir/nix-snowflake-white.png"
    ln -s "$icons/nix-snowflake.png" "$themeDir/nix-snowflake.png"

    substituteInPlace "$themeDir/nix-flake.plymouth" \
      --replace-fail '@THEME_DIR@' "$themeDir"
    substituteInPlace "$themeDir/nix-flake.script" \
      --replace-fail '@BGRT_X@' '${toString bgrtX}' \
      --replace-fail '@BGRT_Y@' '${toString bgrtY}'

    runHook postInstall
  '';

  meta = {
    description = "BGRT-layout Plymouth theme with a silent colored-flake LUKS prompt";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
