# ─────────────────────────────────────────────────────────────────────
# PLATZHALTER – diese Datei MUSS ersetzt werden.
#
# Auf der Zielmaschine:
#
#   sudo nixos-generate-config --show-hardware-config \
#     > hosts/desktop/hardware-configuration.nix
#
# (Oder /etc/nixos/hardware-configuration.nix hierher kopieren.)
#
# Sie enthält deine UUIDs, Mountpoints und erkannten Kernel-Module –
# die kann ich nicht raten, und falsche Werte machen das System
# unbootbar. Deshalb bricht die Evaluation hier bewusst ab.
# ─────────────────────────────────────────────────────────────────────

throw ''
  hosts/desktop/hardware-configuration.nix ist noch der Platzhalter.
  Erzeuge sie mit:
    sudo nixos-generate-config --show-hardware-config > hosts/desktop/hardware-configuration.nix
''
