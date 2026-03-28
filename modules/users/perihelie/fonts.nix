{
  inputs,
  self,
  ...
}: {
  flake.homeModules.fonts = {...}: {
    fonts.fontconfig.enable = true;
  };
  flake.nixosModules.fonts = {pkgs, ...}: {
    fonts.fontDir.enable = true;

    environment.systemPackages = with pkgs; [
      freetype
      wqy_zenhei
      lxgw-wenkai-tc
      zpix-pixel-font
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      font-awesome
      powerline-fonts
      powerline-symbols
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.agave
      liberation_ttf
      fira-code
      fira-code-symbols
      font-awesome
      iosevka

      # Japanese
      hachimarupop
      biz-ud-gothic
      ipafont
      ipaexfont
      ipamjfont
      migmix
      takao
      kochi-substitute
      ricty
      koruri
      migu
      jigmo
    ];

    fonts.fontconfig.localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <match target="scan">
          <test name="family" compare="eq">
            <string>A-OTF Shin Go Pro</string>
          </test>
          <edit name="charset" mode="assign">
            <minus>
              <name>charset</name>
              <charset>
                <range><int>0x0020</int><int>0x024F</int></range>
              </charset>
            </minus>
          </edit>
        </match>
        <match target="scan">
          <test name="family" compare="eq">
            <string>A-OTF Shin Go Pro R</string>
          </test>
          <edit name="charset" mode="assign">
            <minus>
              <name>charset</name>
              <charset>
                <range><int>0x0020</int><int>0x024F</int></range>
              </charset>
            </minus>
          </edit>
        </match>
        <match target="scan">
          <test name="family" compare="eq">
            <string>azukifontP</string>
          </test>
          <edit name="charset" mode="assign">
            <minus>
              <name>charset</name>
              <charset>
                <range><int>0x0020</int><int>0x024F</int></range>
              </charset>
            </minus>
          </edit>
        </match>
      </fontconfig>
    '';
  };
}
