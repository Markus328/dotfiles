{
  pkgs,
  bubblewrap ? false,
  ...
}:
with pkgs; let
  version = "1.0.31";
  iso_name = "vtoyboot-${version}.iso";
  base_url = "https://github.com/ventoy/vtoyboot/releases/download/v${version}/${iso_name}";

  vtoyboot = stdenv.mkDerivation rec {
    pname = "vtoyboot";
    inherit version;
    src = fetchurl {
      url = base_url;
      hash = "sha256-r2qzZ3q4oDtQfeh1cEtXTTGgtEEYT0HK49QnHFK11PI=";
    };

    nativeBuildInputs = [p7zip];
    # phases = ["unpackPhase" "installPhase"];
    unpackPhase = ''
      7z x ${src}
      tar zxf vtoyboot*
      rm *.gz
    '';
    installPhase = ''
      cd vtoyboot*

      mkdir -p $out/bin

      install -Dm 755 tools/vtoydump64 $out/bin/vtoydump
      install -Dm 755 tools/vtoypartx64 $out/bin/vtoypartx
      install -Dm 755 tools/vtoytool_64 $out/bin/vtoytool

      cat tools/vtoydump64 tools/dm_patch_64.ko > vtoydmpatch
      install -Dm 755 vtoydmpatch $out/bin/vtoydmpatch

      install -Dm 755 tools/vtoydrivers $out/bin/vtoydrivers

      install -Dm 755 distros/mkinitcpio/ventoy-hook.sh $out/bin/ventoy-setup
      # echo "export PATH=$PATH:$out/bin:/sbin:/bin" >> $out/bin/ventoy-setup
      echo "run_hook" >> $out/bin/ventoy-setup

    '';

    postFixup = ''
      for bin in vtoydump vtoypartx; do
      patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 "$out/bin/$bin"
      patchelf --set-rpath ${pkgs.glibc}/lib "$out/bin/$bin"
      done
    '';
  };
in
  if bubblewrap
  then
    buildFHSEnv {
      name = "vtoyboot-fhs";
      targetPkgs = pkgs: (with pkgs; [
        vtoyboot
      ]);
      runScript = "bash";
    }
  else vtoyboot
