# NixOS Flake – AMD Gaming-Desktop

Plasma 6 (abgespeckt) · GRUB Dual-Boot mit Windows · Steam/Gamescope/GameMode · Home Manager als NixOS-Modul.

## Struktur

```
flake.nix
hosts/desktop/
  configuration.nix          Boot, Netzwerk, Locale, User
  hardware-configuration.nix  ← MUSS ersetzt werden
modules/nixos/
  core.nix        Nix-Settings, PipeWire, zram, GC
  amd.nix         Mesa/RADV, 32-Bit, VA-API, LACT
  plasma-lite.nix Plasma 6 ohne Ballast
  gaming.nix      Steam, Gamescope, GameMode, MangoHud
home/home.nix     Home Manager
```

## Vor dem ersten Build anpassen

1. `flake.nix` → `hostname` und `username`
2. `home/home.nix` → Git-Name und -Mail
3. `hosts/desktop/configuration.nix` → Zeitzone/Keymap, falls nicht DE
4. **`hosts/desktop/hardware-configuration.nix` erzeugen:**

```bash
sudo nixos-generate-config --show-hardware-config \
  > hosts/desktop/hardware-configuration.nix
```

## Installieren

```bash
sudo cp -r nixos-config /etc/nixos
cd /etc/nixos
sudo nixos-rebuild switch --flake .#nixos-desktop
```

Danach reicht `rebuild` (Alias auf `nh os switch`).

## Dual-Boot-Hinweise

- `useOSProber = true` findet Windows nur, wenn die Windows-ESP gemountet oder erreichbar ist. Wird Windows nicht gelistet: prüfen, ob es dieselbe EFI-Partition benutzt, und `efiSysMountPoint` korrekt setzen.
- Windows-Fast-Startup in der Systemsteuerung deaktivieren, sonst bleibt die NTFS-Partition gesperrt.
- `time.hardwareClockInLocalTime = true;` verhindert das bekannte Uhrzeit-Springen.

## Was „lightweight" hier konkret heißt

| Maßnahme | Effekt |
|---|---|
| `enableQt5Integration = false` | spart die komplette Qt5-Toolchain (größter Hebel) |
| `services.xserver.enable = false` | reines Wayland, kein Xorg-Server |
| `excludePackages` | Discover, Wallpaper-Pack, Elisa, Okular, Kate … raus |
| Baloo deaktiviert | kein Dateiindexer im Hintergrund |
| `printing.enable = false` | kein CUPS-Stack |

Wenn du eines davon vermisst: Zeile löschen, `rebuild`, fertig. Rückgängig machen kostet nichts.

## Optional nachrüsten

- **plasma-manager** – Plasma-Einstellungen (Panels, Shortcuts, Theme) deklarativ statt klicken. Input: `github:nix-community/plasma-manager`
- **nixos-hardware** – fertige Tweaks für konkrete Mainboards/Laptops
- **sops-nix** – verschlüsselte Secrets im Repo

## Troubleshooting

- Ein `kdePackages.*`-Attribut existiert nicht mehr → Zeile in `plasma-lite.nix` löschen.
- Spiel startet nicht unter Gamescope → `capSysNice = false` in `gaming.nix`.
- Nach Update kaputt: im GRUB-Menü die vorherige Generation booten.
