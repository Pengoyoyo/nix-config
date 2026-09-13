{ pkgs, ... }:

{
  # amdgpu früh laden -> sauberer Übergang ins Plymouth/KMS
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Pflicht für Steam/Proton

    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
      # rocmPackages.clr.icd   # nur falls du OpenCL/ROCm brauchst
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva-vdpau-driver
    ];
  };

  # RADV (Mesa) statt AMDVLK – schneller und weniger Ärger.
  # AMDVLK bewusst NICHT installieren, sonst kollidieren die ICDs.
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools # vulkaninfo, vkcube
    libva-utils # vainfo
    radeontop
    lact # AMD-Übertaktung/Lüfterkurven (GUI)
  ];

  # LACT-Daemon; weglassen wenn du nicht tunen willst.
  systemd.packages = [ pkgs.lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
}
