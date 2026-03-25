{
  self,
  inputs,
  ...
}: {
  flake.nixosModule.sops = {
    self,
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.sops-nix.nixosModules.sops];
    environment.systemPackages = with pkgs; [ssh-to-age];

    sops = {
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      defaultSopsFile = ./../../.sops.yaml;

      secrets.smb_username = {};
      secrets.smb_password = {};

      templates."smb-secrets" = {
        content = ''
          username=${config.sops.placeholder.smb_username}
          password=${config.sops.placeholder.smb_password}
        '';
        mode = "0400";
        path = "/run/secrets-rendered/smb-secrets";
      };
    };
  };
  flake.homeModule.sops = {
    self,
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.sops-nix.homeModules.sops];

    sops = {
      age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
      defaultSopsFile = ./../../.sops.yaml;

      secrets.smb_username = {};
      secrets.smb_password = {};

      templates."smb-secrets" = {
        content = ''
          username=${config.sops.placeholder.smb_username}
          password=${config.sops.placeholder.smb_password}
        '';
        mode = "0400";
        path = "${config.home.homeDirectory}/.config/smb-secrets";
      };
    };
  };
}
