{
  config,
  pkgs,
  username,
  host,
  ...
}: {
  home.packages = with pkgs; [
    t64gram
  ];

  programs.plasma = {
    enable = true;

    configFile = {
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kdeglobals"."General"."BrowserApplication" = "firefox.desktop";
      "kdeglobals"."General"."TerminalApplication" = "foot";
      "kdeglobals"."General"."TerminalService" = "foot.desktop";
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Name";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = false;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 138;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
      "kdeglobals"."WM"."activeBackground" = "47,52,63";
      "kdeglobals"."WM"."activeBlend" = "47,52,63";
      "kdeglobals"."WM"."activeForeground" = "211,218,227";
      "kdeglobals"."WM"."inactiveBackground" = "47,52,63";
      "kdeglobals"."WM"."inactiveBlend" = "47,52,63";
      "kdeglobals"."WM"."inactiveForeground" = "102,106,115";

      "plasma-localerc"."Formats"."LANG" = "pt_BR.UTF-8";
      "plasma-localerc"."Translations"."LANGUAGE" = "pt_BR";
      "plasmarc"."Theme"."name" = "Dracula";
      "plasmarc"."Wallpapers"."usersWallpapers" = "/home/talita/Downloads/80d8a8495f2b9a85cbd98caecb0be726.jpg,/home/talita/Downloads/b24bbce7e3116bf4f293ca225dd5db30.jpg";
    };
  };
}
