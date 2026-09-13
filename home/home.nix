{ pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # ── User-Pakete ──────────────────────────────────────────────────
  home.packages = with pkgs; [
    firefox
    kdePackages.kdeconnect-kde # nur falls gewünscht, sonst raus
    ffmpeg
    yt-dlp
    jq
  ];

  # ── Shell ────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 50000;

    shellAliases = {
      ll = "ls -lah";
      rebuild = "nh os switch /etc/nixos";
      update = "nix flake update --flake /etc/nixos";
      gc = "nh clean all";
    };
  };

  programs.starship.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    # HIER ANPASSEN
    userName = "Dein Name";
    userEmail = "du@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # ── Plasma-Feintuning ────────────────────────────────────────────
  # Datei-Indexer aus (doppelt hält besser, überschreibt /etc-Default).
  xdg.configFile."baloofilerc".text = ''
    [Basic Settings]
    Indexing-Enabled=false
  '';

  # MangoHud: dezentes Overlay, per Shift+F12 umschaltbar.
  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      frametime = true;
      gpu_stats = true;
      gpu_temp = true;
      cpu_stats = true;
      cpu_temp = true;
      vram = true;
      ram = true;
      position = "top-left";
      font_size = 20;
      background_alpha = 0.35;
      toggle_hud = "Shift_R+F12";
    };
  };
}
