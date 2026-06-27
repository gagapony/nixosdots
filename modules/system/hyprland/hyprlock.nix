{ pkgs, inputs, ... }:
{
  home.packages = [ pkgs.hyprlock ];
  xdg.configFile."hypr/hyprlock.conf".text = ''
    $red = rgb(f38ba8)
    $yellow = rgb(f9e2af)
    $lavender = rgb(b4befe)

    $mauve = rgb(cba6f7)
    $mauveAlpha = cba6f7

    $base = rgb(1e1e2e)
    $surface0 = rgb(313244)
    $text = rgb(cdd6f4)
    $textAlpha = cdd6f4

    $accent = $lavender
    $accentAlpha = $mauveAlpha
    $font = JetBrainsMono Nerd Font

    # GENERAL
    general {
      hide_cursor = false
      no_fade_in = false
      grace = 0
      disable_loading_bar = false
    }

    # BACKGROUND
    background {
      monitor =
      path = ${../../../assets/cat-leaves.png}
      color = $base
      blur_passes = 0
    }


    # Time
    label {
      monitor =
      text = cmd[update:1000] echo "$(date +"%k:%M")"
      color = rgba(235, 219, 178, .9)
      font_size = 200
      font_family = JetBrainsMono NF Bold
      position = 0, 270
      halign = center
      valign = center
    }

    # Day
    label {
      monitor =
      text = cmd[update:1000] echo "- $(date +"%A, %B %d") -"
      color = rgba(235, 219, 178, .9)
      font_size = 20
      font_family = FiraCode Nerd Font
      position = 0, 80
      halign = center
      valign = center
    }


    # USER-BOX
    shape {
      monitor =
      size = 350, 50
      color = rgba(225, 225, 225, .2)
      rounding = 15
      border_size = 0
      border_color = rgba(255, 255, 255, 0)
      rotate = 0

      position = 0, -230
      halign = center
      valign = center
    }

    # USER
    label {
      monitor =
      text =   $USER
      color = rgba(235, 219, 178, .9)
      font_size = 16
      font_family = FiraCode Nerd Font
      position = 0, -230
      halign = center
      valign = center
    }

    # INPUT FIELD
    input-field {
      monitor =
      size = 350, 50
      outline_thickness = 0
      rounding = 15
      dots_size = 0.25 # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.4 # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = true
      outer_color = rgba(255, 255, 255, 0)
      inner_color = rgba(225, 225, 225, 0.2)
      font_color = rgba(235, 219, 178, .9)
      fade_on_empty = false
      placeholder_text = <i><span foreground="##ebdbb2e5">Enter Password</span></i>
      hide_input = false
      position = 0, -300
      halign = center
      valign = center
    }
  '';
}
