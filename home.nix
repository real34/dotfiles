{ pkgs, ... }:

{
  home.stateVersion = "22.05";

  # Temporary overlays for patches
  nixpkgs.overlays = [];

  home.file.".config/traefik/traefik.toml".source = ./files/traefik.toml;
  home.file.".npmrc".source = ./files/.npmrc;

  imports =
    [
      ./packages.nix

      ./programs/git.nix
      ./programs/i3.nix
      ./programs/zsh.nix
    ];

  programs.htop.enable = true;
  programs.vim.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    extensions = [ ];
  };
  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
    terminal = "sakura";
  };
  programs.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        "notify-i3" = "${pkgs.i3}/bin/i3-msg restart";
      };
    };
  };

  services.unclutter.enable = true;
  services.gpg-agent.enable = true;
  services.blueman-applet.enable = true;
}
