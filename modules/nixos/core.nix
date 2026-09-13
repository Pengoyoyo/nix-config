{ pkgs, ... }:

{
  # ── Nix selbst ───────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    warn-dirty = false;
    trusted-users = [ "root" "@wheel" ];
  };

  # Alte Generationen wegräumen, sonst läuft /nix/store voll.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  # ── Audio: PipeWire ──────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  # ── Speicher / Performance ───────────────────────────────────────
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # Verhindert, dass das System bei vollem RAM komplett einfriert.
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
  };

  # ── Kleinkram ────────────────────────────────────────────────────
  services.fstrim.enable = true; # SSD
  services.printing.enable = false; # kein Drucker -> spart Closure
  hardware.bluetooth.enable = true; # für Controller; aus wenn unnötig
  hardware.bluetooth.powerOnBoot = false;

  # Weniger Doku im Image (Manpages bleiben).
  documentation.dev.enable = false;
  documentation.info.enable = false;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
    btop
    fastfetch
    unzip
    p7zip
    ripgrep
    fd
    pciutils
    usbutils
  ];

  programs.nh = {
    enable = true; # nh os switch statt nixos-rebuild
    flake = "/etc/nixos";
  };
}
