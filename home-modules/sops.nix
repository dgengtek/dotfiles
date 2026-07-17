{ config, options, lib, pkgs, ... }:
{
  home = {
    packages = [
      pkgs.sops
      pkgs.age
      pkgs.age-plugin-yubikey
    ];
    sessionVariables = {
      SOPS_AGE_RECIPIENTS = "age1yubikey1qd8antqfh8ak2a5serm30vxj38qn3zaltlw6gy0768xm66t0wxz5kvkqwcq";
      SOPS_PGP_FP = "E8A7BB8D37C341113C3DCAD8853206476F1DF5A1";
    };
  };

  sops = {
    gnupg.home = "${config.home.homeDirectory}/.gnupg";
    age.keyFile = "${config.xdg.configHome}/.age.key";
    defaultSopsFile = ../secrets.yaml;
  };
}
