{
  pkgs,
  script,
  deps ? [],
  ...
}: let
  name = builtins.baseNameOf script;
in
  pkgs.runCommand name {
    buildInputs = deps;
  } ''
    mkdir -p $out/bin
    cp ${script} $out/bin/${name}
    sed -i "2 i export PATH=$PATH:\$PATH" $out/bin/${name}
  ''
