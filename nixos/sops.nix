# sops-nix 加密 secret 管理（目前仅 vm host 导入）
#
# 原理：secret 以 age 加密后的密文提交进仓库（安全），系统激活时
# sops-nix 用本机 /var/lib/sops-nix/key.txt 解密到 /run/secrets/（tmpfs，
# 不进 /nix/store）。只有「路径」进 store，明文永不落盘 store 或 git。
#
# 想加更多 key：在 secrets/github.yaml 里新增一个 key，再在下面
# sops.secrets 里声明同名条目即可。
{ inputs, config, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    # age 私钥位置：首次部署后由 setup 命令生成，永久保密，不进 git/store。
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets.github_netrc = {
      # secrets/github.yaml 里 github_netrc 这个 key 的值是 netrc 明文，
      # 已被 age 加密。解密后写到 /run/secrets/github_netrc。
      sopsFile = ../secrets/github.yaml;
      owner = "root"; # nix daemon 以 root 运行，需要 root 可读
      mode = "0400";
    };
  };

  # 让 nix daemon 用解密后的 netrc 鉴权 GitHub（替代原来的 access-tokens）。
  # netrc-file 只存路径，真正的内容在 /run/secrets/github_netrc。
  nix.settings.netrc-file = config.sops.secrets.github_netrc.path;
}
