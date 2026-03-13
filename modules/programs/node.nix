{ config, pkgs, ... }:

{
  # 1. 自动设置环境变量
  home.sessionVariables = {
    npm_config_prefix = "$HOME/.npm";
  };

  # 2. 将全局路径加入 PATH
  home.sessionPath = [
    "$HOME/.npm/bin"
  ];

  # 3. (可选) 也可以直接写 .npmrc 文件
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm
  '';
}