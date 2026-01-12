{ pkgs, ... }:
let
  apps = {
    "text/markdown" = "nvim.desktop";
    "text/plain" = "nvim.desktop";
    "text/x-shellscript" = "nvim.desktop";
    "text/x-python" = "nvim.desktop";
    "text/x-go" = "nvim.desktop";
    "text/css" = "nvim.desktop";
    "text/javascript" = "nvim.desktop";
    "text/x-c" = "nvim.desktop";
    "text/x-c++" = "nvim.desktop";
    "text/x-java" = "nvim.desktop";
    "text/x-rust" = "nvim.desktop";
    "text/x-yaml" = "nvim.desktop";
    "text/x-toml" = "nvim.desktop";
    "text/x-dockerfile" = "nvim.desktop";
    "text/x-xml" = "nvim.desktop";
    "text/x-php" = "nvim.desktop";
    "image/jpeg" = "nomacs.desktop";
    "image/jpg" = "nomacs.desktop";
    "image/webp" = "nomacs.desktop";
    "image/png" = "nomacs.desktop";
    "image/gif" = "nomacs.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "text/html" = "brave-browser.desktop";
    "application/pdf" = "zathura.desktop";
    "x-scheme-handler/chrome" = "brave-browser.desktop";
    "application/x-extension-htm" = "brave-browser.desktop";
    "application/x-extension-html" = "brave-browser.desktop";
    "application/x-extension-shtml" = "brave-browser.desktop";
    "application/xhtml+xml" = "brave-browser.desktop";
    "application/x-extension-xhtml" = "brave-browser.desktop";
    "application/x-extension-xht" = "brave-browser.desktop";
  };
  createEntry = appName: {
    name = appName;
    exec = "${pkgs.${appName}}/bin/${appName}";
    noDisplay = true;
  };
in {
  xdg = {
    enable = true;
    mime.enable = true;
    desktopEntries = {
      zathura = createEntry "zathura";
      nomacs = createEntry "nomacs";
    };
    mimeApps = {
      enable = true;
      defaultApplications = apps;
      associations.added = apps;
    };
  };
}
