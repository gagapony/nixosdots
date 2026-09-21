# Paseo daemon + Web UI (https://github.com/getpaseo/paseo)
#
# 部署历史：原 npm 全局装 0.5.1，由 Paseo-Pi/start.sh 手动 `paseo daemon start
# --listen 0.0.0.0:10110 ...` 拉起，数据在 Paseo-Pi/paseo-home。0.9.0 移除了
# --listen 等旗标改用环境变量，遂整体迁到上游 nixosModule + systemd。
#
# 数据已迁到模块默认位置 ~/.paseo（tmpfiles 0700）；密码在 secrets/paseo.yaml
# （sops age 加密），经 sops-nix template 渲染成 EnvironmentFile，明文不进
# store/git。Paseo-Pi 文件夹（~/Documents/.../Paseo-Pi）已完全退役，可归档删除。
{ inputs, pkgs, config, ... }:
{
  imports = [ inputs.paseo.nixosModules.paseo ];

  services.paseo = {
    enable = true;
    package = inputs.paseo.packages.${pkgs.system}.paseo;
    user = "gabriel";
    group = "users";
    # dataDir 不设 → 默认 /home/gabriel/.paseo
    listenAddress = "0.0.0.0"; # lucky 反代在 docker 网络里，同 hermes-webui 需非回环
    port = 10110;
    hostnames = [ "paseo.528777.xyz" "paseo.529777.xyz" ]; # DNS rebinding 防护白名单
    relay.enable = false; # 旧部署未用 relay，保持一致
    inheritUserEnvironment = true; # agent 子进程能找到用户装的 CLI（claude 等）
    environment = {
      PASEO_WEB_UI_ENABLED = "true"; # 0.5.1 的 --web-ui 旗标等价物
      PASEO_TRUSTED_PROXIES = "true"; # 信任 lucky 反代传来的客户端 IP
    };
  };

  # 密码：secrets/paseo.yaml（age 加密）→ /run/secrets-rendered/paseo-env
  sops.secrets."paseo/PASEO_PASSWORD" = {
    sopsFile = ../secrets/paseo.yaml;
    owner = "gabriel";
    mode = "0400";
  };
  sops.templates."paseo-env" = {
    owner = "gabriel";
    mode = "0400";
    content = ''
      PASEO_PASSWORD=${config.sops.placeholder."paseo/PASEO_PASSWORD"}
    '';
  };
  systemd.services.paseo = {
    after = [ "sops-secrets.service" ];
    serviceConfig.EnvironmentFile = config.sops.templates."paseo-env".path;
  };
}
