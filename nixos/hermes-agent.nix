# Hermes Agent — 原生 systemd 部署（Mode A，纯 Nix）
#
# 设计理念（与 gabriel 共识）：
#   • 自我进化 = 纯文本进化（memory / skill / 提示词），数据落在可写的 HERMES_HOME
#   • 系统级装包交给项目里的 direnv + shell.nix/flake.nix（Nix 原生手段），
#     agent 只需“学会”用它——这本身就是一个 skill（你教它 / 它自己生成）
#   • API key / 模型选择：部署后用 `hermes setup` 自己配，Nix 不碰 .env / config.yaml
#     （模块在 environment/environmentFiles 均为空时，activation 不会覆盖 ~/.hermes/.env；
#      config.yaml 走深合并，保留你用 `hermes model` 配的 provider）
#
# 两个 systemd 服务：
#   • hermes-agent     → `hermes gateway`（messaging：Telegram 等出站连接，无需开入站端口）
#   • hermes-webui     → 社区 Web UI（nesquena/hermes-webui，进程内直跑 agent，
#                        读同一 HERMES_HOME，替代原 hermes-dashboard，端口不变、lucky 规则不动）
#
# 默认 package = full，已内建 anthropic + messaging(telegram/discord/slack) + voice，
# 你的 OpenAI/Anthropic 兼容端点（火山 ARK / Z.AI GLM / opkaa / WindApi）开箱即用。
{ inputs, pkgs, config, lib, ... }:
let
  hcfg = config.services.hermes-agent;
  hermesPkg = hcfg.package;          # full，已含 anthropic/messaging/voice
  dashboardPort = 9119;
  # 绑 0.0.0.0：反代 lucky 跑在隔离的 docker 网络里，够不到宿主 127.0.0.1。
  # 新版 Hermes 要求非回环绑定必须配 basic_auth（见 config.yaml dashboard.basic_auth）。
  dashboardBind = "0.0.0.0";
in
{
  imports = [
    inputs.hermes-agent.nixosModules.default
    inputs.hermes-webui.nixosModules.default
  ];

  services.hermes-agent = {
    enable = true;
    user = "gabriel";
    group = "users";
    createUser = false;              # gabriel 已是普通用户，勿重复创建
    addToSystemPackages = true;      # 宿主 `hermes` CLI + HERMES_HOME 系统级共享
    restart = "on-failure";
    # 故意不设 environment / environmentFiles → activation 不写 ~/.hermes/.env
    # settings 走深合并，保留用户自行配置的模型/provider。
    settings = {
      platforms.telegram.reactions = true;
    };
  };

  # ── Web UI：hermes-webui 平替 hermes dashboard ──
  # 进程内直跑 agent（不依赖 gateway/独立 API server），共用 HERMES_HOME。
  # agent.python 指向 hermes 包的 uv2nix venv —— 已验证该 python 能同时
  # import webui 依赖（pyyaml/cryptography）和 agent（run_agent）。
  # 端口沿用 9119：lucky 反代规则零修改。绑 0.0.0.0 同原 dashboard。
  services.hermes-webui = {
    enable = true;
    user = hcfg.user; # 与 gateway 同用户，才能读写同一 HERMES_HOME
    group = hcfg.group;
    host = dashboardBind;
    port = dashboardPort;
    openFirewall = true; # 替代原手工 allowedTCPPorts
    hermesHome = "${hcfg.stateDir}/.hermes";
    agent.python = "${hermesPkg.passthru.hermesVenv}/bin/python3";
    # webui 模块不带 PATH：进程内 agent 要 which() 到 git/rg/node 等工具，
    # systemd 默认 PATH 在 NixOS 上找不到，必须显式给。hermesPkg 让 wrapped
    # `hermes` CLI 也可用（子 agent / doctor 等）。
    # HOME 对齐 gateway（= HERMES_HOME 父目录）：webui 的 workspace 信任规则是
    # “用户 home 之下优先于 /var 黑名单”，不设 HOME 时 /var/lib/hermes/workspace
    # 被当系统目录拒绝；对齐后两个 hermes 进程的 ~ 展开也一致。
    extraEnvironment = {
      HOME = hcfg.stateDir;
      PATH = lib.makeBinPath ([
        hermesPkg
        (hermesPkg.passthru.hermesNpmLib.nodejs or pkgs.nodejs)
      ] ++ (with pkgs; [ bash coreutils git ripgrep openssh ffmpeg ]));
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      TZDIR = "${pkgs.tzdata}/share/zoneinfo";
    };
  };
}
