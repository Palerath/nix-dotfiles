{pkgs, lib, ...}:
{
   il8n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ mozc-ut ];
   };
}
