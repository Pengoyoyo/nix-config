{ pkgs, ... }:

{
  # ── Display-Manager ──────────────────────────────────────────────
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true; # SDDM selbst unter Wayland -> kein X-Server
  };

  # ── Plasma 6 ─────────────────────────────────────────────────────
  services.desktopManager.plasma6 = {
    enable = true;

    # Der größte Einzelhebel: spart die komplette Qt5-Toolchain
    # (mehrere hundert MB). Preis: alte Qt5-Apps erben das
    # Plasma-Theming nicht. Auf true setzen, falls dich das stört.
    enableQt5Integration = false;
  };

  # X11 nur noch als XWayland-Unterbau, kein volles Xorg nötig.
  services.xserver.enable = false;
  services.xserver.excludePackages = [ pkgs.xterm ];

  # ── Ballast raus ─────────────────────────────────────────────────
  # Sollte ein Attribut in deiner nixpkgs-Revision fehlen, einfach
  # die Zeile löschen – das ist kein Drama.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa # Musikplayer
    khelpcenter # Hilfe-Browser
    kate # Editor
    okular # PDF
    gwenview # Bildbetrachter
    kwrited # Wall-Message-Daemon
    oxygen # Altes Theme
    krdp # Remote Desktop
    kinfocenter # Systeminfo-GUI
    discover # Appstore – auf NixOS sinnlos
    plasma-browser-integration
    plasma-workspace-wallpapers # ~200 MB Hintergrundbilder
  ];

  # ── Indexer & Dienste, die im Hintergrund Strom fressen ──────────
  # Baloo lässt sich nicht über excludePackages entfernen (Teil von
  # plasma-workspace), also systemweit per Config abschalten.
  environment.etc."xdg/baloofilerc".text = ''
    [Basic Settings]
    Indexing-Enabled=false
  '';

  # KDE Connect, Akonadi/PIM & Co. bleiben so aus.
  programs.kdeconnect.enable = false;

  # GTK-Apps sollen wenigstens nicht wie 2009 aussehen.
  programs.dconf.enable = true;

  # Portals kommen von Plasma selbst; xdg-desktop-portal-gtk nur
  # dazunehmen, wenn GTK-Filepicker nötig sind.
  xdg.portal.xdgOpenUsePortal = true;

  # Schriften – minimal, aber vollständig.
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      inter
      jetbrains-mono
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Inter" ];
      monospace = [ "JetBrains Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kcalc
    kdePackages.partitionmanager
  ];
}
