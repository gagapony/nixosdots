{ config, pkgs, lib, ... }:
let
  colors = config.lib.stylix.colors;
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    swaync-client -cp
    sleep 0.3

    if [ "$1" == "full" ]; then
      grim - | swappy -f -
    elif [ "$1" == "area" ]; then
      grim -g "$(slurp)" - | swappy -f -
    else
      echo "Usage: myshot [full|area]"
    fi
  '';
in
{
  home.packages = (with pkgs; [
    swaynotificationcenter
  ]) ++ [
    screenshot
  ];

  services.swaync = {
    enable = true;

    # Config.json 转换为 Nix settings
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      notification-icon-size = 64;
      notification-body-image-height = 128;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 400;
      control-center-height = 650;
      notification-window-width = 350;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "title"
        "menubar#desktop"
        "volume"
        "mpris"
        "dnd"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = " Clear All ";
        };

        "menubar#desktop" = {
          "menu#powermode-buttons" = {
            label = " 󰌪 ";
            position = "left";
            actions = [
              { label = "Performance"; command = "powerprofilesctl set performance"; }
              { label = "Balanced"; command = "powerprofilesctl set balanced"; }
              { label = "Power-saver"; command = "powerprofilesctl set power-saver"; }
            ];
          };

          "menu#screenshot" = {
            label = "  ";
            position = "left";
            actions = [
              { label = "󰩭  Window / Region"; command = "screenshot area"; }
              { label = "󰹑  Whole screen"; command = "screenshot full"; }
            ];
          };

          "menu#record" = {
            label = " 󰕧 ";
            position = "left";
            actions = [
              { label = "  Record screen"; command = "record screen & ; swaync-client -t"; }
              { label = "  Record selection"; command = "record area & ; swaync-client -t"; }
              { label = "  Record GIF"; command = "record gif & ; swaync-client -t"; }
              { label = "󰻃  Stop"; command = "record stop"; }
            ];
          };

          "menu#power-buttons" = {
            label = "  ";
            position = "left";
            actions = [
              { label = "  Lock"; command = "swaylock"; }
              { label = "  Hibernate"; command = "systemctl hibernate"; }
              { label = "  Reboot"; command = "systemctl reboot"; }
              { label = "  Shut down"; command = "systemctl poweroff"; }
            ];
          };
        };

        "backlight#mobile" = {
          label = " 󰃠 ";
          device = "panel";
        };

        volume = {
          label = "";
          expand-button-label = "";
          collapse-button-label = "";
          show-per-app = true;
          show-per-app-icon = true;
          show-per-app-label = false;
        };

        dnd = {
          text = " Do Not Disturb";
        };

        mpris = {
          image-size = 85;
          image-radius = 5;
        };
      };
    };

    # Style.css 转换为 Nix style 字符串，使用 Stylix 颜色变量
    style = ''
      /* 定义颜色变量 */
      @define-color border_color shade(@base04, 1.3);

      label {
        color: @base05;
      }

      /* ========== 通知弹窗 ========== */
      /* 只影响弹窗通知，不影响控制中心 */
      .floating-notifications .notification {
          background-color: transparent;
          border: none;
          box-shadow: none;
      }

      .floating-notifications .notification:hover {
          opacity: 1;
      }

      /* 隐藏弹窗通知的所有按钮和边框 */
      .floating-notifications .notification button,
      .floating-notifications .notification > button,
      .floating-notifications .notification .close-button,
      .floating-notifications .notification .notification-action,
      .floating-notifications .notification .notification-default-action {
          display: none !important;
          border: none !important;
          background: transparent !important;
      }

      .floating-notifications .notification .notification-content {
          min-height: 64px;
          border: none;
          background: transparent;
      }

      /* 移除弹窗通知中所有元素的边框 */
      .floating-notifications .notification * {
          border: none !important;
          box-shadow: none !important;
      }

      /*** Notification ***/
      /* Notification header */
      .summary {
          color: @base05;
          font-size: 16px;
          padding: 0px;
      }

      .time {
          color: @base06;
          font-size: 12px;
          text-shadow: none;
          margin: 0px 0px 0px 0px;
          padding: 2px 0px;
      }

      .body {
          font-size: 14px;
          font-weight: 500;
          color: @base04;
          text-shadow: none;
          margin: 0px 0px 0px 0px;
      }

      .body-image {
          border-radius: 10px;
      }

      /* The "Notifications" and "Do Not Disturb" text widget */
      .top-action-title {
          color: @base05;
          text-shadow: none;
      }

      /* Control center */

      .control-center {
          background-color: @base01;
          opacity: 0.85;
          border-radius: 10px;
      }

      .control-center-list {
          background-color: @base01;
          opacity: 0.85;
          min-height: 5px;
          border-top: none;
          border-radius: 0px 0px 10px 10px;
      }

      .control-center-list-placeholder,
      .notification-group-icon,
      .notification-group {
        color: alpha(@theme_text_color, 0.50);
      }

      .notification-group {
          /* unset the annoying focus thingie */
          all: unset;
          border: none;
          opacity: 0;
          padding: 0px;
          box-shadow: none;
      }
      .notification-group > box {
          all: unset;
          background-color: @base01;
          opacity: 0.8;
          padding: 8px;
          margin: 0px;
          border: none;
          border-radius: 10px;
          box-shadow: none;
      }


      .notification-row {
          outline: none;
          transition: all 0.2s ease;
          background-color: @base00;
          opacity: 0.75;
          border: 1px solid @border_color;
          margin: 8px 10px 0px 10px;
          border-radius: 10px;
      }
      .notification-row:hover {
          opacity: 0.9;
      }

      .notification-row:focus,
      .notification-row:hover {
          box-shadow: none;
      }

      .control-center-list > row,
      .control-center-list > row:focus,
      .control-center-list > row:hover {
          background: transparent;
          border: none;
          margin: 0px;
          padding: 5px 10px 5px 10px;
          box-shadow: none;
      }

      .control-center-list > row:last-child {
          padding: 5px 10px 10px 10px;
      }


      /* Window behind control center and on all other monitors */
      .blank-window {
          background: transparent;
      }

      /*** Widgets ***/

      /* Title widget */
      .widget-title {
          margin: 0px;
          background: inherit;
          border-radius: 10px 10px 0px 0px;
          border-bottom: none;
          padding-bottom: 20px;
      }

      .widget-title > label {
          margin: 18px 10px;
          font-size: 20px;
          font-weight: 500;
      }

      .widget-title > button {
          font-weight: 700;
          padding: 7px 3px;
          margin-right: 10px;
          background: transparent;
          color: @base05;
          border: 1px solid @border_color;
          border-radius: 10px;
      }
      .widget-title > button:hover {
          background-color: @base02; opacity: 0.6;
          border: 1px solid @border_color;
      }

      /* Label widget */
      .widget-label {
          margin: 0px;
          padding: 0px;
          min-height: 5px;
          background: @base01;
          border-radius: 0px 0px 4px 4px;
          border-top: none;
      }
      .widget-label > label {
          font-size: 0px;
          font-weight: 400;
      }

      /* Menubar */
      .widget-menubar {
          background: inherit;
          border-top: none;
          border-bottom: none;
      }
      .widget-menubar > box > box {
          margin: 5px 10px 5px 10px;
          min-height: 40px;
          border-radius: 10px;
          background: transparent;
      }
      .widget-menubar > box > box > button {
          background: transparent;
          border: 1px solid @border_color;
          min-width: 85px;
          min-height: 50px;
          margin-right: 13px;
          font-size: 17px;
          padding: 0px;
      }
      .widget-menubar > box > box > button:hover {
          background-color: @base02; opacity: 0.6;
          border: 1px solid @border_color;
      }
      .widget-menubar > box > box > button:nth-child(4) {
          margin-right: 0px;
      }
      .widget-menubar button:focus {
          box-shadow: none;
      }
      .widget-menubar button:focus:hover {
          background-color: @base02; opacity: 0.6;
          box-shadow: none;
      }

      .widget-menubar > box > revealer > box {
          margin: 5px 10px 5px 10px;
          background: @base01;
          border: 1px solid @border_color;
          border-radius: 10px;
      }
      .widget-menubar > box > revealer > box > button {
          background: transparent;
          min-height: 50px;
          padding: 0px;
          margin: 5px;
      }
      .widget-menubar > box > revealer > box > button:hover {
          background-color: @base02; opacity: 0.6;
      }

      /* Buttons grid */
      .widget-buttons-grid {
          background-color: @base01;
          border-top: none;
          border-bottom: none;
          font-size: 14px;
          font-weight: 500;
          margin: 0px;
          padding: 5px;
          border-radius: 0px;
      }

      .widget-buttons-grid > flowbox > flowboxchild {
          background: transparent;
          border: 1px solid @border_color;
          border-radius: 10px;
          min-height: 50px;
          min-width: 85px;
          margin: 5px;
          padding: 0px;
      }

      .widget-buttons-grid > flowbox > flowboxchild:hover {
          background-color: @base02; opacity: 0.6;
          border: 1px solid @border_color;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button {
          background: transparent;
          border-radius: 10px;
          margin: 0px;
          border: none;
          box-shadow: none;
      }

      /* Mpris widget */
      .widget-mpris {
          padding: 10px;
          padding-bottom: 35px;
          padding-top: 35px;
          margin-bottom: -33px;
      }
      .widget-mpris > box {
          padding: 0px;
          margin: -5px 0px -10px 0px;
          padding: 0px;
          border-radius: 10px;
          background: @base01;
      }
      .widget-mpris > box > button:nth-child(1),
      .widget-mpris > box > button:nth-child(3) {
          margin-bottom: 0px;
      }
      .widget-mpris > box > button:nth-child(1) {
          margin-left: -25px;
          margin-right: -25px;
          opacity: 0;
      }
      .widget-mpris > box > button:nth-child(3) {
          margin-left: -25px;
          margin-right: -25px;
          opacity: 0;
      }

      .widget-mpris-album-art {
        all: unset;
      }

      /* Player button box */
      .widget-mpris > box > carousel > widget > box > box:nth-child(2) {
          margin: 5px 0px -5px 90px;
      }

      /* Player buttons */
      .widget-mpris > box > carousel > widget > box > box:nth-child(2) > button {
          border-radius: 10px;
          border: 1px solid @border_color;
      }
      .widget-mpris > box > carousel > widget > box > box:nth-child(2) > button:hover {
          background-color: @base02; opacity: 0.6;
      }
      carouselindicatordots {
      	opacity: 0;
      }

      .widget-mpris-title {
          color: #eeeeee;
          font-weight: bold;
          font-size: 1.25rem;
          text-shadow: 0px 0px 5px rgba(0, 0, 0, 0.5);
      }
      .widget-mpris-subtitle {
          color: #eeeeee;
          font-size: 1rem;
          text-shadow: 0px 0px 3px rgba(0, 0, 0, 1);
      }

      .widget-mpris-player {
        border-radius: 0px;
      	margin: 0px;
      }
      .widget-mpris-player > box > image {
          margin: 0px 0px -48px 0px;
      }

      .notification-group > box.vertical {
        margin-top: 3px
      }

      /* Backlight and volume widgets */
      .widget-backlight,
      .widget-volume {
          background-color: @base01;
          border-top: none;
          border-bottom: none;
          font-size: 13px;
          font-weight: 600;
          border-radius: 0px;
          margin: 0px;
          padding: 0px;
      }
      .widget-volume > box {
          background: @base01;
          border-radius: 10px;
          margin: 5px 10px 5px 10px;
          min-height: 50px;
      }
      .widget-volume > box > label {
          min-width: 50px;
          padding: 0px;
      }
      .widget-volume > box > button {
          min-width: 50px;
          box-shadow: none;
          padding: 0px;
          border: 1px solid @border_color;
      }
      .widget-volume > box > button:hover {
          background-color: @base02; opacity: 0.6;
      }
      .widget-volume > revealer > list {
          background: @base01;
          border-radius: 10px;
          margin-top: 5px;
          padding: 0px;
      }
      .widget-volume > revealer > list > row {
          padding-left: 10px;
          min-height: 40px;
          background: transparent;
      }
      .widget-volume > revealer > list > row:hover {
          background: transparent;
          box-shadow: none;
          border-radius: 10px;
      }
      .widget-backlight > scale {
          background: transparent;
          border: 1px solid @border_color;
          border-radius: 0px 10px 10px 0px;
          margin: 5px 10px 5px 0px;
          padding: 0px 10px 0px 0px;
          min-height: 50px;
      }
      .widget-backlight > label {
          background: transparent;
          border: 1px solid @border_color;
          margin: 5px 0px 5px 10px;
          border-radius: 10px 0px 0px 10px;
          padding: 0px;
          min-height: 50px;
          min-width: 50px;
      }

      /* DND widget */
      .widget-dnd {
        margin: 8px;
        font-size: 1.1rem;
        padding-top: 20px;
      }

      .widget-dnd>switch {
        font-size: initial;
        border-radius: 10px;
        background: transparent;
        border: 2px solid @border_color;
        box-shadow: none;
      }

      .widget-dnd>switch:checked {
        background-color: @base02; opacity: 0.6;
      }

      .widget-dnd>switch slider {
        background: @base0D;
        border-radius: 10px;
      }

      /* Toggles */
      .toggle:checked {
          background: @base03;
      }
      .toggle:checked:hover {
          background: @base04;
      }

      /* Sliders */
      scale {
          padding: 0px;
          margin: 0px 10px 0px 10px;
      }

      scale trough {
          border-radius: 10px;
          background-color: @base02; opacity: 0.6;
      }

      scale highlight {
          border-radius: 10px;
          min-height: 10px;
          margin-right: -5px;
      }

      scale slider {
          margin: -10px;
          min-width: 10px;
          min-height: 10px;
          background: transparent;
          box-shadow: none;
          padding: 0px;
      }
      scale slider:hover {
      }

      .right.overlay-indicator {
        all: unset;
      }
    '';
  };
}
