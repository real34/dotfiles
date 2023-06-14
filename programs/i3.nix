{ pkgs, ... }:

{
  home.file.".i3status.conf".source = ../files/.i3status.conf;

  xsession.windowManager.i3 =
    let
      modifier = "Mod4";
    in
    {
      enable = true;
      config = {
        assigns = {
          # https://rycee.gitlab.io/home-manager/options.html#opt-xsession.windowManager.i3.config.assigns
        };
        focus = {
          mouseWarping = false; # Whether mouse cursor should be warped to the center of the window when switching focus to a window on a different output.
        };

        modifier = modifier;

        # see https://rycee.gitlab.io/home-manager/options.html#opt-xsession.windowManager.i3.config.keybindings
        keybindings = pkgs.lib.mkOptionDefault {
          "${modifier}+Return" = "exec sakura"; #i3-sensible-terminal

          ### BÉPO ###
          "${modifier}+b" = "kill";
          "${modifier}+d" = "exec rofi -combi-modi 'window#run#ssh#emoji#calc'  -modi 'calc#combi' -show combi";
          "${modifier}+e" = "fullscreen toggle";
          # change container layout (stacked, tabbed, toggle split)
          "${modifier}+u" = "layout stacking";
          "${modifier}+eacute" = "layout tabbed";
          "${modifier}+p" = "layout toggle split";
          "${modifier}+Shift+t" = "i3lock --colour=000000";
          # switch to workspace
          "${modifier}+quotedbl" = "workspace 1";
          "${modifier}+guillemotleft" = "workspace 2";
          "${modifier}+guillemotright" = "workspace 3";
          "${modifier}+parenleft" = "workspace 4";
          "${modifier}+parenright" = "workspace 5";
          "${modifier}+at" = "workspace 6";
          "${modifier}+plus" = "workspace 7";
          "${modifier}+minus" = "workspace 8";
          "${modifier}+slash" = "workspace 9";
          "${modifier}+asterisk" = "workspace 10";
          # move workspaces between outputs
          "${modifier}+Control+Left" = "move workspace to output left";
          "${modifier}+Control+Right" = "move workspace to output right";
          "${modifier}+Control+Up" = "move workspace to output up";
          "${modifier}+Control+Down" = "move workspace to output down";
          # move focused container to workspace
          "${modifier}+Shift+quotedbl" = "move container to workspace 1";
          "${modifier}+Shift+guillemotleft" = "move container to workspace 2";
          "${modifier}+Shift+guillemotright" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+at" = "move container to workspace 6";
          "${modifier}+Shift+plus" = "move container to workspace 7";
          "${modifier}+Shift+minus" = "move container to workspace 8";
          "${modifier}+Shift+slash" = "move container to workspace 9";
          "${modifier}+Shift+asterisk" = "move container to workspace 10";
          ### /BÉPO ###

          # See https://faq.i3wm.org/question/3747/enabling-multimedia-keys.1.html
          # Pulse Audio controls
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%"; #increase sound volume
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%"; #decrease sound volume
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle"; # mute sound

          # Media player controls
          "XF86AudioPlay" = "exec playerctl play";
          "XF86AudioPause" = "exec playerctl pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";

          # Sreen brightness controls
          "XF86MonBrightnessUp" = "exec light -A 2"; # increase screen brightness
          "XF86MonBrightnessDown" = "exec light -U 2"; # decrease screen brightness
        };

        startup = [
          { command = "nextcloud"; notification = false; }
          { command = "setxkbmap -layout fr -variant bepo"; notification = false; }
          { command = "copyq"; notification = false; }
          { command = "numlockx on"; notification = false; } # turn verr num on

          { command = "autorandr -c"; notification = false; }
          { command = "feh --bg-scale /home/pierre/Documents/Graphisme/fc-bg-light-black.png"; notification = false; }

          # docker run -d --net traefik --ip 172.10.0.10 --restart always -v /var/run/docker.sock:/var/run/docker.sock:ro --name traefik -p 80:80 -p 8080:8080 traefik:2.4.9 --api.insecure=true --providers.docker
          { command = "docker start traefik"; notification = false; }
        ];
      };
    };
}
