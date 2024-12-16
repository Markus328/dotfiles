{
  pkgs,
  script,
  deps ? [],
  ...
}: let
  name = builtins.baseNameOf script;
  fixShebang = pkgs.writeShellScript "fix-shebang" ''

    if [ "$#" -ne 1 ]; then
        exit 1
    fi

    SCRIPT_FILE="$1"

    if [ ! -f "$SCRIPT_FILE" ]; then
        exit 1
    fi

    # Use sed to fix the shebang
    sed -i '1s|^#!.*|#!${pkgs.bash}/bin/bash|' "$SCRIPT_FILE"

    # If the file did not have a shebang, add the correct one
    if ! head -n 1 "$SCRIPT_FILE" | grep -q '^#!'; then
        sed -i '1s|^|#!${pkgs.bash}/bin/bash\n|' "$SCRIPT_FILE"
    fi
  '';
in
  pkgs.runCommand name {
    buildInputs = deps;
  } ''
    mkdir -p $out/bin
    cp ${script} $out/bin/${name}
    ${fixShebang} $out/bin/${name}
    sed -i "2 i export PATH=$PATH:\$PATH" $out/bin/${name}
  ''
