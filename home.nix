{ pkgs, ... }:

{
  home.stateVersion = "22.05";

  home.file.".config/traefik/traefik.toml".source = ./files/traefik.toml;

  imports =
    [
      ./packages.nix

      ./programs/git.nix
      ./programs/i3.nix
      ./programs/zsh.nix
    ];

  programs.vscode = {
    enable = true;
    extensions = [ ];
  };

  services.unclutter.enable = true;
  services.gpg-agent.enable = true;
  services.blueman-applet.enable = true;

  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
    terminal = "sakura";
  };

  programs.htop = {
    enable = true;
  };

  programs.vim = {
    enable = true;
  };

  programs.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        "notify-i3" = "${pkgs.i3}/bin/i3-msg restart";
      };
    };
  };
}
