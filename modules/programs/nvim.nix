{ pkgs, inputs, lib, ... }:
let
  nvim-config = inputs.dotfiles.packages.${pkgs.stdenv.hostPlatform.system}.nvim-config;
  shellAliases = {
    v = "nvim";
    vdiff = "nvim -d";
  };
in
{
  # 基础包安装
  home.packages = (with pkgs; [
    ripgrep
    gcc
    lazygit
    unzip    
    # rust-bin.nightly.latest.default
    lua-language-server    # Lua LSP
    nixpkgs-fmt           # Nix 格式化
    selene               # Lua 静态分析
    stylua               # Lua 格式化
    prettier # JavaScript/TypeScript/CSS/JSON 等格式化
    clang-tools          # C/C++ 格式化工具
    black                # Python 格式化
    nil                  # Nix LSP
    pyright               # Python LSP
  ]);

  # Shell 别名设置
  home.shellAliases = shellAliases;
  programs.nushell.shellAliases = shellAliases;

  # Neovim 主程序配置
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    viAlias = true;
    vimAlias = true;

    # Provider 脚本：跟随 nixpkgs 26.05+ 的新默认（禁用），让构建更精简，
    # 同时消除 home-manager 在 stateVersion < 26.05 下的弃用提示。
    # 若你的 nvim 配置确实用到 :python3 / :ruby，把这两行改成 true 即可。
    withPython3 = false;
    withRuby = false;

    # 编译环境配置
    extraWrapperArgs = with pkgs; [
      "--suffix"
      "LIBRARY_PATH"
      ":"
      "${lib.makeLibraryPath [stdenv.cc.cc zlib]}"

      "--suffix"
      "PKG_CONFIG_PATH"
      ":"
      "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [stdenv.cc.cc zlib]}"
    ];

    # 核心插件
    plugins = with pkgs.vimPlugins; [
      telescope-fzf-native-nvim
      nvim-treesitter.withAllGrammars
    ];
  };

  xdg.configFile = {
    "nvim".source = "${nvim-config}/config/nvim";
  };
}
