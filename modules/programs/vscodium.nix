{ pkgs, ... }:
let
  marketplace = publisher: name: version: sha256:
    (pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      inherit name publisher version sha256;
    }]);

  # 简写方式定义插件
  monica = marketplace "MonicaIM" "monica-code" "1.2.4" "sha256-N6RQqFpH+McZ7iNIoI+TnPhNZRJNP5MfBjheYhUTzgI=";
  # 如果要添加其他插件，就继续在这里定义
  # somePlugin = marketplace "publisher" "name" "version" "sha256";
in
{
  programs.vscodium = {
    enable = true;
    package =
      (pkgs.vscodium.override
        {
          # isInsiders = true;
          # https://wiki.archlinux.org/title/Wayland#Electron
          commandLineArgs = [
            "--ozone-platform-hint=auto"
            "--ozone-platform=wayland"
            # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
            # (only supported by chromium/chrome at this time, not electron)
            "--gtk-version=4"
            # make it use text-input-v1, which works for kwin 5.27 and weston
            "--enable-wayland-ime"

            # TODO: fix https://github.com/microsoft/vscode/issues/187436
            # still not works...
            "--password-store=gnome" # use gnome-keyring as password store
          ];
        });

    profiles.default.extensions = with pkgs.vscode-extensions; [
      # nix language
      bbenoist.nix
      # nix-shell suport
      arrterian.nix-env-selector
      # python
      ms-python.python
      # C/C++
      ms-vscode.cpptools
      ms-vscode.cpptools-extension-pack
      twxs.cmake
      ms-vscode.cmake-tools
      # OCaml
      ocamllabs.ocaml-platform

      # Color theme
      catppuccin.catppuccin-vsc


      # Vim
      vscodevim.vim
    ];
    # ++ monica;

    profiles.default.userSettings = {
      "update.mode" = "none";
      "extensions.autoUpdate" = false; # This stuff fixes vscode freaking out when theres an update
      # "window.titleBarStyle" = "custom"; # needed otherwise vscode crashes, see https://github.com/NixOS/nixpkgs/issues/246509

      "window.menuBarVisibility" = "toggle";
      "vsicons.dontShowNewVersionMessage" = true;
      "explorer.confirmDragAndDrop" = false;
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "workbench.startupEditor" = "none";

      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.formatOnPaste" = true;

      "workbench.layoutControl.type" = "menu";
      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.value" = 10;
      "workbench.editor.limit.perEditorGroup" = true;
      "workbench.editor.showTabs" = "multiple";
      "files.autoSave" = "onWindowChange";
      "explorer.openEditors.visible" = 0;
      "breadcrumbs.enabled" = false;
      "editor.renderControlCharacters" = false;
      # "workbench.activityBar.location" = "left";
      "workbench.statusBar.visible" = true;
      "editor.scrollbar.verticalScrollbarSize" = 2;
      "editor.scrollbar.horizontalScrollbarSize" = 2;
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollbar.horizontal" = "hidden";
      "workbench.layoutControl.enabled" = false;

      "editor.mouseWheelZoom" = true;

      "C_Cpp.autocompleteAddParentheses" = true;
      "C_Cpp.formatting" = "clangFormat";
      "C_Cpp.vcFormat.newLine.closeBraceSameLine.emptyFunction" = true;
      "C_Cpp.vcFormat.newLine.closeBraceSameLine.emptyType" = true;
      "C_Cpp.vcFormat.space.beforeEmptySquareBrackets" = true;
      "C_Cpp.vcFormat.newLine.beforeOpenBrace.block" = "sameLine";
      "C_Cpp.vcFormat.newLine.beforeOpenBrace.function" = "sameLine";
      "C_Cpp.vcFormat.newLine.beforeElse" = false;
      "C_Cpp.vcFormat.newLine.beforeCatch" = false;
      "C_Cpp.vcFormat.newLine.beforeOpenBrace.type" = "sameLine";
      "C_Cpp.vcFormat.space.betweenEmptyBraces" = true;
      "C_Cpp.vcFormat.space.betweenEmptyLambdaBrackets" = true;
      "C_Cpp.vcFormat.indent.caseLabels" = true;
      "C_Cpp.intelliSenseCacheSize" = 2048;
      "C_Cpp.intelliSenseMemoryLimit" = 2048;
      "C_Cpp.default.browse.path" = [
        ''''${workspaceFolder}/**''
      ];
      "C_Cpp.default.cStandard" = "gnu11";
      "C_Cpp.inlayHints.parameterNames.hideLeadingUnderscores" = false;
      "C_Cpp.intelliSenseUpdateDelay" = 500;
      "C_Cpp.workspaceParsingPriority" = "medium";
      "C_Cpp.clang_format_sortIncludes" = true;
      "C_Cpp.doxygen.generatedStyle" = "/**";
      "vim.insertModeKeyBindings" = [
        {
          "before" = ["j" "k"];
          "after" = ["<Esc>"];
        }
        {
          "before" = ["<C-s>"];
          "commands" = ["workbench.action.files.save"];
        }
      ];
    };
    # Keybindings
    profiles.default.keybindings = [
      {
        key = "ctrl+q";
        command = "editor.action.commentLine";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "ctrl+s";
        command = "workbench.action.files.saveFiles";
      }
    ];
  };
}
