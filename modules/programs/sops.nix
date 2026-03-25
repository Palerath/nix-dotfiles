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
}
