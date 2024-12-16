{
  pkgs,
  touchpadctl,
}: let
  rule = ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{ID_MODEL}=="USB_OPTICAL_MOUSE",RUN+="${pkgs.su} -c '${pkgs.systemd}/bin/systemctl start touchpadctl@disable'"
    ACTION=="remove",SUBSYSTEM=="input", ENV{ID_MODEL}=="USB_OPTICAL_MOUSE",RUN+="${pkgs.su} -c '${pkgs.systemd}/bin/systemctl start touchpadctl@enable'"
  '';
in
  pkgs.runCommand "touchpad-autodisable" {} ''
    mkdir -p $out/lib/udev/rules.d/
    echo '${rule}' > $out/lib/udev/rules.d/999-touchpad.rules
  ''
