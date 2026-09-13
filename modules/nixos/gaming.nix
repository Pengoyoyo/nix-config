{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = false;

    # Steam-Session direkt aus SDDM startbar (Konsolen-Modus).
    gamescopeSession.enable = true;

    # Proton-GE taucht in Steam unter "Compatibility" auf.
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamescope = {
    enable = true;
    # Erlaubt Gamescope Echtzeit-Priorität -> weniger Ruckler.
    # Bei Problemen mit manchen Spielen auf false setzen.
    capSysNice = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general.renice = 10;
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode an'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode aus'";
      };
    };
  };

  # Xbox-/PS-Controller
  hardware.xpadneo.enable = true;

  # Manche Spiele (Unity, Proton) brauchen mehr Memory-Maps.
  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt # Proton-GE-Versionen nachladen
    lutris
    heroic # Epic / GOG
    winetricks
    vulkan-tools
    goverlay # GUI für MangoHud/vkBasalt
  ];
}
