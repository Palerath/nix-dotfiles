{pkgs, ...}:
{
   environment.systemPackages = with pkgs; [
      python3Full
      pipx
      (python3.withPackages (python-pkgs: with python-pkgs; [
         pandas
         numpy
         matplotlib
         requests
      ]))
   ];
}
