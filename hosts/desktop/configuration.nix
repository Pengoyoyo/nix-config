{ pkgs, username, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/core.nix
    ../../modules/nixos/amd.nix
    ../../modules/nixos/plasma-lite.nix
    ../../modules/nixos/gaming.nix
  ];

  # ── Boot: GRUB im UEFI-Modus, Dual-Boot mit Windows ──────────────
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # Falls deine ESP woanders liegt (z.B. /boot/efi) hier ändern.
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev"; # bei EFI immer "nodev"
      useOSProber = true; # findet den Windows-Bootloader
      configurationLimit = 15; # nicht 200 Generationen im Menü
      gfxmodeEfi = "auto";
    };

    timeout = 5;
  };

  # Windows nutzt lokale Zeit in der RTC -> sonst springt die Uhr.
  time.hardwareClockInLocalTime = true;

  # Gaming-Kernel. Alternativ: pkgs.linuxPackages_latest
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Leiser Boot
  boot.plymouth.enable = true;
  boot.kernelParams = [ "quiet" "splash" ];

  # ── Netzwerk ─────────────────────────────────────────────────────
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # ── Locale / Zeit ────────────────────────────────────────────────
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  console.keyMap = "de";
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # ── User ─────────────────────────────────────────────────────────
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "gamemode"
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # Nicht anfassen nach der Installation.
  system.stateVersion = "26.05";
}
