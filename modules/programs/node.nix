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

  # 注意：不要用 home.file 管理 ~/.npmrc。
  # Home Manager 会把它变成指向 nix store 的只读符号链接，
  # 导致 `npm login` 无法写入 auth token（EROFS: read-only file system）。
  # prefix 已由上面的 npm_config_prefix 环境变量生效，
  # ~/.npmrc 交给 npm 自己创建和管理即可。
}